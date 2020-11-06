function ConMaxStarts
global MODEL INPUTS
% Max startups per day
for d = 1:INPUTS.NrDaysLoop
  for c = 1:INPUTS.NrCHP
    if INPUTS.BHKW.MaxStartsPerDay(c) < 24 
      id = MODEL.NrCons + 1;
      MODEL.CON.ID.ConMaxStartsDay(d,c) = id;
      cons = zeros(MODEL.NrVars,1); 
      cons(MODEL.VAR.ID.StartUp(INPUTS.Day2hour(d,:),c)) = 1;
      rhs = INPUTS.BHKW.MaxStartsPerDay(c);
      mxlpsolve('add_constraint', MODEL.LP, cons, 1, rhs); % 1=le, 2=ge, 3=eq
    MODEL.NrCons = id;
    end
  end
end