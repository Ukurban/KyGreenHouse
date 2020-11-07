function Read_PriceData_HeatDemand
global INIT PRICES

%% Read Hourly Power Prices
Inputfile = [INIT.InputfolderName, INIT.slash, 'PowerPrices.xls'];
xls_check_if_open(Inputfile,'close');
[DataN, DataT] = xlsread(Inputfile);

Years = DataN(1,2:end);
StartDate = datenum(Years(1),1,1);
EndDate = datenum(Years(1,end),12,31);
NrDays = (EndDate - StartDate + 1);
NrHours = (EndDate - StartDate + 1) * 24;
NrYears = Years(end) - Years(1) + 1;

d = (StartDate:EndDate);
Hour2day = zeros(NrHours,1);
d24 = repmat(d,24,1);
Hour2day = d24(:);

Hour = zeros(24,1);
for i=1:24
  Hour(i) = (i-1)/24;
end
HoursArray = repmat(Hour,NrDays,1);

Date = Hour2day;
Hour = HoursArray;
DateAndHour = Date + Hour;

PRICES.POWER.Date = Date;
PRICES.POWER.Hour = Hour;
PRICES.POWER.DateAndHour = DateAndHour;

PowerPrices = zeros(length(PRICES.POWER.Date),1);

PRICES.DailyAvg = zeros(length(PRICES.POWER.Date),1);
PRICES.MonthlyAvg = zeros(length(PRICES.POWER.Date),1);
PRICES.MonthlyPrices = zeros(NrYears * 12,1);

indend = 0;
indbegin = 1;
monthi = 1;

for i = 1:NrYears
    
  ind = ~isnan(DataN(2:end,1+i));
  ind2 = find(ind == 0,1,'first');
  if isempty(ind2)
    ind2 = 8785;
  end
  prices = DataN(2:ind2,1+i);
  
  indend = indend + ind2 - 1;
  PowerPrices(indbegin:indend,1) = prices;
  
  % Calculate daily and monthly average prices
  [y,m,d] = datevec(Date(indbegin:indend,1));
  MonthlyAvg = zeros(length(y),1);
  DailyAvg = zeros(length(y),1); 
  
  for j = 1:12
    indm = [];
    M_Avg = 0;
    indm = find(m == j);
    
    if ~isempty(indm)
      M_Avg = sum(prices(indm,1)/ length(indm));
        
      nrdays = length(indm)/24;
      for k = 1:nrdays
        indd = [];
        D_Avg = zeros(nrdays,1);
        indd = find(d(indm) == k);
        indd = indm(indd);
           
        if ~isempty(indd)
          D_Avg = sum(prices(indd,1)/ length(indd));
          DailyAvg(indd,1) = prices(indd,1) - D_Avg;
        end
      end
    end
    
    MonthlyAvg(indm,1) = prices(indm,1) - M_Avg;
    
    PRICES.MonthlyPrices(monthi) = M_Avg(1);
    monthi = monthi + 1;

  end
  
  PRICES.DailyAvg(indbegin:indend,1) = DailyAvg;
  PRICES.MonthlyAvg(indbegin:indend,1) = MonthlyAvg;

  
  indbegin = indend + 1;

end

PRICES.POWER.EEX = PowerPrices;


%% Read Hourly Heat Demand
Inputfile = [INIT.InputfolderName, INIT.slash, 'HeatDemand.xls'];
xls_check_if_open(Inputfile,'close');
[DataN, DataT] = xlsread(Inputfile);

Years = DataN(1,2:end);
StartDate = datenum(Years(1),1,1);
EndDate = datenum(Years(1,end),12,31);
NrDays = (EndDate - StartDate + 1);
NrHours = (EndDate - StartDate + 1) * 24;
NrYears = Years(end) - Years(1) + 1;

d = (StartDate:EndDate);
Hour2day = zeros(NrHours,1);
d24 = repmat(d,24,1);
Hour2day = d24(:);

Hour = zeros(24,1);
for i=1:24
  Hour(i) = (i-1)/24;
end
HoursArray = repmat(Hour,NrDays,1);

Date = Hour2day;
Hour = HoursArray;
DateAndHour = Date + Hour;

PRICES.HEAT.Date = Date;
PRICES.HEAT.Hour = Hour;
PRICES.HEAT.DateAndHour = DateAndHour;

PRICES.HEAT.Demand = zeros(length(PRICES.HEAT.Date),1);

indend = 0;
indbegin = 1;

for i = 1:NrYears
    
  ind = ~isnan(DataN(2:end,1+i));
  ind2 = find(ind == 0,1,'first');
  if isempty(ind2)
    ind2 = 8785;
  end
  demand = DataN(2:ind2,1+i);

  indend = indend + ind2 - 1;
  HeatDemand(indbegin:indend,1) = demand;
  indbegin = indend + 1;

end

PRICES.HEAT.Demand = HeatDemand;

%% Read Daily Gas Prices

PRICES.GAS.Date = PRICES.POWER.Date;
PRICES.GAS.Hour = PRICES.POWER.Hour;
PRICES.GAS.DateAndHour = PRICES.POWER.DateAndHour;
PRICES.GAS.Price = zeros(length(PRICES.GAS.Date),1);
PRICES.GAS.Price(:,1) = 15;


%% Read Hourly Heat Demand
Inputfile = [INIT.InputfolderName, INIT.slash, 'MinProduction.xls'];
xls_check_if_open(Inputfile,'close');
[DataN, DataT] = xlsread(Inputfile);

Years = DataN(1,2:end);
StartDate = datenum(Years(1),1,1);
EndDate = datenum(Years(1,end),12,31);
NrDays = (EndDate - StartDate + 1);
NrHours = (EndDate - StartDate + 1) * 24;
NrYears = Years(end) - Years(1) + 1;

d = (StartDate:EndDate);
Hour2day = zeros(NrHours,1);
d24 = repmat(d,24,1);
Hour2day = d24(:);

Hour = zeros(24,1);
for i=1:24
  Hour(i) = (i-1)/24;
end
HoursArray = repmat(Hour,NrDays,1);

Date = Hour2day;
Hour = HoursArray;
DateAndHour = Date + Hour;

PRICES.COMMITTEDLOAD.Date = Date;
PRICES.COMMITTEDLOAD.Hour = Hour;
PRICES.COMMITTEDLOAD.DateAndHour = DateAndHour;

PRICES.COMMITTEDLOAD.MinProduction = zeros(length(PRICES.COMMITTEDLOAD.Date),1);

indend = 0;
indbegin = 1;

for i = 1:NrYears
    
  ind = ~isnan(DataN(2:end,1+i));
  ind2 = find(ind == 0,1,'first');
  if isempty(ind2)
    ind2 = 8785;
  end
  demand = DataN(2:ind2,1+i);

  indend = indend + ind2 - 1;
  MinProduction(indbegin:indend,1) = demand;
  indbegin = indend + 1;

end

PRICES.COMMITTEDLOAD.MinProduction = MinProduction;
