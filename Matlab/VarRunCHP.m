function VarRunCHP
global MODEL INPUTS
for c = 1:INPUTS.NrCHP
  for h = 1:INPUTS.NrHoursLoop
    id = MODEL.NrVars + 1;
    MODEL.VAR.ID.RunCHP(h,c) = id;
    mxlpsolve('add_column', MODEL.LP, id);
    mxlpsolve('set_lowbo', MODEL.LP, id, 0);
    mxlpsolve('set_upbo', MODEL.LP, id, INPUTS.BHKW.MaxLoad(c));  

    mxlpsolve('set_int', MODEL.LP, id, 0); % 0=real, 1=integer
    MODEL.NrVars = id;    
  end
end
  