function varargout = ModifySpike_v1(varargin)
% MODIFYSPIKE_V1 MATLAB code for ModifySpike_v1.fig
%      MODIFYSPIKE_V1, by itself, creates a new MODIFYSPIKE_V1 or raises the existing
%      singleton*.
%
%      H = MODIFYSPIKE_V1 returns the handle to a new MODIFYSPIKE_V1 or the handle to
%      the existing singleton*.
%
%      MODIFYSPIKE_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODIFYSPIKE_V1.M with the given input arguments.
%
%      MODIFYSPIKE_V1('Property','Value',...) creates a new MODIFYSPIKE_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ModifySpike_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ModifySpike_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ModifySpike_v1

% Last Modified by GUIDE v2.5 17-Jan-2018 10:58:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ModifySpike_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @ModifySpike_v1_OutputFcn, ...
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


% --- Executes just before ModifySpike_v1 is made visible.
function ModifySpike_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ModifySpike_v1 (see VARARGIN)

% Choose default command line output for ModifySpike_v1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ModifySpike_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ModifySpike_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rawDataLoc = uigetdir('','LOAD MAIN DIRECTORY');

% Load location with Spike Files to Cluster - RAW_Ephys_Files
cd(rawDataLoc)
checkFdir = 1;
mrdir = dir;
mrDirFolds1 = {mrdir.name};
mrDirFoldsC = mrDirFolds1(~ismember(mrDirFolds1,{'.','..'}));

while checkFdir
    if sum(contains({'ClusteredSpikeTimes',...
            'RAW_Ephys_Files',...
            'SpikeDates2Cluster'},mrDirFoldsC)) == 3
        checkFdir = 0;
    else
        rawDataLoc = uigetdir('','LOAD MAIN DIRECTORY');
        cd(rawDataLoc)
        checkFdir = 1;
        mrdir = dir;
        mrDirFolds1 = {mrdir.name};
        mrDirFoldsC = mrDirFolds1(~ismember(mrDirFolds1,{'.','..'}));
    end
end

handles.FolderMain = rawDataLoc;
handles.LoadLoc = [rawDataLoc , '\SpikeDates2Cluster\'];

cd(handles.LoadLoc)

fdir = dir('*.mat');
fnameopts = {fdir.name};

question2 = 'Select File to analyze';
titlFig2 = 'File ID';
selections2 = fnameopts;
selectStr2 = 'Select File';
listSize2 = [300 300];

[fchoice,~] = listdlg('PromptString',question2,...
    'Name',titlFig2,...
    'SelectionMode','single',...
    'ListSize',listSize2,...
    'OKString',selectStr2,...
    'fus',15,...
    'ListString',selections2);

handles.file2load = fnameopts{fchoice};

load(handles.file2load , 'CaseNum', 'DepthID', 'DepthIND','fedTable');

handles.tfedTable = table2cell(fedTable);
handles.CN = CaseNum;
handles.DID = DepthID;
handles.DIND = DepthIND;
deleteTab = num2cell(false(height(fedTable),1));

handles.tfedTable = [handles.tfedTable , deleteTab];
set(handles.dataTable,'Data',handles.tfedTable);
set(handles.dataTable,'ColumnName',{'Depth','Elec','Assess','Delete'});

guidata(hObject, handles);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd(handles.LoadLoc)

newFedtableCA = get(handles.dataTable,'Data');
FedtableCA = newFedtableCA(:,1:3);

% Rederive Table
nfedTable = cell2table(FedtableCA,'VariableNames',{'Depth','ElNum','Analyzed'});
fedTable = nfedTable; %#ok<NASGU>
% CaseNum = handles.CN;
% DepthID = handles.DID;
% DepthIND = handles.DIND;

% Save new file
save(handles.file2load,'fedTable','-append')

OrigDlgH = ancestor(hObject, 'figure');
delete(OrigDlgH);
ModifySpike_v1;


% --- Executes on button press in deleteD.
function deleteD_Callback(hObject, eventdata, handles)
% hObject    handle to deleteD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd(handles.LoadLoc)

newFedtableCA = get(handles.dataTable,'Data');
FedtableCA = newFedtableCA(:,1:3);

% Fix fedtable with deleted rows
delInds = cell2mat(newFedtableCA(:,4));
noDelTab = FedtableCA(~delInds,:);

% Get depths to find
del2Search = FedtableCA(delInds,:);

% Fix DepthID and DepthIND
nDepthIND = handles.DIND;
for di = 1:size(del2Search,1)
   
    td_dep = del2Search{di,1};
    td_ele = del2Search{di,2};
    
    dIDind = find(ismember(handles.DID(:,1),td_dep));
    elIND = find(ismember(1:3,str2double(td_ele(end))));
    
    nDepthIND{dIDind,1}(elIND,1) = 0; %#ok<FNDSB>

end

fedTable = noDelTab; %#ok<NASGU>
% CaseNum = handles.CN;
% DepthID = handles.DID;
DepthIND = nDepthIND; %#ok<NASGU>

% Save new file
save(handles.file2load,'fedTable','DepthIND','-append')

OrigDlgH = ancestor(hObject, 'figure');
delete(OrigDlgH);
ModifySpike_v1;
