function varargout = BiogasFlex_GUI(varargin)
% BIOGASFLEX_GUI MATLAB code for BiogasFlex_GUI.fig
%      BIOGASFLEX_GUI, by itself, creates a new BIOGASFLEX_GUI or raises the existing
%      singleton*.
%
%      H = BIOGASFLEX_GUI returns the handle to a new BIOGASFLEX_GUI or the handle to
%      the existing singleton*.
%
%      BIOGASFLEX_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIOGASFLEX_GUI.M with the given input arguments.
%
%      BIOGASFLEX_GUI('Property','Value',...) creates a new BIOGASFLEX_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BiogasFlex_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BiogasFlex_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BiogasFlex_GUI

% Last Modified by GUIDE v2.5 26-Oct-2013 19:54:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BiogasFlex_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BiogasFlex_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT


% --- Executes just before BiogasFlex_GUI is made visible.
function BiogasFlex_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BiogasFlex_GUI (see VARARGIN)

% Choose default command line output for BiogasFlex_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BiogasFlex_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% LOAD PREVIOUS USED NAMES  
if ~isdeployed
    FolderPath = [ cd, '\', 'Matlab\Datenbank\GUISettings.txt'];
else
    FolderPath = ['GUISettings.txt'];
end

if exist(FolderPath) == 2
  FolderNames = textread(FolderPath,'%q');
  FileName = char(FolderNames(1));
  OutputfolderName = char(FolderNames(2));
  InputFolder = char(FolderNames(3));
  set(handles.edit1, 'String', FileName)
  set(handles.edit2, 'String', OutputfolderName)
  set(handles.edit3, 'String', InputFolder)
end 

% --- Outputs from this function are returned to the command line.
function varargout = BiogasFlex_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.pushbutton1,'Value') == 1;
  [filename, pathname] = uigetfile({'*.xls'},'Pick a file', cd);
  InputFile = [pathname, filename] ;
  set(handles.edit1, 'String', InputFile);
else
  set(handles.edit1, 'String', '');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.pushbutton2,'Value') == 1;
  [pathname] = uigetdir(cd,'Select a folder');
  OutputFolderFile = [pathname] ;
  set(handles.edit2, 'String', OutputFolderFile);
else
  set(handles.edit2, 'String', '');
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.pushbutton5,'Value') == 1;
  [pathname] = uigetdir(cd,'Select a folder');
  InputFolder = [pathname] ;
  set(handles.edit3, 'String', InputFolder);
else
  set(handles.edit3, 'String', '');
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Store selected input/output folders
InputFile = get(handles.edit1, 'String');
OutputFolderFile = get(handles.edit2, 'String');
InputFolder = get(handles.edit3, 'String');

if ~isdeployed
  OutputPath = [cd,'\Matlab\Datenbank\','GUISettings.txt'];
else
  OutputPath = 'GUISettings.txt';
end
fid = fopen(OutputPath, 'wt');

InputFile = ['"',InputFile,'"']
OutputFolderFile = ['"',OutputFolderFile,'"']
InputFolder = ['"',InputFolder,'"']
fprintf(fid,'%s\n',InputFile);
fprintf(fid,'%s\n',OutputFolderFile);
fprintf(fid,'%s\n',InputFolder);
fclose(fid);

Biogas_Flex


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
