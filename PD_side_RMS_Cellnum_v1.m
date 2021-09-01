function [ cellDATA ] = PD_side_RMS_Cellnum_v1( debugTEST )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%%%%% TO ADD
%%% GET ratio by structure - depth related - striatum , thalamus, STN ,
%%% striatum

%%%% Create a structure plan:
%%%% Data
% ---- Top Structure
% A. Case
%    B. Pair ID 1 or 2 
%    C. Pair ID L or R
%    D. RMS for all
%    E. Index of cell containing traces
%    F. Cell struct
%       a. Trace ID
%       b. Number of cells
%          1. Cell
%              i. FR
%              ii. CV
%              iii. Burst profile
%              iv. ?




cd('Z:\Uy_MHA_2017\SpikeDates2Cluster')

cdir = dir('*.mat');
cdir2 = {cdir.name};

subcellAll = nan(length(cdir2) , 3);
allRMS = cell(length(cdir2),1);
allBlckRMS = cell(length(cdir2),1);

if debugTEST
    
    for i = 1:length(cdir2)
        cd('Z:\Uy_MHA_2017\SpikeDates2Cluster')
        DepthIND = {};
        DepthID = {};
        CaseNum = '';
        tc = cdir2{i};
        
        
        tcSp = replace(tc,{'_','-'},' ');
        tcSp2 = strsplit(tcSp,' ');
        %     surgN = str2double(tcSp2{2});
        setN = str2double(tcSp2{4});
        
        load(tc , 'DepthIND' , 'DepthID' , 'CaseNum')
        
        cellpres = transpose([DepthIND{:}]);
        
        % Cell count subjective
        
        subCell = nan(1,3);
        for ii = 1:size(cellpres,2)
            
            if sum(cellpres(:,ii)) == 0
                continue
            else
                subCell(ii) = sum(cellpres(:,ii))/size(cellpres,1);
            end
        end
        subcellAll(i,:) = subCell;
        
        % RMS
        
        
        if setN ~= 0
            foldN = ['Z:\Uy_MHA_2017\RAW_Ephys_Files\' , CaseNum , '\Set' , num2str(setN)];
        else
            foldN = ['Z:\Uy_MHA_2017\RAW_Ephys_Files\' , CaseNum ];
        end
        
        cd(foldN)
        
        depRMS = zeros(length(DepthID),3);
        depID = zeros(length(DepthID),1);
        for si = 1:length(DepthID)
            
            fnameT = DepthID{si};
            matTab = whos('-file',fnameT);
            matName = {matTab.name};
            noC1 = contains(matName,'CSPK');
            if sum(noC1) ~= 0
                noCheck = 1;
                
            else
                noCheck = 0;
                
            end
            
            load(fnameT); %#ok<LOAD>
            
            for nni = 1:3
                if noCheck
                    tmpN = ['CSPK_0',num2str(nni)];
                    if exist(tmpN,'var')
                        tData = eval(tmpN);
                        clear(tmpN)
                    else
                        continue
                    end
                else
                    tmpN = ['CElectrode',num2str(nni)];
                    if exist(tmpN,'var')
                        tData = eval(tmpN);
                        clear(tmpN)
                    else
                        continue
                    end
                end
                tDataS = double(tData).^2;
                rms = mean(tDataS);
                depRMS(si,nni) = rms;
            end
            
            fstrSp = strsplit(fnameT,{'_','.'});
            
            tmpNum = str2double(fstrSp{3});
            
            tmpNumE = tmpNum/1000;
            
            if contains(fstrSp{1},'Blw')
                tmpNumE = tmpNumE*-1;
            end
            
            depID(si) = tmpNumE;
            
        end
        fprintf('Cell %d Done! \n', i)
        
        [fDepRMS , DepBlockRMS] = fixCheckRMS(depRMS , depID);
        
        allRMS{i} = fDepRMS;
        allBlckRMS{i} = DepBlockRMS;
    end
    
else
    
    
    [cellDATA] = getClusterDATA(cdir2);
    
end

cd('Z:\Uy_MHA_2017\SummaryData')
save('Summary_CellNum_RMS.mat','cdir2','subcellAll' ,'allRMS','allBlckRMS');




end


function [allNeurons] = getClusterDATA(cdir)

spikeLOC = 'Z:\Uy_MHA_2017\ClusteredSpikeTimes';
cd(spikeLOC)

fdir = dir('*.mat');
fdir2 = {fdir.name};

cd('Z:\Uy_MHA_2017\SummaryData')
%     pairedTab = readtable('sideID.xlsx');
regionS = readtable('regionLOCS.xlsx');

allNeurons = cell(2000,1);

neuCount = 1;

for i = 1:length(cdir)

    fName = cdir{i};
    fParts = fName(1:10);
    
    curClind = contains(fdir2,fParts);
    
    tableIND = ismember(regionS.case_,fParts);
    
    if sum(tableIND) == 0
        continue
    end
    
    curClF = fdir2(curClind);
    
    for ii = 1:length(curClF)
        cd('Z:\Uy_MHA_2017\ClusteredSpikeTimes')
        tName = curClF{ii};
        
        load(tName);
        
        % depth value
        nParts = strsplit(tName, {'_','.'});
        depVal = str2double(nParts{5});
        % depth bin
        depV = round(depVal/1000,2);
        binID = getBin(depV);
        % electrode
        eleNum = str2double(nParts{6});
        % case number
        caseID = [nParts{1} ,'_', nParts{2}];
        
        
        
        % FIND number clusters
        allClusts = unique(spikeDATA.clustIDS);
        clustIDS = allClusts(allClusts ~= 0);
        numClusts = numel(clustIDS);
        
        cluStr = struct;
        for cii = 1:numClusts

            
            tClust = clustIDS(cii);
            clustIND = spikeDATA.clustIDS == tClust;
            
            % FR
            allSpks = spikeDATA.waveforms.allWavesInfo.alllocs(clustIND);
            numSpikes = numel(spikeDATA.waveforms.allWavesInfo.alllocs(clustIND));
            tmpBtSpks = max(allSpks) - min(allSpks);
            totTimeSec = tmpBtSpks/spikeDATA.merFs;
            fr = numSpikes/totTimeSec;
            
            cluStr.(['c',num2str(cii)]).fr = fr;
            cluStr.(['c',num2str(cii)]).dep_v = depVal;
            cluStr.(['c',num2str(cii)]).bin_id = binID;
            cluStr.(['c',num2str(cii)]).el = eleNum;
            cluStr.(['c',num2str(cii)]).cID = caseID;
            cluStr.(['c',num2str(cii)]).spkTimes = allSpks;
            cluStr.(['c',num2str(cii)]).clID = tClust;
            
            % Trajectory ID
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            allTrajs = regionS.trajs(tableIND);
            eleTraj = allTrajs{eleNum};
            
            cluStr.(['c',num2str(cii)]).eleTraj = eleTraj;
            
            % Implanted Trajectory
%             longTname = getLongTrajN(eleTraj);
            
            % INPUT cell ID row of regionS - 4:8
            % INPUT current depVal
            % OUTPUT structure stri , thal , stn , snr , ui
            
            caseRow = regionS(tableIND,:);
            eleRow = caseRow(caseRow.electrode == eleNum,:);
            strcLocs = eleRow(:,4:8);
            
            regLocID = determineReg(strcLocs, depVal);

            cluStr.(['c',num2str(cii)]).regLOC = regLocID;

            % amplitude values
            allWAVES = spikeDATA.waveforms.allWaves.waves;
            clWAVES = max(allWAVES(:,clustIND));
            
            cluStr.(['c',num2str(cii)]).pAmps = clWAVES;
            
            % Spectrogram
            allNeurons{neuCount,1} = cluStr.(['c',num2str(cii)]);
            neuCount = neuCount + 1;
            
            
        end
        
    end
    
end

end

%%%%%%%%%%%% HELPER FUNCTIONS

function [norMoutRMS , blockRMS] = fixCheckRMS(inRMS , depIN)

outRMS = nan(size(inRMS));
for i = 1:3
    
    tmpCol = inRMS(:,i);
    thres = quantile(tmpCol,0.75) + (4.5 * iqr(tmpCol));
    nanRep = tmpCol > thres;
    tmpCol(nanRep) = nan;
    outRMS(:,i) = tmpCol;
    
end

norMoutRMS = nan(size(outRMS));
for ni = 1:3
    
    noT = outRMS(:,ni);
    norMoutRMS(:,ni) = (noT - min(noT)) ./ (max(noT) - min(noT));
    
end


blockRMS = cell(4,3);

starts = [26 , 16 , 5 , -1];
stops = [16 , 5 , -1 ];

for ii = 1:4
    
    for i2 = 1:3
        tmpCol = norMoutRMS(:,i2);
        if ii ~= 4
            blID = depIN < starts(ii) & depIN > stops(ii);
        else
            blID = depIN < starts(ii);
        end
        blockRMS{ii,i2} = tmpCol(blID);
        
    end
    
end







end




function [regLocID] = determineReg(strcLocs, depVal)



if depVal > strcLocs.top_thal
    regLocID = 'stri';
elseif depVal < strcLocs.bot_stri && depVal > strcLocs.bot_thal
    regLocID = 'thal';
elseif depVal < strcLocs.bot_thal && depVal > strcLocs.top_stn
    regLocID = 'zi';
elseif depVal < strcLocs.top_stn && depVal > strcLocs.bot_stn
    regLocID = 'stn';
elseif depVal < strcLocs.bot_stn
    regLocID = 'snr';
else
    regLocID = 'id';
end



end



% function longTname = getLongTrajN(tLet)
% 
% switch tLet
%     case 'a'
%         longTname = 'ant';
%     case 'p'
%         longTname = 'post';
%     case 'c'
%         longTname = 'cen';
%     case 'l' 
%         longTname = 'lat';
%     case 'm' 
%         longTname = 'med';
% end
% end



function binID = getBin(depV)

bins = [25 22 19 16 13 10 7 4 1 -2];
binS = bins(1:end-1);
binE = bins(2:end);

r1 = depV < binS;
r2 = depV > binE;

binID = find(r1 == r2);



end





