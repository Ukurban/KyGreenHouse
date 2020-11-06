function ConHeatBuffer
global MODEL INPUTS

% Level 
for h = 1:INPUTS.NrHoursLoop
 id = MODEL.NrCons + 1;
 MODEL.CON.ID.HeatBufferLevel(h) = id;
 cons = zeros(MODEL.NrVars,1);
 
 if h > 1
   cons(MODEL.VAR.ID.HeatBufferLevel(h-1)) = -(1-INPUTS.HEATBUFFER.HeatLoss);
 end
 if h < INPUTS.NrHours
   cons(MODEL.VAR.ID.HeatBufferLevel(h)) = 1;
 end
 
 cons(MODEL.VAR.ID.InjectHeat(h)) = -1;
 cons(MODEL.VAR.ID.WithdrawHeat(h)) = 1;
 
 rhs = 0;
 if h == 1
   rhs = INPUTS.HEATBUFFER.Volume;  
 end
 
 mxlpsolve('add_constraint', MODEL.LP, cons, 3, rhs); % 1=le, 2=ge, 3=eq
 MODEL.NrCons = id;
end
 