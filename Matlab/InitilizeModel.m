function InitilizeModel
global MODEL
MODEL.NrVars = 0;
MODEL.NrCons = 0;
MODEL.LP = mxlpsolve('make_lp', MODEL.NrVars, MODEL.NrCons); % lp handle (initialized as an empty model)
mxlpsolve('set_scaling',MODEL.LP, 196); 
mxlpsolve('set_verbose', MODEL.LP, 1); % 1 = Only critical messages, 3=important messages only 
% time out 
mxlpsolve('set_timeout', MODEL.LP, 600); % 100 sec