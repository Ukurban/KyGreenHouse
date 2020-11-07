function VarBoiler
global MODEL INPUTS
for b = 1:INPUTS.NrBoilers
  for h = 1:INPUTS.NrHoursLoop
    id = MODEL.NrVars + 1;
    MODEL.VAR.ID.RunBoiler(h,b) = id;
    mxlpsolve('add_column', MODEL.LP, id);
    mxlpsolve('set_lowbo', MODEL.LP, id, 0);
    mxlpsolve('set_upbo', MODEL.LP, id, INPUTS.BOILERS.MaxHeatCapacity(b));  

    mxlpsolve('set_int', MODEL.LP, id, 0); % 0=real, 1=integer
    MODEL.NrVars = id;    
  end
end