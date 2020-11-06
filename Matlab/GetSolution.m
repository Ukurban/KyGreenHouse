function GetSolution
global MODEL INPUTS

obj = mxlpsolve('get_objective', MODEL.LP);
MODEL.OBJ.Value = obj;
  
x = mxlpsolve('get_variables', MODEL.LP);

if INPUTS.isGasStorage
   MODEL.VAR.VAL.InjectGas =  x(MODEL.VAR.ID.InjectGas)';
   MODEL.VAR.VAL.WithdrawGas = x(MODEL.VAR.ID.WithdrawGas)';
   MODEL.VAR.VAL.GasStorageLevel = x(MODEL.VAR.ID.GasStorageLevel)';
end

MODEL.VAR.VAL.InjectHeat = x(MODEL.VAR.ID.InjectHeat)';
MODEL.VAR.VAL.WithdrawHeat = x(MODEL.VAR.ID.WithdrawHeat)';

MODEL.VAR.VAL.HeatBufferLevel = x(MODEL.VAR.ID.HeatBufferLevel)';

MODEL.VAR.VAL.RunCHP = [];
for c = 1:INPUTS.NrCHP
  MODEL.VAR.VAL.RunCHP(:,c) = x(MODEL.VAR.ID.RunCHP(:,c))';
end

MODEL.VAR.VAL.StartUp = [];
for c = 1:INPUTS.NrCHP
  if INPUTS.BHKW.MaxStartsPerDay(c) < 24
     MODEL.VAR.VAL.StartUp(:,c) = x(MODEL.VAR.ID.StartUp(:,c))'; 
  end
end

MODEL.VAR.VAL.MinLoad = [];
for c = 1:INPUTS.NrCHP
  MODEL.VAR.VAL.MinLoad(:,c) = x(MODEL.VAR.ID.MinLoad(:,c))';  
end