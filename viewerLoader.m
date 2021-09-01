function [handles,fdateN] = viewerLoader(handles,file2load,fedTable,rawFoldStart, cN2use)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Determine date of name
curDate = cN2use(1:10);
curInfo = [curDate(1:2),curDate(4:5),curDate(7:10)];

curDdate = datetime(curInfo,'InputFormat','MMddyyyy');
date2exceed = datetime('09132015','InputFormat','MMddyyyy');
curDnum = datenum(curDdate);
date2exNum = datenum(date2exceed);

if curDnum > date2exNum
    noCheck = 1;
else
    noCheck = 0;
end

fdateNparts = strsplit(file2load,{'-','_'});
fdateN = fdateNparts{1};
handles.surgNum = fdateNparts{2};
handles.setNum = fdateNparts{4};

% Create file to load
if strcmp(handles.surgNum,'0')
    fn2loc = [fdateN(1:2),'_',fdateN(3:4),'_',fdateN(5:8)];
else
    fn2loc = [fdateN(1:2),'_',fdateN(3:4),'_',fdateN(5:8),'_',handles.surgNum];
end

if ~strcmp(handles.setNum,'0')
    fn2loc = [fn2loc , '\Set' , handles.setNum];
end

handles.RAWfilesLOC = [rawFoldStart , '\', fn2loc];

cd(handles.RAWfilesLOC);

% DEPTH choice
tmpComb = cellfun(@(x,y) [x , '_' , y], fedTable.Depth, fedTable.ElNum, 'UniformOutput',false);

depthQuest = 'Select DEPTH';
titldep = 'DEPTH ID';
selectionsdep = tmpComb;
selectStrdep = 'Select DEPTH';
listSizedep = [300 300];

[depchoice,~] = listdlg('PromptString',depthQuest,...
    'Name',titldep,...
    'SelectionMode','single',...
    'ListSize',listSizedep,...
    'OKString',selectStrdep,...
    'fus',15,...
    'ListString',selectionsdep);

dep2load = fedTable.Depth{depchoice};
ele2load = fedTable.ElNum{depchoice};



handles.activeFileName = dep2load;
handles.ddepNUM.String = dep2load;
load(dep2load);
handles.spikeDataRaw = eval(ele2load);
handles.eleNUM.String = ele2load;
handles.fedTable = fedTable;

% handles.spikeDataRaw = eval(handles.fedTable.ElNum{1});

% NEW for NEUROMEGA
if noCheck
    
    handles.spikeDataRaw = handles.spikeDataRaw*300;
    
end

handles.spkFS = mer.sampFreqHz;
handles.loadLOC = rawFoldStart;
handles.startT = mer.timeStart;

end

