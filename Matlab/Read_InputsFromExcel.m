function Read_InputsFromExcel
global INIT INPUTS

[DataN, DataT] = xlsread(INIT.FullDashboardName,'Inputs');
 
% Read all text fields

INPUTS.Startdate = datenum(DataN(1,3),DataN(2,3),DataN(3,3));
INPUTS.Enddate = datenum(DataN(4,3),DataN(5,3),DataN(6,3));
INPUTS.NrDays = INPUTS.Enddate - INPUTS.Startdate + 1;
INPUTS.NrHours = INPUTS.NrDays * 24;
INPUTS.OptimizationMethod = DataT(11,5);

INPUTS.BHKW.Name = [DataT(18,4), DataT(18,5), DataT(18,6)];
INPUTS.BHKW.Include = [DataT(19,4), DataT(19,5), DataT(19,6)];

INPUTS.NrCHP = 0;
for c = 1:size(INPUTS.BHKW.Include,2)
  if strcmpi(INPUTS.BHKW.Include(c),'Yes')  
    INPUTS.NrCHP = INPUTS.NrCHP + 1;  
  end
end

% Read all numeric fields
INPUTS.BHKW.MaxLoad = [DataN(19,1),DataN(19,2),DataN(19,3)];
INPUTS.BHKW.MaxHeat = [DataN(20,1),DataN(20,2),DataN(20,3)];
INPUTS.BHKW.MaxEff = [DataN(21,1),DataN(21,2),DataN(21,3)];

INPUTS.BHKW.MinLoad = [DataN(24,1),DataN(24,2),DataN(24,3)];

INPUTS.BHKW.VOM = [DataN(27,1),DataN(27,2),DataN(27,3)];
INPUTS.BHKW.MaxStartsPerDay = [DataN(30,1),DataN(30,2),DataN(30,3)];
INPUTS.BHKW.MaxFullLoadHoursPerYear = [DataN(31,1),DataN(31,2),DataN(31,3)];

INPUTS.Biogas = DataN(14,10);

INPUTS.GASSTORAGE.StartVolume = 0;
INPUTS.GASSTORAGE.EndVolume = 0;
INPUTS.GASSTORAGE.MinVolume = DataN(17,10);
INPUTS.GASSTORAGE.MaxVolume = DataN(18,10);
INPUTS.GASSTORAGE.InjCosts = DataN(19,10);
INPUTS.GASSTORAGE.Inject = INPUTS.Biogas * ones(INPUTS.NrHours,1);
INPUTS.GASSTORAGE.Withdraw = INPUTS.Biogas * ones(INPUTS.NrHours,1);

INPUTS.HEATBUFFER.StartVolume = 0;
INPUTS.HEATBUFFER.EndVolume = 0;
INPUTS.HEATBUFFER.MinVolume = DataN(22,10);
INPUTS.HEATBUFFER.MaxVolume = DataN(23,10);
INPUTS.HEATBUFFER.HeatLoss = DataN(24,10);

INPUTS.HeatProduction = DataT(30,13);
INPUTS.IMBALANCE.Long = DataN(30,10);

INPUTS.MaxProd = 0;
INPUTS.MinProd = zeros(3,1);

for c = 1:3
  if strcmpi(INPUTS.BHKW.Include(c),'Yes')  
    INPUTS.MaxProd = INPUTS.MaxProd + INPUTS.BHKW.MaxLoad(c);  
    INPUTS.MinProd(c,1) = INPUTS.BHKW.MinLoad(c);
  else
    INPUTS.MinProd(c,1) = max(INPUTS.BHKW.MaxLoad);
  end
end
INPUTS.MaxProd = INPUTS.MaxProd - INPUTS.IMBALANCE.Long;
INPUTS.MinProd = min(INPUTS.MinProd );

INPUTS.IMBALANCE.Short = DataN(32,10);

INPUTS.DaysPerLoop = 2;
if (INPUTS.IMBALANCE.Long > 0 || INPUTS.IMBALANCE.Short > 0)
  INPUTS.ImbalanceLoop = 2;
  INPUTS.IMBALANCE.Short = INPUTS.MinProd + INPUTS.IMBALANCE.Short;
else
  INPUTS.ImbalanceLoop = 1;
end

INPUTS.NrOfLoops = ceil((INPUTS.Enddate - INPUTS.Startdate + 1) / (INPUTS.DaysPerLoop/2));