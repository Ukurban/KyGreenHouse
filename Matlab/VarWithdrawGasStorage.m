function VarWithdrawGasStorage
global MODEL INPUTS
  for h = 1:INPUTS.NrHoursLoop
    id = MODEL.NrVars + 1;
    MODEL.VAR.ID.WithdrawGas(h) = id;
    mxlpsolve('add_column', MODEL.LP, id);
    mxlpsolve('set_lowbo', MODEL.LP, id, 0);
    mxlpsolve('set_upbo', MODEL.LP, id, INPUTS.GASSTORAGE.Withdraw(h));  

    mxlpsolve('set_int', MODEL.LP, id, 0); % 0=real, 1=integer
    MODEL.NrVars = id;    
  end
  