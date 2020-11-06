function VarMinLoad
global MODEL INPUTS
  for h = 1:INPUTS.NrHoursLoop
    for c = 1:INPUTS.NrCHP  
      id = MODEL.NrVars + 1;
      MODEL.VAR.ID.MinLoad(h,c) = id;
      mxlpsolve('add_column', MODEL.LP, id);
      mxlpsolve('set_upbo', MODEL.LP, id, 1);  

      mxlpsolve('set_int', MODEL.LP, id, 1); % 0=real, 1=integer
      MODEL.NrVars = id;    
    end
  end