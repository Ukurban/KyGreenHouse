function OutputPerLoop;
global MODEL INIT INPUTS PRICES OUTPUTS

Startdate = INPUTS.StartdateLoop;
Enddate = INPUTS.EnddateLoop - 1;

Ind1 = find(PRICES.POWER.Date == Startdate,1,'first');
Ind2 = find(PRICES.POWER.Date == Enddate,1,'last');

Ind3 = find(PRICES.HEAT.Date == Startdate,1,'first');
Ind4 = find(PRICES.HEAT.Date == Enddate,1,'last');

NrHoursLoop = (Enddate - Startdate + 1) * 24;
NrHours = (INPUTS.Enddate - INPUTS.Startdate + 1) * 24;

Help1 = find(PRICES.POWER.Date == INPUTS.Startdate,1,'first') - 1;

%% Write Heat demand, Biogas production
if INPUTS.Loop == 1
  OUTPUTS.ExternalInputs = zeros(NrHours,2);
end

ExternalInputs(:,1) = PRICES.HEAT.Demand(Ind3:Ind4,1);
ExternalInputs(:,2) = INPUTS.Biogas(1);
OUTPUTS.ExternalInputs(Ind1-Help1:Ind2-Help1,:)= ExternalInputs(:,:);

%% CHP and gas consumption per CHP per hour
fulload = zeros(NrHoursLoop,3);
CHP_Gas = zeros(NrHoursLoop,3);
CHP_Heat = zeros(NrHoursLoop,3);

for i = 1:INPUTS.NrCHP
  CHP_Gas(:,i) = MODEL.VAR.VAL.RunCHP(1:24,i) / INPUTS.BHKW.MaxEff(i);    
  CHP_Heat(:,i) = MODEL.VAR.VAL.RunCHP(1:24,i) / INPUTS.BHKW.MaxLoad(i) * INPUTS.BHKW.MaxHeat(i);
  ind = find(MODEL.VAR.VAL.RunCHP(1:24,i) > 0.9 * INPUTS.BHKW.MaxLoad(i));
  fulload(ind,i) = 1;
end

if INPUTS.Loop == 1
  OUTPUTS.CHPResults = zeros(NrHours,17);
  OUTPUTS.Heat = zeros(NrHours,4);
end

CHPResults = zeros(NrHoursLoop,17);
CHPResults(:,1:INPUTS.NrCHP) = MODEL.VAR.VAL.RunCHP(1:24,1:INPUTS.NrCHP);
CHPResults(:,4:3+INPUTS.NrCHP) = CHP_Gas(1:24,1:INPUTS.NrCHP);
CHPResults(:,7:6+INPUTS.NrCHP) = CHP_Heat(1:24,1:INPUTS.NrCHP);
CHPResults(:,15:14+INPUTS.NrCHP) = fulload(1:24,1:INPUTS.NrCHP);
OUTPUTS.CHPResults(Ind1-Help1:Ind2-Help1,:) = CHPResults(:,:);

if INPUTS.Loop == INPUTS.NrOfLoops
  starts = zeros(NrHours,3);
  for i = 1:INPUTS.NrCHP
    if OUTPUTS.CHPResults(1,i) > 0 
      starts(1,i) = 1;
    end
    for j = 2:NrHours
      if OUTPUTS.CHPResults(j,i) > 0 && OUTPUTS.CHPResults(j-1,i) == 0
        starts(j,i) = 1;
      else
        starts(j,i) = 0;
      end
    end
  end
  OUTPUTS.CHPResults(:,11:13) = starts;
end

%% Gas Storage
if INPUTS.Loop == 1
  OUTPUTS.Gas = zeros(NrHours,4);
end

Gas = zeros(NrHoursLoop,4);
if INPUTS.isGasStorage
   Gas(:,1) = MODEL.VAR.VAL.InjectGas(1:24)';
   Gas(:,2) = MODEL.VAR.VAL.WithdrawGas(1:24)';
   Gas(:,3) = MODEL.VAR.VAL.GasStorageLevel(1:24)';
   Gas(:,4) = Gas(:,1) * INPUTS.GASSTORAGE.InjCosts / 1000;
end
OUTPUTS.Gas(Ind1-Help1:Ind2-Help1,:) = Gas(:,:);

%% Heat Buffer
if INPUTS.Loop == 1
  OUTPUTS.Heat = zeros(NrHours,4);
end

Heat = zeros(NrHoursLoop,4);
Heat(:,1) = MODEL.VAR.VAL.InjectHeat(1:24)';
Heat(:,2) = MODEL.VAR.VAL.WithdrawHeat(1:24)';
Heat(:,3) = MODEL.VAR.VAL.HeatBufferLevel(1:24)';
for j = 2:NrHoursLoop
  Heat(j,4) = MODEL.VAR.VAL.HeatBufferLevel(j-1) * INPUTS.HEATBUFFER.HeatLoss;
end
% Heat(:,5) = MODEL.VAR.VAL

OUTPUTS.Heat(Ind1-Help1:Ind2-Help1,:) = Heat(:,:);

%% Prices and Income
if INPUTS.Loop == 1
  OUTPUTS.Prices = zeros(NrHours,7);
end

Prices = zeros(NrHoursLoop,7);
Prices(:,1) = PRICES.POWER.EEX(Ind1:Ind2,1);
if strcmp(INPUTS.OptimizationMethod,'Monthly Average')
  Prices(:,3) = PRICES.MonthlyAvg(Ind1:Ind2,1);
  Prices(:,2) = Prices(:,1) - Prices(:,3);
elseif strcmp(INPUTS.OptimizationMethod,'Daily Average')
  Prices(:,3) = PRICES.DailyAvg(Ind1:Ind2,1);
  Prices(:,2) = Prices(:,1) - Prices(:,3);
elseif strcmp(INPUTS.OptimizationMethod,'Market')
  Prices(:,2) = 0;
  Prices(:,3) = Prices(:,1);
  Prices(:,4) = INPUTS.BHKW.VOM(1);
  Prices(:,5) = INPUTS.BHKW.VOM(2);
  Prices(:,6) = INPUTS.BHKW.VOM(3);
  Prices(:,7) = PRICES.GAS.Price(Ind1:Ind2,1);
end
OUTPUTS.Prices(Ind1-Help1:Ind2-Help1,:) = Prices;

%% Profit & Loss
if INPUTS.Loop == 1
  OUTPUTS.Profit = zeros(NrHours,9);
end

Profit = zeros(NrHoursLoop,9);
for i = 1:INPUTS.NrCHP
  Profit(:,i) = MODEL.VAR.VAL.RunCHP(1:24,i) .* Prices(:,3) / 1000;
  
  if strcmp(INPUTS.OptimizationMethod,'Market')
    Profit(:,3+i) = MODEL.VAR.VAL.RunCHP(1:24,i) .* -Prices(:,3+i) / 1000;
    Profit(:,6+i) = MODEL.VAR.VAL.RunCHP(1:24,i)/INPUTS.BHKW.MaxEff(i) .* -Prices(:,7) / 1000;
  else
    Profit(:,3+i) = 0;
    Profit(:,6+i) = 0;
  end
end
OUTPUTS.Profit(Ind1-Help1:Ind2-Help1,:) = Profit(:,:);

end 