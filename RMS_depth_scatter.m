%Main Directory
clearvars

mainDir = 'Z:\Crane_Summer2020\SummaryData\RMS_summary\'
summaryDir = 'Z:\Crane_Summer2020\SummaryData\';

%load Data

cd(mainDir);
matFiles = dir('*.mat');
matFilesNames = {matFiles.name};

%create depth data table
for mi = 1:length(matFilesNames)
    load(matFilesNames{mi})
    tmpDepths = dataTable{:,1};
    for dpthi = 1:length(tmpDepths)
        depthTbl{dpthi,mi} = tmpDepths{dpthi};
    end
    
    
end

depthTbl2 = cell2table(depthTbl,'VariableNames',matFilesNames);

