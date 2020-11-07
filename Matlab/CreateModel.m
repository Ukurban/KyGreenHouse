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
if INPUTS.isBoiler
   VarBoiler;
end
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
ConCommittedLoad

% Objective function
disp('Creating objective function...')
Objective;
