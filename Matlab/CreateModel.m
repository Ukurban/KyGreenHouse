function CreateModel

global INPUTS


%%  Create Variables
disp('Creating model variables...')

% gas storage related variables
if INPUTS.isGasStorage
   VarInjectGasStorage;
   VarWithdrawGasStorage;
   VarGasStorageLevel;
end

% heat bufer related variables
VarInjectHeatBuffer;
VarWithdrawHeatBuffer;
VarHeatBufferLevel;

VarMinLoad;
VarRunCHP;
VarStartUp;

% Create Constraints
disp('Creating model constraints...')
ConStartUp;
ConMaxStarts;
ConMinLoad;

if INPUTS.isGasStorage
   ConGasStorage;
end
ConHeatBuffer;
ConHeatDemand;
ConCHP;

% Objective function
disp('Creating objective function...')
Objective;
