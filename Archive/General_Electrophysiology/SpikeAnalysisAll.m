function [] = SpikeAnalysisAll()

% Extract Original Voltage Vector
% Get Spike time Vector

% Load sorted spike data struct
cd('Y:\RawSortedSpikeData\FinalSpikeList')
load('SpikeData.mat')

% File name
testFileFN = saveSpikedata.fname{1};
testClustID = saveSpikedata.clusterNum{1};
testClustTN = saveSpikedata.wavedata{1}.spkTime;

% Get original voltage data

% Important elements of data file name
fileparts = strsplit(testFileFN,{'_','.'});

fDate = [fileparts{1}(1:2),'_',fileparts{1}(3:4),'_',fileparts{1}(5:8)];
fsurg = fileparts{2}(length(fileparts{2}));
fset = [upper(fileparts{3}(1)), fileparts{3}(2:end)];

if strcmp(fileparts{4}(1),'a')
    fab = 'AbvTrgt';
else
    fab = 'BlwTrgt';
end

fdNum = fileparts{4}(2:end);
fdepth = fileparts{5};
fele = fileparts{6};

% Get original voltage data

maindir = 'Y:\PreProcessEphysData';

[fdirList] = getDirList(maindir);

combineDS = strcat(fDate,'_',fsurg);

if ismember(combineDS,fdirList)
    dateFold = combineDS;
else
    dateFold = fDate;
end

dateFdir = [maindir,'\',dateFold];

% Change directory to recording date
cd(dateFdir)

% NEED TO LOOK FOR SET

% In some cases there is a depth number mismatch
% Get list of DEPTHS
[dFileList] = getFileList(dateFdir,'mat');

dN_Dep = cell(length(dFileList),2);
for di = 1:length(dFileList)
    dParts = strsplit(dFileList{di},{'_','.'});
    dN_Dep{di,1} = dParts{2};
    dN_Dep{di,2} = dParts{3};
end

depAct = dN_Dep{ismember(dN_Dep(:,2),fdepth),1};

if strcmp(depAct,fdNum)
    spkFname = [fab,'_',fdNum,'_',fdepth,'.mat'];
else
    spkFname = [fab,'_',depAct,'_',fdepth,'.mat'];
end
    
load(spkFname)

switch fele
    case '1'
        ele2use = double(CElectrode1);
    case '2'
        ele2use = double(CElectrode2);
    case '3'
        ele2use = double(CElectrode3);
end


% Extract waveforms from voltage trace by spike times
% Loop through clusters














end % END OF MAIN FUNCTION



function [outList] = getDirList(indir)

fDir = dir(indir);
fDnamesAll = {fDir.name};
fDnames = fDnamesAll(3:end);
outList = fDnames;

end

function [outList] = getFileList(indir,ext)

ext2use = ['*.',ext];

cd(indir)

fDir = dir(ext2use);
fDnamesAll = {fDir.name};
outList = fDnamesAll;

end




