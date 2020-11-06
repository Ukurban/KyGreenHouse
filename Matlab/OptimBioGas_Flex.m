function OptimBioGas_Flex
global MODEL INIT INPUTS PRICES

% initilize model
InitilizeModel;

% create model
MODEL.Epsilon = 1E-6;

Msg = ['Optimization for loop ', num2str(INPUTS.Loop), ' of ', num2str(INPUTS.NrOfLoops)];
disp(Msg);
%disp('Perform optimization: define variables and constraints');
CreateModel;

% solve the LP problem
%disp('Perform optimization: solve the LP problem');
res = mxlpsolve('solve', MODEL.LP);
%0 = optimal, 1 = suboptimal, 2 = infeasible, 7 = timeout

if res ~= 0
  Msg = ['No solution found in loop ', num2str(INPUTS.Loop)];
  msgbox(Msg);
end
MODEL.TimeElapsed = mxlpsolve('time_elapsed', MODEL.LP);

% get results
%disp('Perform optimization: get results from the LP problem');
GetSolution;

mxlpsolve('delete_lp', MODEL.LP);