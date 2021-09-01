function varargout = SecondSpikeSort(varargin)
% SECONDSPIKESORT MATLAB code for SecondSpikeSort.fig
%      SECONDSPIKESORT, by itself, creates a new SECONDSPIKESORT or raises the existing
%      singleton*.
%
%      H = SECONDSPIKESORT returns the handle to a new SECONDSPIKESORT or the handle to
%      the existing singleton*.
%
%      SECONDSPIKESORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SECONDSPIKESORT.M with the given input arguments.
%
%      SECONDSPIKESORT('Property','Value',...) creates a new SECONDSPIKESORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SecondSpikeSort_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SecondSpikeSort_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SecondSpikeSort

% Last Modified by GUIDE v2.5 23-Apr-2015 16:05:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SecondSpikeSort_OpeningFcn, ...
                   'gui_OutputFcn',  @SecondSpikeSort_OutputFcn, ...
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


% General plan for Spike GUI
% 
% Load in each spike file from spike .mat folder
% Individually plot each spike waveform
% Have questdlg button that pops up and asks if spike is acceptable
% Boolean answer is stored in file 
% Files will need to be clean, sorted and stored upon completion.





% --- Executes just before SecondSpikeSort is made visible.
function SecondSpikeSort_OpeningFcn(hObject, eventdata, handles, varargin) 
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SecondSpikeSort (see VARARGIN)

% Choose default command line output for SecondSpikeSort
handles.output = hObject;

set(handles.waveformPlot,'XTick',[])
set(handles.waveformPlot,'YTick',[])
set(handles.waveformPlot,'Box','off')
set(handles.waveformPlot,'xcolor',[0.9412 0.9412 0.9412]);
set(handles.waveformPlot,'ycolor',[0.9412 0.9412 0.9412]);
set(handles.waveformPlot,'Color' ,[0.9412 0.9412 0.9412]);

set(handles.spikeTemplate,'XTick',[])
set(handles.spikeTemplate,'YTick',[])
set(handles.spikeTemplate,'Box','off')
set(handles.spikeTemplate,'xcolor',[0.9412 0.9412 0.9412]);
set(handles.spikeTemplate,'ycolor',[0.9412 0.9412 0.9412]);
set(handles.spikeTemplate,'Color' ,[0.9412 0.9412 0.9412]);

set(handles.nonspkTemplate,'XTick',[])
set(handles.nonspkTemplate,'YTick',[])
set(handles.nonspkTemplate,'Box','off')
set(handles.nonspkTemplate,'xcolor',[0.9412 0.9412 0.9412]);
set(handles.nonspkTemplate,'ycolor',[0.9412 0.9412 0.9412]);
set(handles.nonspkTemplate,'Color' ,[0.9412 0.9412 0.9412]);

set(handles.nonSpikeT,'Visible','off')
set(handles.spikeT,'Visible','off')

set(handles.startAl, 'Enable', 'off')
set(handles.export,'Enable','off')

% set(handles.load_wforms,'Enable','off')





% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SecondSpikeSort wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SecondSpikeSort_OutputFcn(hObject, eventdata, handles)  %#ok<*INUSL>
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%
% WAVEFORM PLOT **********************************************************%
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%





% --------------------------------------------------------------------
function load_spktrn_ClickedCallback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to load_spktrn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plot_clust_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to plot_clust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function openNewdir_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openNewdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.spikedir = uigetdir;

cd(handles.spikedir);

expDir = dir('*.mat');
expNames = {expDir.name};
handles.spikeList = expNames;

handles.numFiles = length(expNames);



set(handles.numSpkfs,'String',['No. of files = ',num2str(handles.numFiles)])

set(handles.statusMsg,'String','Press Start Analysis');

set(handles.startAl, 'Enable', 'on')

% Update handles structure
guidata(hObject, handles);










% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function restart_p_Callback(hObject, eventdata, handles)
% hObject    handle to restart_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.waveformPlot)
set(handles.waveformPlot,'XTick',[])
set(handles.waveformPlot,'YTick',[])
set(handles.waveformPlot,'Box','off')
set(handles.waveformPlot,'xcolor',[0.9412 0.9412 0.9412]);
set(handles.waveformPlot,'ycolor',[0.9412 0.9412 0.9412]);
set(handles.waveformPlot,'Color' ,[0.9412 0.9412 0.9412]);

set(handles.nonSpikeT,'Visible','off')
set(handles.spikeT,'Visible','off')

set(handles.startAl, 'Enable', 'off')
set(handles.export,'Enable','off')

set(handles.numSpkfs,'String','')

set(handles.updateNum,'String','')

set(handles.statusMsg,'String','Select Folder Icon to load Files');
set(handles.statusMsg,'ForegroundColor',[0 0 0]);

% --------------------------------------------------------------------
function exit_p_Callback(hObject, eventdata, handles)
% hObject    handle to exit_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in startAl.
function startAl_Callback(hObject, eventdata, handles)
% hObject    handle to startAl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


fileList = handles.spikeList;

spikeOut = struct;
spikeCount = 1;

for fli = 1:length(fileList)
    
    spkFiletoOpen = fileList{fli};
    handles.curSpkfile = spkFiletoOpen;
    
    load(handles.curSpkfile);
    matSPK = matfile(handles.curSpkfile);
    % find adc in workspace
    listWS = whos(matSPK);
    wsNames = {listWS.name};
    spkFind = cellfun(@(x) ~isempty(strfind(x,'adc')), wsNames);
    
    spkFname = wsNames{spkFind};
    
    spkDATA = eval(spkFname);
    
    clearvars(wsNames{:});
    
    numClusts = max(spkDATA(:,2));
    
    cluIDs = 0:1:numClusts;
    waveData = struct;
    for cli = 1:numClusts + 1;
        
        cluIndex = spkDATA(:,2) == cluIDs(cli);
        
        waveData.(strcat('clst',num2str(cluIDs(cli)))).spkTime = spkDATA(cluIndex,3);
        waveData.(strcat('clst',num2str(cluIDs(cli)))).waveforms = spkDATA(cluIndex,12:43)';
        waveData.(strcat('clst',num2str(cluIDs(cli)))).aveWaveform = mean(spkDATA(cluIndex,12:43));
        waveData.(strcat('clst',num2str(cluIDs(cli)))).pvarWaveform = mean(spkDATA(cluIndex,12:43)) + std(spkDATA(cluIndex,12:43));
        waveData.(strcat('clst',num2str(cluIDs(cli)))).nvarWaveform = mean(spkDATA(cluIndex,12:43)) - std(spkDATA(cluIndex,12:43));
        
    end
    
    cluNames = fieldnames(waveData);
    cluNames = cluNames(2:end);
    
    axes(handles.waveformPlot);
    cla
    
    set(handles.waveformPlot,'Color',[0 0 0])
    
    x = 1:1:32;
    
    % Set up variable for y min and max
    
    yAxisDim = zeros(length(cluNames) ,2);
    
    set(handles.nonSpikeT,'Visible','on')
    set(handles.spikeT,'Visible','on')
    
    axes(handles.spikeTemplate)
    spikIm = imread('SpikeS.tif');
    imshow(spikIm);
    
    axes(handles.nonspkTemplate)
    nonspikIm = imread('NONSpike.tif');
    imshow(nonspikIm);
    
    set(handles.updateNum,'String',['Viewing : ', spkFiletoOpen])
    
    drawnow
    
    for ci = 1:length(cluNames)
        
        axes(handles.waveformPlot);
        cla
        
        mWaveForms = waveData.(cluNames{ci}).aveWaveform;
        pWaveForms = waveData.(cluNames{ci}).pvarWaveform;
        nWaveForms = waveData.(cluNames{ci}).nvarWaveform;
        
        xflip = [x(1 : end) fliplr(x)];
        yflip = [pWaveForms fliplr(nWaveForms)];
        
        patch(xflip,yflip,'r','FaceAlpha',0.4);
        hold on

        patchline(x,mWaveForms,'linestyle','-','edgecolor','r','linewidth',1,'edgealpha',1);
        
        yAxisDim(ci,1) = min(yflip);
        yAxisDim(ci,2) = max(yflip);
        
        set(handles.waveformPlot,'YLim',[min(yAxisDim(:,1)) max(yAxisDim(:,2))])
        set(handles.waveformPlot,'XLim',[1 max(x)]);
        
        % Add question about if is spike or not
        isSpike = questdlg('Is the waveform a SPIKE?','SPIKE?','Yes','No','Yes');
        
        if strcmp(isSpike,'Yes')
            spikeOut.fname{spikeCount,1} = spkFiletoOpen;
            spikeOut.clusterNum{spikeCount,1} = cluNames{ci};
            spikeOut.wavedata{spikeCount,1} = waveData.(cluNames{ci});
            
            spikeCount = spikeCount + 1;
            
        end
        
    end
    
end

handles.spikeDATA = spikeOut;

axes(handles.waveformPlot);
cla
axes(handles.spikeTemplate)
cla
axes(handles.nonspkTemplate)
cla

set(handles.startAl,'Enable','off')

set(handles.export,'Enable','on')

set(handles.statusMsg,'String','Analysis Done, EXPORT file')

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function expOut_Callback(hObject, eventdata, handles)
% hObject    handle to expOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

curDir = pwd;

foldsINdir = dir;                     % Get directory of current folders
dirIndex = {foldsINdir.isdir};        % Extract Boolean if variable is a dir
dirIndex = dirIndex(3:end);           % Exclude first two rows (not relevant)
dirIndex = cell2mat(dirIndex);        % Convert cell array to vector
dirNames = {foldsINdir.name};         % Extract cell array of folder names
dirNames = dirNames(3:end);           % Exclude first two rows (not relevant)

% Search for mat file save location
if sum(dirIndex) == 0                 
    mkdir(strcat(curDir,'\FinalSpikeList'));
elseif sum(dirIndex) ~= 0 && ~ismember('FinalSpikeList',dirNames(dirIndex))
    mkdir(strcat(curDir,'\FinalSpikeList'));
end

% Search for file move location
if sum(dirIndex) == 0
    mkdir(strcat(curDir,'\Analyzed Mat files'));
elseif sum(dirIndex) ~= 0 && ~ismember('Analyzed Mat files',dirNames(dirIndex))
    mkdir(strcat(curDir,'\Analyzed Mat files'));
end

moveDir = strcat(curDir,'\Analyzed Mat files');
saveDir = strcat(curDir,'\FinalSpikeList');

cd(saveDir)

handles.spikeDATA.AnalysisTimeStamp = date;

% CD into the save location
% Look for file
% If there load in and append
% Overwrite date time
% if not there save new

fDirList = dir('*.mat');
matList = {fDirList.name};

fCheck = ismember('SpikeData.mat',matList);

saveSpikedataNEW = handles.spikeDATA;

if fCheck
    load('SpikeData.mat')

    sFnames = fieldnames(handles.spikeDATA);
    saveSpikedataOUT = struct;
    
    for fi = 1:length(sFnames)
        saveSpikedataOUT.(sFnames{fi}) = [saveSpikedata.(sFnames{fi}) ; saveSpikedataNEW.(sFnames{fi})];
    end
else
    saveSpikedataOUT = saveSpikedataNEW;
end
    
saveSpikedata = saveSpikedataOUT;

save('SpikeData.mat','saveSpikedata');

fileList = handles.spikeList;

for fli = 1:length(fileList)

    oldLoc = strcat(curDir,'\',fileList{fli});
    newLoc = strcat(moveDir,'\',fileList{fli});
    
    movefile(oldLoc,newLoc);

end


set(handles.statusMsg,'String','EXPORT COMPLETE, Close program')
set(handles.statusMsg,'ForegroundColor',[1 0 0]);
