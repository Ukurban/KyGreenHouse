function OptimBioGas_Flex
global MODEL INPUTS

% initilize model
InitilizeModel;

% create model
MODEL.Epsilon = 1E-6;

Msg = ['Optimization for loop ', num2str(INPUTS.Loop), ' of ', num2str(INPUTS.NrOfLoops)];
disp(Msg);

% disp('Perform optimization: define variables and constraints');
CreateModel;

% solve the LP problem
disp('Optimization performing...');

res = mxlpsolve('solve', MODEL.LP);

if (INPUTS.Loop) == 1
   % Save the LP Model as LP file
   flag = mxlpsolve('write_lp', MODEL.LP, 'LPModel.lp');
   
   % Save the LP Model as MPS file
   flag = mxlpsolve('write_mps', MODEL.LP, 'LPModel.mps');
end

%0 = optimal, 1 = suboptimal, 2 = infeasible, 7 = timeout

if res ~= 0
   Msg = ['No solution found in loop ', num2str(INPUTS.Loop)];
   msgbox(Msg);
elseif res == 0
   disp(['Optimal solution found in loop', num2str(INPUTS.Loop)])
end
MODEL.TimeElapsed = mxlpsolve('time_elapsed', MODEL.LP);

% get results
%disp('Perform optimization: get results from the LP problem');
GetSolution;

mxlpsolve('delete_lp', MODEL.LP);