function VarStartUp
global MODEL INPUTS
for c = 1:INPUTS.NrCHP
  if INPUTS.BHKW.MaxStartsPerDay(c) < 24  
    for h = 1:INPUTS.NrHoursLoop
      id = MODEL.NrVars + 1;
      MODEL.VAR.ID.StartUp(h,c) = id;
      mxlpsolve('add_column', MODEL.LP, id);
      mxlpsolve('set_upbo', MODEL.LP, id, 1);  
      mxlpsolve('set_int', MODEL.LP, id, 1); % 0=real, 1=integer
      MODEL.NrVars = id;    
    end
  end
end
  