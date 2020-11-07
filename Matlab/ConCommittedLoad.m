function ConCommittedLoad
global MODEL INPUTS PRICES


for h = 1:INPUTS.NrHoursLoop
   id = MODEL.NrCons + 1;
   MODEL.CON.ID.CommittedLoad(h) = id;
   cons = zeros(MODEL.NrVars,1);
   
   for c = 1:INPUTS.NrCHP
      cons(MODEL.VAR.ID.RunCHP(h,c)) = 1;
   end

   rhs = PRICES.COMMITTEDLOAD.MinProduction(h);
   
   mxlpsolve('add_constraint', MODEL.LP, cons, 2, rhs); % 1=le, 2=ge, 3=eq
   MODEL.NrCons = id;
end
