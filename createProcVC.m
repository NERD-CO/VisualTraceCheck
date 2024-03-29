function [] = createProcVC()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fileCname = ['VC_',sprintf('%X','FileLoc'),'.txt'];
fileCheck = string(fileCname);

% fileDname = ['VC_',sprintf('%X','FilePrc'),'.txt'];
% fileProc = string(fileDname);

% Identify location of fileCheck
[textLocFlag,mainFoldLoc] = uigetfile('*.txt');

while textLocFlag == 0
    [textLocFlag,mainFoldLoc] = uigetfile('*.txt');
end

textLF = string(textLocFlag);
if fileCheck ~= textLF
    return
end

rawDataFold = [mainFoldLoc , filesep , 'RAW_Ephys_Files', filesep];
% fil2spkFold = [mainFoldLoc , filesep , 'SpikeDates2Cluster', filesep];
visCdatFold = [mainFoldLoc , filesep , 'VisualPrepFiles', filesep];

% Load location with Spike Files to Cluster - RAW_Ephys_Files
cd(rawDataFold)

% Get directory of cases
surgDir1 = dir;
surgDir2 = {surgDir1.name};
surgDir3 = surgDir2(~ismember(surgDir2,{'.','..'}));

for si = 1:length(surgDir3)
    
    saveFname = ['VC_',surgDir3{si},'.mat'];
    % CHECK for COMPLETE
    cd(visCdatFold)
    ckmatDir = dir('*.mat');
    ckFnames = {ckmatDir.name};
    
    if ismember(saveFname,ckFnames)
        continue
    end
    
    % CD to raw surgery folder
    tmpSurgLoc = [rawDataFold , surgDir3{si}];
    cd(tmpSurgLoc)
    % Get mat file list
    mDir = dir('*.mat');
    mFnames = {mDir.name};
    
    % Reorder with Abv and Below separate
    mFnamesSp = cellfun(@(x) strsplit(x,'_'), mFnames, 'UniformOutput',false);
    abF = cellfun(@(x) x{1}, mFnamesSp, 'UniformOutput',false);
    
    aInd = cellfun(@(x) strcmp(x,'AbvTrgt'), abF);
    
    depthNumsA = str2double(cellfun(@(x) x{2}, mFnamesSp(aInd), 'UniformOutput',false));
    depthNumsB = str2double(cellfun(@(x) x{2}, mFnamesSp(~aInd), 'UniformOutput',false));
    
    [~ , newOrderA] = sort(depthNumsA);
    [~ , newOrderB] = sort(depthNumsB);
    
    mFnamesA = mFnames(aInd);
    mFnamesB = mFnames(~aInd);
    
    mFnamesF = [mFnamesA(newOrderA)   mFnamesB(newOrderB)];
    
    fileTotal = numel(mFnamesF);
    
    % Loop through depth names to get sample number for each depth
    spkDim = zeros(fileTotal,1);
    for fi1 = 1:fileTotal
        
        activeFileNum = fi1;
        activeFileName = mFnamesF{activeFileNum};
        tmpMfile = matfile(activeFileName);
        tmpWholist = whos(tmpMfile);
        
        % Determine if CSPK or CElectrode
        if any(contains({tmpWholist.name},'CElectrode'))
            recFlag = 'mg';
        else
            recFlag = 'no';
        end
        
        tmpWhoNames = {tmpWholist.name};
        switch recFlag
            case 'mg'
                eleNAME = 'CElectrode';
                justSpks = tmpWholist(ismember(tmpWhoNames,[eleNAME,'1'])).size(2);
            case 'no'
                eleNAME = 'CSPK_0';
                justSpks = tmpWholist(ismember(tmpWhoNames,[eleNAME,'1'])).size(2);
        end
        %                 dn4 = ceil(justSpks/4);
        
        spkDim(fi1) = justSpks;
    end % Loop through depth files
    
    disp(['Spikes done for ',surgDir3{si} ,' !!'])
    
    % Get number of electrode tracks: File number * electode number
    switch recFlag
        case 'mg'
            cspkS = tmpWhoNames(contains(tmpWhoNames,eleNAME));
        case 'no'
            cspkS = tmpWhoNames(contains(tmpWhoNames,eleNAME));
    end
    
    % Get mer info that will be true for all depth files in surgery
    load(mFnamesF{1},'mer')
    
    switch recFlag
        case 'mg'
            uniqueVals = unique(cellfun(@(x) str2double(x(11)), cspkS, 'UniformOutput',true));
        case 'no'
            uniqueVals = unique(cellfun(@(x) str2double(x(7)), cspkS, 'UniformOutput',true));
    end
    TotalVals = numel(uniqueVals);
    newFS = round(mer.sampFreqHz/4);
    minDist = round(newFS/1000) * 1.9;
    sampLen = round(newFS/1000);
    
    % Combine and downsample
    % All data matrix
    % Modify to cell array
    allDAT = cell(TotalVals*length(spkDim) , 1);
    
%     allDAT = nan(TotalVals*length(spkDim) , max(spkDim), 'single');
    % Case ID
    caseID = cell(TotalVals*length(spkDim) , 1);
    % Electrode ID
    elecID = zeros(TotalVals*length(spkDim) , 1);
    % Segment indices
    segIDs = struct;
    rowC = 1;
    for ai = 1:length(spkDim)
        
        activeFileNum = ai;
        activeFileName = mFnamesF{activeFileNum};
        
        load(activeFileName) %#ok<LOAD>
        
%         tmpColn = spkDim(ai);
        
        for ei = 1:TotalVals
            
            switch recFlag
                case 'mg'
                    tmpEf = eval([eleNAME,num2str(uniqueVals(ei))]);
                case 'no'
                    tmpEf = eval([eleNAME,num2str(uniqueVals(ei))]);
            end
            tmpEfdn = downsample(tmpEf,4);
                      
            allDAT{rowC} = int16(tmpEfdn);
            
            caseID{rowC} = mFnamesF{ai};
            elecID(rowC) = uniqueVals(ei);
            
            rowC = rowC + 1;
        end
        
        % Figure out Segs
        minS = floor(length(tmpEfdn)/newFS);
        segBlkbase = (0:minS)*newFS;
        segStarts = (segBlkbase) + 1;
        segEnds = [segBlkbase(2:end),length(tmpEfdn)];
        
        tmpFn = strsplit(activeFileName,'.');
        tmpFnS = tmpFn{1};
        
        segIDs.(tmpFnS).segSE(:,1) = segStarts;
        segIDs.(tmpFnS).segSE(:,2) = segEnds;
        
        disp(['Segs for depth ' ,activeFileName , ' and ' , surgDir3{si} ,' !!'])
        
    end
    
    allDAT16 = allDAT;
    
    % WAVEFORMS
    threshInfo = zeros(size(allDAT16,1),4,4);
    waveForms = cell(size(allDAT16,1),4);
    
    for wi = 1:size(allDAT16,1)
        
        activeFileName = caseID{wi};
        tmpActIND = ismember(caseID,activeFileName);
        rowNUMS = find(tmpActIND);
        % Electrode IDs
        tmpEleNum = elecID(tmpActIND);
        % Data matrix
        tmpRawDat = allDAT16(tmpActIND,:);
        
        for eleII = 1:length(tmpEleNum)
            
            yDatAll = tmpRawDat{eleII};
            thrYdat = yDatAll(~yDatAll == 0);
            
            threshALL = 3:6;
            for thi = 1:length(threshALL)
                
                % Current standard threshold
                tmpThreshMp = std(double(thrYdat)) * threshALL(thi);
                % Noise threshold
                tmpThreshNoise = std(double(thrYdat)) * 8;
                % Mean
                tmpMean = mean(double(thrYdat));
                threshInfo(rowNUMS(eleII),1,thi) = tmpMean;
                % For plotting
                yLIMstd = std(double(thrYdat)) * 9;
                
                threshL = tmpMean + tmpThreshMp;
                threshInfo(rowNUMS(eleII),2,thi) = threshL;
                
                rem = tmpMean + tmpThreshNoise;
                threshInfo(rowNUMS(eleII),3,thi) = rem;
                
                YLIMi = tmpMean + yLIMstd;
                threshInfo(rowNUMS(eleII),4,thi) = YLIMi;
                
                spkData = double(yDatAll);
                negSpkDat = spkData;
                negSpkDat(spkData > 0) = 0;
                
                [locs_Rwave ,  ~] = peakseek(spkData , minDist , threshL);
                [locs_NGwave ,  ~] = peakseek(abs(negSpkDat) , minDist , threshL);
                
                [peakP2rem ,  ~] = peakseek(spkData , minDist , rem);
                [peakN2rem ,  ~] = peakseek(abs(negSpkDat) , minDist , rem);
                
                ind2remPPks = ~ismember(locs_Rwave,peakP2rem);
                locs_Rwave = locs_Rwave(ind2remPPks);
                
                ind2remNPks = ~ismember(locs_NGwave,peakN2rem);
                locs_NGwave = locs_NGwave(ind2remNPks);
                
                totLen = length(1 - (sampLen/2):1 + (round(sampLen*0.8)-1));
                
                PwaveForms = zeros(totLen,length(locs_Rwave));
                for ai = 1:length(locs_Rwave)
                    locP = locs_Rwave(ai);
                    sampPeriod = round(locP - (sampLen/2):locP + (round(sampLen*0.8)-1));
                    
                    shortCh = any(sign(sampPeriod) <= 0);
                    longch = any(sampPeriod > length(spkData));
                    
                    if ~(longch || shortCh)
                        PwaveForms(:,ai) = spkData(sampPeriod);
                    end
                end
                
                PwaveFormsU = PwaveForms(:,PwaveForms(1,:) ~= 0);
                
                % Get rid of points to close to edge NEW 6/15/2016
                vals2short = locs_NGwave < newFS*0.05;
                locs_NGwave = locs_NGwave(~vals2short);
                
                NwaveForms = zeros(totLen,length(locs_NGwave));
                for ai = 1:length(locs_NGwave)
                    locP = locs_NGwave(ai);
                    sampPeriod = round(locP - (sampLen/2):locP + (round(sampLen*0.8)-1));
                    
                    shortCh = any(sign(sampPeriod) == -1);
                    longch = any(sampPeriod > length(spkData));
                    
                    if ~(longch || shortCh)
                        NwaveForms(:,ai) = (spkData(sampPeriod))*-1;
                    end
                end
                
                NwaveFormsU = NwaveForms(:,NwaveForms(1,:) ~= 0);
                
                waveForms{rowNUMS(eleII),thi} = [NwaveFormsU , PwaveFormsU];
                
                disp(['Threshold ', num2str(thi), ' out of ', num2str(length(threshALL))])
            end
            disp(['Electrode ', num2str(eleII), ' out of ', num2str(length(tmpEleNum))])
        end
        disp(['Depth ', num2str(wi), ' out of ', num2str(size(allDAT16,1))])
    end
    % Save
    % 1. Depth file name list
    % 2. All data struct
    % 3. Number of electrodes
    % 4. Machine NO/MG and electrode name
    % 5. SegIDs
    % 6. CaseID
    % 7. EleID
    
    surgInfo.machine = recFlag;
    surgInfo.numEles = TotalVals;
    surgInfo.eleName = eleNAME;
    
    cd(visCdatFold)
    
    save(saveFname, 'caseID','elecID','segIDs','allDAT16','surgInfo',...
        'threshInfo','waveForms','-v7.3')
    
    
end % Loop through surgery dates



end

