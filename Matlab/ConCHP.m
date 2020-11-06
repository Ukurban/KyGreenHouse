function ConCHP
global MODEL INPUTS

% max full load per year
for c = 1:INPUTS.NrCHP
  id = MODEL.NrCons + 1;
  MODEL.CON.ID.MaxFullLoad(c) = id;
  cons = zeros(MODEL.NrVars,1);   
  cons(MODEL.VAR.ID.RunCHP(:,c)) = 1;
  rhs = INPUTS.BHKW.MaxFullLoadHoursPerYear(c) * INPUTS.BHKW.MaxLoad(c) / 365 * INPUTS.DaysPerLoop;
  mxlpsolve('add_constraint', MODEL.LP, cons, 1, rhs); % 1=le, 2=ge, 3=eq
  MODEL.NrCons = id;
end

% SRL up
if INPUTS.ImbalanceLoopNr == 2;
    
  if INPUTS.IMBALANCE.Long > 0 
    for h = 1:INPUTS.NrHoursLoop    
      id = MODEL.NrCons + 1;
      MODEL.CON.ID.MaxPowerProd(h) = id;
      cons = zeros(MODEL.NrVars,1);   
      cons(MODEL.VAR.ID.RunCHP(h,:)) = 1;
  
      rhs = INPUTS.MaxProd;
  
      mxlpsolve('add_constraint', MODEL.LP, cons, 1, rhs); % 1=le, 2=ge, 3=eq
      MODEL.NrCons = id;
    end
    
    % SRL down
    for h = 1:INPUTS.NrHoursLoop
      id = MODEL.NrCons + 1;
      MODEL.CON.ID.MinPowerProd(h) = id;
      cons = zeros(MODEL.NrVars,1);   
      cons(MODEL.VAR.ID.RunCHP(h,:)) = 1;
  
      rhs = INPUTS.IMBALANCE.Short;
  
      mxlpsolve('add_constraint', MODEL.LP, cons, 2, rhs); % 1=le, 2=ge, 3=eq
      MODEL.NrCons = id;
    end
    
  end
  
  if INPUTS.IMBALANCE.Short > 0 && INPUTS.IMBALANCE.Long == 0
    % SRL down
    for h = 1:INPUTS.NrHoursLoop
      id = MODEL.NrCons + 1;
      MODEL.CON.ID.MinPowerProd(h) = id;
      cons = zeros(MODEL.NrVars,1);   
      cons(MODEL.VAR.ID.RunCHP(h,:)) = 1;
  
      rhs = INPUTS.IMBALANCE.Short;
  
      mxlpsolve('add_constraint', MODEL.LP, cons, 2, rhs); % 1=le, 2=ge, 3=eq
      MODEL.NrCons = id;
    end
  end
  
end