% Main Directory

% Raw isolated recordings

% Load the data

mainDir = 'Z:\Crane_Summer2020\CaseData\SpikeProcessing\SpikeDates2Cluster';
allEphysDir = 'Z:\Crane_Summer2020\CaseData\SpikeProcessing\';
cd(mainDir);
matFiles = dir('*.mat');
matFiles2 = {matFiles.name};


%%% FIRST ANALYSIS - Fraction of active recordings

% May further follow up with specific analysis of implanted track

allFracAct = zeros(length(matFiles2),1);

for mi = 1:length(matFiles2)
    
    tmpMfile = matFiles2{mi};
    
    load(tmpMfile , 'DepthIND')
    
    tmpDepthIND = DepthIND;
    
    totalNumRec = length(tmpDepthIND) * length(tmpDepthIND{1});
    
    activeNum = sum(cellfun(@(x) sum(x), tmpDepthIND , 'UniformOutput', true));
    
    fracActive = activeNum/totalNumRec;
    
    allFracAct(mi) = fracActive;

end


%%% Second ANALYSIS - Analysis the normalized root mean square of the
%%% voltage

for mi2 = 1:length(matFiles2)
   
    % Change directory back to surgery directory
    cd(mainDir);
    % Get a temporay file name
    tmpMfile = matFiles2{mi2};
    
    % Get file information
    tmpStrgs = strsplit(tmpMfile,'_');
    
    dateName = tmpStrgs{1};
    setNUM = str2double(tmpStrgs{3});
    surgNum = str2double(tmpStrgs{2}(1));

    % Load in surgery file for depth information
    load(tmpMfile , 'DepthIND' , 'DepthID')
    % Load depth variable
    tmpDepthIND = DepthIND;
    tmpDepthID = DepthID;
    
    if setNUM == 0
        addFold = '';
    elseif setNUM == 1
        addFold = 'Set1';
    elseif setNUM == 2
        addFold = 'Set2';
    end

    if surgNum == 0
        surgAdd = '';
    else
        surgAdd = ['_',tmpStrgs{2}(1)];
    end
    
    newDname = [dateName(1:2), '_', dateName(3:4), '_', dateName(5:end), surgAdd];
    
    tmpLoc = [allEphysDir  , 'RAW_Ephys_Files' , filesep, newDname , filesep , addFold];
    
    cd(tmpLoc)
    
    % Loop through our active depths
    for di = 1:length(tmpDepthIND)
        
        load(tmpDepthID{di})
        
        % list of depth file 
        tmpIND = tmpDepthIND{di};
        
        for ei = 1:length(tmpIND)
             
            if ~tmpIND(ei)
                continue
            else
                
                
                
            end
    
        end
    end

end



