function ConGasStorage
global MODEL INPUTS

% gas consumption
for h = 1:INPUTS.NrHoursLoop
  id = MODEL.NrCons + 1;
  MODEL.CON.ID.InjectGas(h) = id;
  cons = zeros(MODEL.NrVars,1);
  for c = 1:INPUTS.NrCHP
    cons(MODEL.VAR.ID.RunCHP(h,c)) = 1/INPUTS.BHKW.MaxEff(c);
  end
  cons(MODEL.VAR.ID.InjectGas(h)) = 1;
  cons(MODEL.VAR.ID.WithdrawGas(h)) = -1;
  rhs = INPUTS.Biogas;
  mxlpsolve('add_constraint', MODEL.LP, cons, 3, rhs); % 1=le, 2=ge, 3=eq
  MODEL.NrCons = id;
end

% Level
for h = 1:INPUTS.NrHoursLoop
 id = MODEL.NrCons + 1;
 MODEL.CON.ID.GasStorage(h) = id;
 cons = zeros(MODEL.NrVars,1);
 
 if h > 1
   cons(MODEL.VAR.ID.GasStorageLevel(h-1)) = -1;
 end
 if h < INPUTS.NrHoursLoop
   cons(MODEL.VAR.ID.GasStorageLevel(h)) = 1;
 end
 
 cons(MODEL.VAR.ID.InjectGas(h)) = -1;
 cons(MODEL.VAR.ID.WithdrawGas(h)) = 1;
 
 rhs = 0;
 if h == 1
   rhs = INPUTS.STORAGE.Volume;
 end
 
 mxlpsolve('add_constraint', MODEL.LP, cons, 3, rhs); % 1=le, 2=ge, 3=eq
 MODEL.NrCons = id;
end
 