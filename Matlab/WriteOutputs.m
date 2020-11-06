function WriteOutputs(ImbalanceLoop);
global INIT INPUTS OUTPUTS PRICES

%% Delete previous output files
if ImbalanceLoop == 1
  for j = 1:2
    FilesToDelete = {'ExternalInputs.xlsx','CHPResults.xlsx','GasStorage.xlsx','HeatBuffer.xlsx','MarketPrices.xlsx','ProfitAndLoss.xlsx','Summary.xlsx'};
    FilesToDelete2 = {'ExternalInputsImbalance.xlsx','CHPResultsImbalance.xlsx','GasStorageImbalance.xlsx','HeatBufferImbalance.xlsx','MarketPricesImbalance.xlsx','ProfitAndLossImbalance.xlsx','SummaryImbalance.xlsx'};

    for i = 1:7
      if j == 1
        FileToDelete = [INIT.OutputfolderName,INIT.slash,char(FilesToDelete(i))];
      else
        FileToDelete = [INIT.OutputfolderName,INIT.slash,char(FilesToDelete2(i))];
      end
      if exist(FileToDelete)
        xls_check_if_open(FileToDelete,'close');
        delete(FileToDelete);
      end
    end
  end 
end

%% Write Heat demand, Biogas production
Output = OUTPUTS.ExternalInputs(:,:);
if ImbalanceLoop == 1
  FileToStore = [INIT.OutputfolderName,INIT.slash,'ExternalInputs.xlsx'];
else
  FileToStore = [INIT.OutputfolderName,INIT.slash,'ExternalInputsImbalance.xlsx'];
end    
xlswrite(FileToStore,Output,1,'A1');

%% CHP and gas consumption per CHP per hour
Output = OUTPUTS.CHPResults(:,:);
if ImbalanceLoop == 1
  FileToStore = [INIT.OutputfolderName,INIT.slash,'CHPResults.xlsx'];
else
  FileToStore = [INIT.OutputfolderName,INIT.slash,'CHPResultsImbalance.xlsx'];
end    
xlswrite(FileToStore,Output,1,'A1');

%% Gas Storage
Output = OUTPUTS.Gas(:,:);
if ImbalanceLoop == 1
  FileToStore = [INIT.OutputfolderName,INIT.slash,'GasStorage.xlsx'];
else
  FileToStore = [INIT.OutputfolderName,INIT.slash,'GasStorageImbalance.xlsx'];
end    
xlswrite(FileToStore,Output,1,'A1');

%% Heat Buffer
Output = OUTPUTS.Heat(:,:);
if ImbalanceLoop == 1
  FileToStore = [INIT.OutputfolderName,INIT.slash,'HeatBuffer.xlsx'];
else
  FileToStore = [INIT.OutputfolderName,INIT.slash,'HeatBufferImbalance.xlsx'];
end
xlswrite(FileToStore,Output,1,'A1');

%% Prices and Income
Output = OUTPUTS.Prices(:,:);
if ImbalanceLoop == 1
  FileToStore = [INIT.OutputfolderName,INIT.slash,'MarketPrices.xlsx'];
else
  FileToStore = [INIT.OutputfolderName,INIT.slash,'MarketPricesImbalance.xlsx'];
end    
xlswrite(FileToStore,Output,1,'A1');

%% Profit & Loss
Output = OUTPUTS.Profit(:,:);
if ImbalanceLoop == 1
  FileToStore = [INIT.OutputfolderName,INIT.slash,'ProfitAndLoss.xlsx'];
else
  FileToStore = [INIT.OutputfolderName,INIT.slash,'ProfitAndLossImbalance.xlsx'];
end
xlswrite(FileToStore,Output,1,'A1');

%% Summary
[yy1,mm1,dd1] = datevec(INPUTS.Startdate); 
[yy2,mm2,dd2] = datevec(INPUTS.Enddate); 
NrOfYears = yy2 - yy1 + 1;

Summary = zeros(2,NrOfYears);
for i = 1:NrOfYears
    Yeari = yy1+i-1;
    Date1 = datenum(Yeari,1,1);
    Date2 = datenum(Yeari,12,31);
    
    if Date1 < INPUTS.Startdate
      Date1 = INPUTS.Startdate;
    end
    if Date2 > INPUTS.Enddate
      Date2 = INPUTS.Enddate;
    end
    
    Ind1 = find(PRICES.POWER.Date == Date1,1,'first');
    Ind2 = find(PRICES.POWER.Date == Date2,1,'last');
    Help1 = find(PRICES.POWER.Date == INPUTS.Startdate,1,'first') - 1;
    Summary(1,i) = Yeari;
    Summary(2,i) = sum(sum(OUTPUTS.Profit(Ind1-Help1:Ind2-Help1,1:9))) - ...
        sum(sum(OUTPUTS.Gas(Ind1-Help1:Ind2-Help1,4)));
end
Output = Summary;

if ImbalanceLoop == 1
  FileToStore = [INIT.OutputfolderName,INIT.slash,'Summary.xlsx'];
else
  FileToStore = [INIT.OutputfolderName,INIT.slash,'SummaryImbalance.xlsx'];
end
xlswrite(FileToStore,Output,1,'A1');

if ImbalanceLoop == 1

  %% Settings
  FileToDelete = [INIT.OutputfolderName,INIT.slash,'Settings.xlsx'];
  if exist(FileToDelete)
    xls_check_if_open(FileToDelete,'close');
    delete(FileToDelete);
  end
  
  Output = zeros(29,3);

  Output(1,1) = INPUTS.Startdate - INIT.x2m;
  Output(2,1) = INPUTS.Enddate - INIT.x2m;

  for i = 1:3
    
    Output(8,i) = INPUTS.BHKW.MaxLoad(i);
    Output(9,i) = INPUTS.BHKW.MaxHeat(i);
    Output(10,i) = INPUTS.BHKW.MaxEff(i);
    
    Output(12,i) = INPUTS.BHKW.MinLoad(i);
    
    Output(14,i) = INPUTS.BHKW.VOM(i);

    Output(16,i) = INPUTS.BHKW.MaxStartsPerDay(i);
    Output(17,i) = INPUTS.BHKW.MaxFullLoadHoursPerYear(i);

  end
  
  Output(19,1) = INPUTS.Biogas;

  Output(20,1) = INPUTS.GASSTORAGE.MinVolume;
  Output(21,1) = INPUTS.GASSTORAGE.MaxVolume;
  Output(22,1) = INPUTS.GASSTORAGE.InjCosts;
  
  Output(24,1) = INPUTS.HEATBUFFER.MinVolume;
  Output(25,1) = INPUTS.HEATBUFFER.MaxVolume;
  Output(26,1) = INPUTS.HEATBUFFER.HeatLoss;
  
  Output(28,1) = INPUTS.IMBALANCE.Long;
  Output(29,1) = INPUTS.IMBALANCE.Short;
  
  FileToStore = [INIT.OutputfolderName,INIT.slash,'Settings.xlsx'];
  xlswrite(FileToStore,Output,1,'A1');

  xlswrite(FileToStore,INPUTS.OptimizationMethod,1,'A3');
  xlswrite(FileToStore,INPUTS.BHKW.Name,1,'A5');
  xlswrite(FileToStore,INPUTS.BHKW.Include,1,'A6');

  %% Flex Premium
  
  FileToDelete = [INIT.OutputfolderName,INIT.slash,'FlexPremium.xlsx'];
  if exist(FileToDelete)
    xls_check_if_open(FileToDelete,'close');
    delete(FileToDelete);
  end

  InstalledCapacity = 0;
  for i = 1:INPUTS.NrCHP
    InstalledCapacity = InstalledCapacity + INPUTS.BHKW.MaxLoad(i);
  end

  NrDays = INPUTS.Enddate - INPUTS.Startdate + 1;
  PowerProd = sum(sum(OUTPUTS.CHPResults(:,1:3))) / NrDays * 365;

  Output = zeros(2,1);
  Output(1,1) = InstalledCapacity;
  Output(2,1) = PowerProd;

  FileToStore = [INIT.OutputfolderName,INIT.slash,'FlexPremium.xlsx'];
  xlswrite(FileToStore,Output,1,'A1');
  
  %% Monthly prices
  
  FileToDelete = [INIT.OutputfolderName,INIT.slash,'MonthlyPrices.xlsx'];
  if exist(FileToDelete)
    xls_check_if_open(FileToDelete,'close');
    delete(FileToDelete);
  end
  
  Output = zeros(NrOfYears * 12,3);
  for i = 1:NrOfYears
    for j = 1:12
      Output(j+(i-1)*12,1) = yy1+i-1;
      Output(j+(i-1)*12,2) = j;
      Output(j+(i-1)*12,3) = PRICES.MonthlyPrices(j);
    end
  end

  FileToStore = [INIT.OutputfolderName,INIT.slash,'MonthlyPrices.xlsx'];
  xlswrite(FileToStore,Output,1,'A1');

  %% Dates
  FileToDelete = [INIT.OutputfolderName,INIT.slash,'Dates.xlsx'];
  if exist(FileToDelete)
    xls_check_if_open(FileToDelete,'close');
    delete(FileToDelete);
  end
  
  NrOfDays = INPUTS.Enddate - INPUTS.Startdate + 1;
  Output = zeros(NrOfDays,4);
  HourArray = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]';

  for i = 1:NrOfDays
    [yy1,mm1,dd1] = datevec(INPUTS.Startdate + i - 1);  
    Ind1 = (i-1) * 24 + 1;
    Ind2 = i*24;
    Output(Ind1:Ind2,1) = repmat(yy1,24,1);
    Output(Ind1:Ind2,2) = repmat(mm1,24,1);
    Output(Ind1:Ind2,3) = repmat(dd1,24,1);
    Output(Ind1:Ind2,4) = HourArray;
  end
  
  FileToStore = [INIT.OutputfolderName,INIT.slash,'Dates.xlsx'];
  xlswrite(FileToStore,Output,1,'A1');

end



end 