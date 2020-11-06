function MapDates
global INPUTS PRICES

Startdate = INPUTS.Startdate + (INPUTS.Loop - 1) * INPUTS.DaysPerLoop/2;
Enddate = Startdate + INPUTS.DaysPerLoop - 1;

NrDays = Enddate - Startdate + 1;
NrHours = NrDays * 24 ;

INPUTS.StartdateLoop = Startdate;
INPUTS.EnddateLoop = Enddate;
INPUTS.NrHoursLoop = NrHours;
INPUTS.NrDaysLoop = NrDays;

INPUTS.Ind1 = find(PRICES.POWER.Date == Startdate,1,'first');
INPUTS.Ind2 = min(length(PRICES.POWER.Date), ...
    find(PRICES.POWER.Date == Enddate,1,'last') );

d = (Startdate:Enddate);
INPUTS.Hour2day = zeros(NrHours,1);
d24 = repmat(d-Startdate+1,24,1);
INPUTS.Hour2day = d24(:);

% Map days to hours
INPUTS.Day2hour = zeros(NrDays,24);  
for dbar = 1:NrDays
  I = find(INPUTS.Hour2day == dbar);  
  INPUTS.Day2hour(dbar,:) = I;  
end

% Map days to months
[yy,mm,dd] = datevec(d); 
dd(1) = 1;
newM = find(dd==1);
INPUTS.NrMonths = length(newM);
INPUTS.Day2month = zeros(length(d),1); 
for m = 1:INPUTS.NrMonths-1
  INPUTS.Day2month(newM(m):newM(m+1)-1) = m;  
end
if INPUTS.NrMonths > 1
  INPUTS.Day2month(newM(m+1):end) = INPUTS.NrMonths;
else
  INPUTS.Day2month(:) = 1;  
end

% Map months to years
INPUTS.Month2year = INPUTS.NrMonths;
for m = 1:INPUTS.NrMonths
  INPUTS.Month2year(m) = yy(newM(m)) - yy(1) + 1;  
end

