%% Load data file with microwire

cd('I:\01_Coding_Datasets\VISUAL_TRACE_test\nwbMicdat')

load("micDat.mat",'microData')

%% filter data
% sFs = 32000;
% [filterData , meanALL , sdALL] = mmfilterFun(microData , sFs);

%% Calculate epochs

% [EpochInds] = getEpochs(filterData);

%% Load filter data

load("filmDat.mat",'filterData','meanALL','sdALL','EpochInds')

%% Plot thresholds

minDIST = 1.9;
sdOff = 3;
chanID = 1;
epochID = 20;
filrawDat = filterData(EpochInds(epochID,1):EpochInds(epochID,2),...
    chanID);

sampLen = round(32000/1000);
minDist = sampLen * minDIST;
waveWIN = round(sampLen*2.62);
% totLen = length(1 - (sampLen/2):1 + (round(sampLen*0.95)-1));
totLen = length(1 - (round(waveWIN*0.3)):1 + (round(waveWIN*0.7)-1));
%%
% Positive
runStd2=filteredSignal;
upperlimFixed = params.extractionThreshold * median(abs(filteredSignal)/0.6745);
% Negative
runStd2=-1*filteredSignal;
upperlimFixed = params.extractionThreshold * median(abs(filteredSignal)/0.6745);
% Pos and Neg
runStd2=abs(filteredSignal);
upperlimFixed = params.extractionThreshold * median(runStd2/0.6745);

%%
% threshL = meanALL(chanID,2) + (sdALL(chanID,2)*sdOff);
threshL = double(sdOff * median(abs(filrawDat)/0.6745));
% threshN = meanALL(chanID,2) + (sdALL(chanID,2)*9);

%% Check threshold works --- checked

sdS = 1:7;

for si = 1:length(sdS)

    sdOff = sdS(si);

    threshL = meanALL(chanID,2) + (sdALL(chanID,2)*sdOff);

    plot(filrawDat,'k')
    yline(threshL,'r--',['Threshold ' num2str(sdOff)])
    ylim([meanALL(chanID,2)-(sdALL(chanID,2)*7) meanALL(chanID,2)+(sdALL(chanID,2)*7)])

    pause

end

%% Check waveforms
minDISTv = 1.9;
sdOff = 3;
threshL = double(sdOff * median(abs(filrawDat)/0.6745));
threshN = double(7 * median(abs(filrawDat)/0.6745));
[PwaveForms] = calculateWaves(filrawDat , minDISTv , threshL , threshN);

minPeakvalp = min(PwaveForms,[],'all');
minYvalp = minPeakvalp + (minPeakvalp * 0.1);
maxPeakvalp = max(PwaveForms,[],'all');
maxYvalp = maxPeakvalp + (maxPeakvalp * 0.1);

plot(PwaveForms, 'Color', 'r');
xlim([1 totLen]);
ylim([minYvalp maxYvalp]);
xticks([])
yticks([])
stitleStrp = ['Positive = ',num2str(size(PwaveForms,2))];
subtitle(stitleStrp,'Color','r');















































function [filterData , meanALL , sdALL] = mmfilterFun(mWireData , sFs)
% Extract relevant NWB info
% Sampling frequency
% Access the struct names in the NWB acquisition field
mwireData = mWireData;
% Extract channel data
% Extract vector of data
% Extract channel of interest
ALLchannelData = mwireData;
filterData = zeros(size(ALLchannelData),'int16');

% loop through channel data
meanALL = zeros(size(mwireData,2),3);
sdALL = zeros(size(mwireData,2),3);
for ci = 1:size(mwireData,2)

    tmpChannel = mwireData(:,ci);

    cgrDATAnew = tmpChannel;
    nFs = sFs;
    hpFreq = 600;
    lpFreq = 3000;

    meanALL(ci,1) = mean(cgrDATAnew);
    sdALL(ci,1) = std(cgrDATAnew);

    [highPASS,~] = highpass(cgrDATAnew , hpFreq , nFs);

    [filterTmp,~] = lowpass(highPASS, lpFreq, nFs,...
        'ImpulseResponse', 'iir', 'Steepness' ,0.8);

    filterData(:,ci) = filterTmp;
    meanALL(ci,2) = mean(filterTmp);
    sdALL(ci,2) = std(filterTmp);

    abFilt = abs(filterTmp);

    meanALL(ci,3) = mean(abFilt);
    sdALL(ci,3) = std(abFilt);

    disp(['Done ' num2str(ci)])

end

end




function [EpochInds] = getEpochs(microData)

numEpoches = floor(height(microData)/(32000*5));
startINDS = transpose(1:32000*5:(32000*numEpoches*5));
stopINDS = [startINDS(2:end)-1 ; height(microData)];
EpochInds = [startINDS , stopINDS];

end



function [PwaveForms] = calculateWaves(filrawDat , minDISTv , threshL , threshN)
% Get ephys block: epochID and channID for abs

sampLen = round(32000/1000);
minDist = sampLen * minDISTv;
waveWIN = round(sampLen*2.62);
% totLen = length(1 - (sampLen/2):1 + (round(sampLen*0.95)-1));
waveWINinds = 1 - (round(waveWIN*0.3)):1 + (round(waveWIN*0.7)-1);
totLen = length(waveWINinds);

% Positive waves
[locs_Rwave ,  ~] = peakseek(filrawDat , minDist , threshL);

% Negative waves
% nfilrawDat = filrawDat;
% nfilrawDat(nfilrawDat > 0) = 0;
% [locs_NGwave ,  ~] = peakseek(abs(double(nfilrawDat)) , minDist , threshL);

% Positive Noise
[peakP2rem,  ~] = peakseek(filrawDat , minDist , threshN);

% Find noise peak overlap with positive peaks
ind2remPPks = ~ismember(locs_Rwave,peakP2rem);
% Save only actual peaks [exclude noise peaks]
locs_Rwave = locs_Rwave(ind2remPPks);
% Remove any peaks located less than sample length
locs_Rwave = locs_Rwave(locs_Rwave > sampLen);

% Negative Noise
% [app.peakN2rem ,  ~] = peakseek(abs(double(nfilrawDat)) , minDist , threshN);
% 
% app.ind2remNPks = ~ismember(app.locs_NGwave,app.peakN2rem);
% app.locs_NGwave = app.locs_NGwave(app.ind2remNPks);
% app.locs_NGwave = app.locs_NGwave(app.locs_NGwave > sampLen);

PwaveForms = zeros(totLen,length(locs_Rwave));
for ai = 1:length(locs_Rwave)
    locP = locs_Rwave(ai);
    sampPeriod = locP - (waveWINinds);
    if any(sampPeriod > length(filrawDat))
        PwaveForms(:,ai) = [];
        break
    else
        PwaveForms(:,ai) = filrawDat(sampPeriod);
    end
end

% app.NwaveForms = zeros(totLen,length(app.locs_NGwave));
% for ai = 1:length(app.locs_NGwave)
%     locP = app.locs_NGwave(ai);
%     sampPeriod = locP - (sampLen/2):locP + (round(sampLen*0.8)-1);
%     if any(sampPeriod > length(filrawDat))
%         app.NwaveForms(:,ai) = [];
%         break
%     else
%         app.NwaveForms(:,ai) = (filrawDat(sampPeriod))*-1;
%     end
% end

% tempAllWAVES = [app.NwaveForms , app.PwaveForms];
% if size(tempAllWAVES,2) <= 100
%     app.waveForms = [app.NwaveForms , app.PwaveForms];
% else
%     ind2use = randperm(size(tempAllWAVES,2),100);
%     app.waveForms = tempAllWAVES(:,ind2use);
% end

end
