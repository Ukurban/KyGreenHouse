function ConHeatDemand
global MODEL INPUTS PRICES

 
for h = 1:INPUTS.NrHoursLoop
 id = MODEL.NrCons + 1;
 MODEL.CON.ID.HeatDemand(h) = id;
 cons = zeros(MODEL.NrVars,1);
 
 if strcmpi(INPUTS.HeatProduction,'All')
   for c = 1:INPUTS.NrCHP
     cons(MODEL.VAR.ID.RunCHP(h,c)) = INPUTS.BHKW.MaxHeat(c)/INPUTS.BHKW.MaxLoad(c);
   end
 else
   cons(MODEL.VAR.ID.RunCHP(h,1)) = INPUTS.BHKW.MaxHeat(1)/INPUTS.BHKW.MaxLoad(1);  
 end
   
 cons(MODEL.VAR.ID.InjectHeat(h)) = -1;
 cons(MODEL.VAR.ID.WithdrawHeat(h)) = 1;

 rhs = PRICES.HEAT.Demand(h); 
 
 mxlpsolve('add_constraint', MODEL.LP, cons, 2, rhs); % 1=le, 2=ge, 3=eq
 MODEL.NrCons = id;
end
 