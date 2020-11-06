function CreateModel

% Create Variables
VarInjectGasStorage;
VarWithdrawGasStorage;

VarInjectHeatBuffer;
VarWithdrawHeatBuffer;

VarGasStorageLevel;
VarHeatBufferLevel;

VarMinLoad;

VarRunCHP;

VarStartUp;

% Create Constraints
ConStartUp;
ConMaxStarts;
ConMinLoad;
ConGasStorage;
ConHeatBuffer;
ConHeatDemand;
ConCHP;

% Objective function
Objective;
