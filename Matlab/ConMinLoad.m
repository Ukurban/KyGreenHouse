function ConMinLoad
global MODEL INPUTS
for h = 1:INPUTS.NrHoursLoop
  for c = 1:INPUTS.NrCHP
    % prod > Minload * prodON  
    id = MODEL.NrCons + 1;
    MODEL.CON.ID.ConMinLoad1(h,c) = id;
    cons = zeros(MODEL.NrVars,1);   
    cons(MODEL.VAR.ID.MinLoad(h,c)) = INPUTS.BHKW.MinLoad(c);
    cons(MODEL.VAR.ID.RunCHP(h,c)) = -1;
    rhs = 0;
    mxlpsolve('add_constraint', MODEL.LP, cons, 1, rhs); % 1=le, 2=ge, 3=eq
    MODEL.NrCons = id;
    
    % prod < MaxLoad * prodON
    id = MODEL.NrCons + 1;
    MODEL.CON.ID.ConMinLoad2(h,c) = id;
    cons = zeros(MODEL.NrVars,1);   
    cons(MODEL.VAR.ID.MinLoad(h,c)) = INPUTS.BHKW.MaxLoad(c);
    cons(MODEL.VAR.ID.RunCHP(h,c)) = -1;
    rhs = 0;
    mxlpsolve('add_constraint', MODEL.LP, cons, 2, rhs); % 1=le, 2=ge, 3=eq
    MODEL.NrCons = id;
  end
end