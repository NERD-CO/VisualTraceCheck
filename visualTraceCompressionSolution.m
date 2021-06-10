% Matrix column number
cd('D:\01_Coding_Datasets\VISUAL_TRACE_test\RAW_Ephys_Files\04_20_2017')
%%

matDir1 = dir('*.mat');
matDir2 = {matDir1.name};

spkDim = zeros(length(matDir2),1);
for mi = 1:length(matDir2)
    
    mt = matfile(matDir2{mi});
    
    wt = whos(mt);
    wtt = {wt.name};
    
    wi = wt(ismember(wtt,'CSPK_01')).size(2);
    
    dn4 = ceil(wi/4);
    
    spkDim(mi) = wi;
    
end

% Matrix row number

% File number * electode number
cspkS = wtt(contains(wtt,'CSPK'));

uniqueVals = unique(cellfun(@(x) str2double(x(7)), cspkS, 'UniformOutput',true));

TotalVals = numel(uniqueVals);

newFS = round(44000/4);

% Combine and downsample
allDAT = nan(TotalVals*length(spkDim) , max(spkDim), 'single');
caseID = cell(TotalVals*length(spkDim) , 1);
elecID = zeros(TotalVals*length(spkDim) , 1);
segIDs = struct;
rowC = 1;
for ai = 1:length(spkDim)
    load(matDir2{ai})
    for ei = 1:TotalVals
        
        tmpEf = eval(['CSPK_0',num2str(uniqueVals(ei))]);
        
        tmpEfdn = downsample(tmpEf,4);
        
        allDAT(rowC , 1:length(tmpEfdn)) = int16(tmpEfdn);
        
        caseID{rowC} = matDir2{ai};
        elecID(rowC) = uniqueVals(ei);
        
        rowC = rowC + 1;
    end
    
    % Figure out Segs
    minS = floor(length(tmpEfdn)/newFS);
    segBlkbase = (0:minS)*newFS;
    segStarts = (segBlkbase) + 1;
    segEnds = [segBlkbase(2:end),length(tmpEfdn)];
    
    tmpFn = strsplit(matDir2{ai},'.');
    tmpFnS = tmpFn{1};
    
    segIDs.(tmpFnS).segSE(:,1) = segStarts;
    segIDs.(tmpFnS).segSE(:,2) = segEnds;
    
end




