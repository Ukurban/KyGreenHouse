function Read_NamesAndFolders
global INIT
%%  ***********************************************************************
%%      function [INIT] = Read_NamesAndFolders(INIT)
% % 
% %     Purpose: This function generates (part of the) the struct INIT,
% %              containing paths to various input/ouput folders.
% % 
% %     Input:
% % 
% %         INIT
% %         INIT.Version: model version
% %         INIT.slash: slash-sign for either windows or unix [either \ or /]
% %         INIT.LibraryFolder: path to function library folder
% % 
% %     Output:
% % 
% %         INIT
% %         INIT.FullDashboardName: path to input file
% %         INIT.InputfolderName: path to input folder
% %         INIT.OutputfolderName: path to output folder
% % 
% %     Modifications:
% %
% %       15-07-2013: Created
% % 
%%  ***********************************************************************
%%

if ~isdeployed
    FolderPath = [ cd, INIT.slash, 'Matlab', INIT.slash, 'Datenbank', INIT.slash, 'GUISettings.txt'];
else
    FolderPath = ['GUISettings.txt'];
end

fid = fopen(FolderPath,'r');

% Read the data from txt-file
fieldNames = '%s ';
for i = 1:2
  fieldNames = [fieldNames, '%s '];
end
    
data = textscan(fid, fieldNames, 'Delimiter', '\t');

INIT.FullDashboardName = char(data{1,1}(1)); 
INIT.OutputfolderName = char(data{1,1}(2)); 
INIT.InputfolderName = char(data{1,1}(3)); 

if strncmp(char(data{1,1}(1)),'"', 1) == 1
  FolderNames = textread(FolderPath,'%q');
  INIT.FullDashboardName= char(FolderNames(1));
  INIT.OutputfolderName = char(FolderNames(2));
  INIT.InputfolderName = char(FolderNames(3));
end

ind1 = find(INIT.FullDashboardName==INIT.slash,1,'last')+1;
ind2 = length(INIT.FullDashboardName);
INIT.FileName = INIT.FullDashboardName(ind1:ind2);
INIT.x2m = 693960;    % Conversion from Matlab date to Excel date: mdate = xdate + x2m

end % function