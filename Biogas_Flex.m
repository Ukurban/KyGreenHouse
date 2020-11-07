% Main function to calculate the value for Biogas Flex

function Biogas_Flex

% Clear memory
clc       
clear all 

% Timer
tic;
global INIT INPUTS PRICES MODEL OUTPUTS

%% Define path and filename
if ispc
  INIT.slash = '\';
else
  INIT.slash = '/';
end
    
LibraryFolder = ['Matlab', INIT.slash]; 
INIT.Version = 'Biogas Flex 1.0';
INIT.LibraryFolder = [cd, INIT.slash, LibraryFolder];

if ~isdeployed
  path(INIT.LibraryFolder, path);
end

% Initiate Settings with user selected input files
Read_NamesAndFolders;

%% Read inputs from Excel input files
disp('Read inputs from the Excel input file');
Read_InputsFromExcel;

disp('Read price data and heat profile');
Read_PriceData_HeatDemand;


%% Configuration for EPEX Module
INPUTS.isFullLoadHours = false;
INPUTS.isGasStorage = false;

INPUTS.isBoiler = true;
INPUTS.isGasPrice = true;
INPUTS.isPowerDemand = true;
INPUTS.isCarbonDemand = true;



%% Create loops 
for j = 1:INPUTS.ImbalanceLoop
  INPUTS.ImbalanceLoopNr = j;
  
  if j == 1
    disp('Calculation started for optimization excluding imbalance markets');
  elseif j == 2
    disp('Calculation started for optimization including imbalance markets');
  end
  
  for i = 1:INPUTS.NrOfLoops
    
     if i == 1
        if INPUTS.isGasStorage
           INPUTS.STORAGE.Volume = INPUTS.GASSTORAGE.StartVolume;
        end
        INPUTS.HEATBUFFER.Volume = INPUTS.HEATBUFFER.StartVolume;
     else
        if INPUTS.isGasStorage
           INPUTS.STORAGE.Volume = MODEL.VAR.VAL.GasStorageLevel(24);
        end
        INPUTS.HEATBUFFER.Volume = MODEL.VAR.VAL.HeatBufferLevel(24) ;
     end

    % Process data
    INPUTS.Loop = i;
    MapDates

    % Optimization - LP
    OptimBioGas_Flex

    % Write Outputs to Excel
    OutputPerLoop
    if i == INPUTS.NrOfLoops
      disp('Write outputs to Excel');
      WriteOutputs(j);
    end
  end
end

toc;