function Objective
global MODEL INPUTS PRICES

obj = zeros(MODEL.NrVars, 1);

if strcmp(INPUTS.OptimizationMethod,'Monthly Average')
   
   for c = 1:INPUTS.NrCHP
      obj(MODEL.VAR.ID.RunCHP(:,c)) = -(PRICES.MonthlyAvg(INPUTS.Ind1:INPUTS.Ind2));
   end
   if INPUTS.isGasStorage
      obj(MODEL.VAR.ID.InjectGas) = INPUTS.GASSTORAGE.InjCosts;
   end
elseif strcmp(INPUTS.OptimizationMethod,'Daily Average')
   
   for c = 1:INPUTS.NrCHP
      obj(MODEL.VAR.ID.RunCHP(:,c)) = -(PRICES.DailyAvg(INPUTS.Ind1:INPUTS.Ind2));
   end
   if INPUTS.isGasStorage
      obj(MODEL.VAR.ID.InjectGas) = INPUTS.GASSTORAGE.InjCosts;
   end
elseif strcmp(INPUTS.OptimizationMethod,'Market')
   
   for c = 1:INPUTS.NrCHP
      obj(MODEL.VAR.ID.RunCHP(:,c)) = -(PRICES.POWER.EEX(INPUTS.Ind1:INPUTS.Ind2) - INPUTS.BHKW.VOM(c) - ...
         1/INPUTS.BHKW.MaxEff(c) * PRICES.GAS.Price(INPUTS.Ind1:INPUTS.Ind2));
   end
   if INPUTS.isGasStorage
      obj(MODEL.VAR.ID.InjectGas) = INPUTS.GASSTORAGE.InjCosts;
   end
   
   if INPUTS.isBoiler
      for b = 1:INPUTS.NrBoilers
         obj(MODEL.VAR.ID.RunBoiler(:,b)) = 1/INPUTS.BOILERS.MaxEff(b) * ...
            PRICES.GAS.Price(INPUTS.Ind1:INPUTS.Ind2);
      end
   end
end
 
 mxlpsolve('set_obj_fn', MODEL.LP, obj);
 MODEL.OBJ.Set = obj;