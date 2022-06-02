
%
%does detection standalone
%prewhiten: 0/1. prewhiten of the raw signal,before extraction of spikes.
%alignMethod: 1 (pos), 2 (neg), 3 (mixed)
%
%
function handles = StandaloneInit_css( handles , tillBlocks, prewhiten, alignMethod,includeRange )

handles = initFilter(handles);
%read timestamps
% [timestamps,nrBlocks,nrSamples,sampleFreqInHeader,~,headerInfo] = getRawTimestamps( handles.rawFilename, handles.rawFileVersion );
% load in NWB file
% Extract first wire
% Length of recording = nrSamples
cd(handles.nwbRawloc)
testfile = nwbRead(handles.NWBfile);
microwireD = testfile.acquisition.get('MicroWireSeries');
mi_ts = microwireD.timestamps.load();
mi_dat = transpose(microwireD.data.load());

handles.nrSamples = size(mi_dat,1);

% if length(headerInfo)>0
%     ADbitVolts = str2num(getNumFromCSCHeader(headerInfo, 'ADBitVolts'));
% else
%     ADbitVolts = nan;  %undefined
% end
ADbitVolts = microwireD.data_conversion;

%old ret params: sampleFreq,isContinous,headerInfo
%sessionDuration=(timestamps(end)-timestamps(1))/1000;

%detection
paramsRaw.howManyBlocks = tillBlocks;
paramsRaw.startWithBlock = 1;
paramsRaw.includeRange = includeRange;
paramsRaw.prewhiten = prewhiten;
paramsRaw.alignMethod = alignMethod;

paramsRaw = copyStructFields(handles,paramsRaw, { {'paramExtractionThreshold','extractionThreshold'}, ...
    'rawFilePrefix','rawFilePostfix', 'doGroundNormalization', 'normalizationChannels', 'pathRaw', 'limit', 'samplingFreq', 'rawFileVersion', 'detectionMethod', 'detectionParams', 'peakAlignMethod',...
    'blocksize'});

if isfield(handles,'rawFilePrefix')
    paramsRaw.prefix = handles.rawFilePrefix;
end

[allSpikes, allSpikesNoiseFree, allSpikesCorrFree, allSpikesTimestamps, dataSamplesRaw,filteredSignal, rawMean,rawTraceSpikes,runStd2,upperlim, ...
    stdEstimates, blocksProcessed, noiseTraces] = processRaw_css(handles.rawFilename, handles.nrSamples, handles.Hd, paramsRaw , mi_ts, mi_dat(:,handles.channRow) );

%save returned values
handles.blocksProcessedForInit=blocksProcessed;
handles.dataSamplesRaw=dataSamplesRaw;
handles.rawMean=rawMean;
handles.rawTraceSpikes=rawTraceSpikes;
handles.runStd2=runStd2;
handles.upperlim=upperlim;
handles.filteredSignal=filteredSignal;
handles.noiseTraces=noiseTraces;

%estimate s.d. of raw signal
handles.stdEstimateOrig = calculateStdEstimate(stdEstimates); %mean(stdEstimates);
['std estimate is ' num2str(handles.stdEstimateOrig)]

handles.allSpikesNegative=allSpikes;
handles.allSpikesTimestampsNegative=allSpikesTimestamps;
handles.newSpikesNegative=allSpikes;
handles.newSpikesTimestampsNegative=allSpikesTimestamps;
handles.spikesSolvedNegative=allSpikes;
handles.allSpikesNoiseFree=allSpikesNoiseFree;
handles.allSpikesCorrFree=allSpikesCorrFree;

%for compatibility reasons
handles.allSpikesPositive=[];
handles.allSpikesTimestampsPositive=[];
handles.newSpikesPositive=[];
handles.newSpikesTimestampsPositive=[];
handles.spikesSolvedPositive=[];

%New: also store the scaling factor
handles.scalingFactor = ADbitVolts;

handles.stdEstimate = handles.stdEstimateOrig*handles.correctionFactorThreshold;
['std estimate corrected is ' num2str(handles.stdEstimate)]

'init finished'
