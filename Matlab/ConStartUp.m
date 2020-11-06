function ConStartUp

global MODEL INPUTS

for h = 1:INPUTS.NrHoursLoop
  for c = 1:INPUTS.NrCHP
    if INPUTS.BHKW.MaxStartsPerDay(c) < 24  
      id = MODEL.NrCons + 1;
      MODEL.CON.ID.ConStartUp(h,c) = id;
      cons = zeros(MODEL.NrVars,1);
      % constraints Run(h)-Run(h-1) < StartUp(h) 
      if h == 1
        cons(MODEL.VAR.ID.MinLoad(h,c)) = 1;  
      else
        cons(MODEL.VAR.ID.MinLoad(h-1,c)) = -1;
        cons(MODEL.VAR.ID.MinLoad(h,c)) = 1;
      end
      cons(MODEL.VAR.ID.StartUp(h,c)) = -1;
      rhs = 0;
      mxlpsolve('add_constraint', MODEL.LP, cons, 1, rhs); % 1=le, 2=ge, 3=eq
      MODEL.NrCons = id;
    end
  end
end
