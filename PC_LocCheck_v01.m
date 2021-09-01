function [foldr2clr] = PC_LocCheck_v01(UserNum, AnalysisStage)
%PC_LocCheck_v01 directs Matlab to the appropriate folder based
%   User Number and Main folder location on PC
%
% INPUTS:
% UserNum = integer : 1 = Judy , 2 = John , 3 = McKenzie , 4 = Tyler
% AnalysisStage = integer : 1 = Current Nex, 2 = Completed foler, 3 = Raw
% data folder , 4 = Spike Mat files, 5 = Spike Mat Log, 6 = Meta Spike Data Folder
%
% OUTPUTS:
% folder2clr = identifies where to directory Matlab depending on the
% computer

if nargin == 0
    error('myApp:argChk', 'Need one input argument (i.e., 1, 2 or 3');
end

hostPCname = getenv('COMPUTERNAME');

switch AnalysisStage
    
    % Stage 1 - Go to Current Nex File Folder
    case 1
        
        switch UserNum
            case 1
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\Judy_Matlab\New Nex files';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\Judy_Matlab\New Nex files';
                end
            case 2
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\JohnAThompson_Matlab\New Nex files';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\JohnAThompson_Matlab\New Nex files';
                end
            case 3 % McKenzie
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\McKenzie_Winter\CURRENT Work Nex files';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\McKenzie_Winter\CURRENT Work Nex files';
                end
            case 4 % Tyler
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\Tyler_Gibson\CurrentNexFiles';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\Tyler_Gibson\CurrentNexFiles';
                end
        end
        
        
        % Stage 2 - Go to Mat file folder in Completed folder
    case 2
        
        switch UserNum
            
            case 2
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\JohnAThompson_Matlab\CompletedFiles\Mat files';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\JohnAThompson_Matlab\CompletedFiles\Mat files';
                end
                
            case 3 % McKenzie
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\McKenzie_Winter\CompletedFiles\Mat files\';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\McKenzie_Winter\CompletedFiles\Mat files\';
                end
                
            case 4 % Tyler
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\Tyler_Gibson\CompletedFiles\Mat files';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\Tyler_Gibson\CompletedFiles\Mat files';
                end
        end
        
        % Stage 3 - Go to Raw Data file
    case 3
        
        switch UserNum
            
            case 1 % Judy
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\Judy_Matlab\SUA_Data\';
                elseif strcmp(hostPCname,'JAT-PC')
                    return; % FOR DEBUGGING ON OFFICE COMPUTER
                elseif strcmp(hostPCname,'DRJTHOME-PC')
                    return;
                else
                    return;
                end
                
            case 3 % McKenzie
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\McKenzie_Winter\RawDataFiles\';
                elseif strcmp(hostPCname,'JAT-PC')
                    foldr2clr = 'E:\Dropbox\JohnAThompson_Matlab'; % FOR DEBUGGING ON OFFICE COMPUTER
                elseif strcmp(hostPCname,'DRJTHOME-PC')
                    foldr2clr = 'C:\Users\DrJTHome\Dropbox\JohnAThompson_Matlab';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\McKenzie_Winter\RawDataFiles\';
                end
                
            case 4 % Tessa
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\Tessa_Harland\RawDataFiles';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\Tessa_Harland\RawDataFiles';
                end
        end
        
        % Stage 4 - Go to Spike Mat Files in Completed Folder
    case 4
        
        switch UserNum
            
            case 3 % McKenzie
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\McKenzie_Winter\CompletedFiles\SpikeMatFiles\';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\McKenzie_Winter\CompletedFiles\SpikeMatFiles\';
                end
            case 4 % Tyler
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\Tyler_Gibson\CompletedFiles\SpikeMatfiles';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\Tyler_Gibson\CompletedFiles\SpikeMatfiles';
                end
        end
        
        % Stage 5 - Go to Spike Mat Log in Completed Folder
    case 5
        
        switch UserNum
            
            case 3 % McKenzie
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\McKenzie_Winter\CompletedFiles\SpikeMatLog\';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\McKenzie_Winter\CompletedFiles\SpikeMatLog\';
                end
            case 4 % Tyler
                if strcmp(hostPCname,'DRJT')
                    foldr2clr = 'E:\Dropbox\Tyler_Gibson\CompletedFiles\SpikeMatLog';
                else
                    foldr2clr = 'C:\Users\MatlabUser\Dropbox\Tyler_Gibson\CompletedFiles\SpikeMatLog';
                end
        end
        
        % Stage 6 - Go to all Spike folder in JohnAThompsonMatlab
    case 6
        
        if strcmp(hostPCname,'DRJT')
            foldr2clr = 'E:\Dropbox\JohnAThompson_Matlab\SpikeDates2Cluster';
        elseif strcmp(hostPCname,'JAT-PC')
            foldr2clr = 'E:\Dropbox\JohnAThompson_Matlab\SpikeDates2Cluster'; % FOR DEBUGGING ON OFFICE COMPUTER
        elseif strcmp(hostPCname,'DRJTHOME-PC')
            foldr2clr = 'C:\Users\DrJTHome\Dropbox\JohnAThompson_Matlab\SpikeDates2Cluster';
        else
            foldr2clr = 'C:\Users\MatlabUser\Dropbox\JohnAThompson_Matlab\SpikeDates2Cluster';
        end
        
    case 7
        
        if strcmp(hostPCname,'DRJT')
            foldr2clr = 'E:\Dropbox\JohnAThompson_Matlab\ClusterizedSpikeTimes';
        elseif strcmp(hostPCname,'JAT-PC')
            foldr2clr = 'E:\Dropbox\JohnAThompson_Matlab\ClusterizedSpikeTimes'; % FOR DEBUGGING ON OFFICE COMPUTER
        elseif strcmp(hostPCname,'DRJTHOME-PC')
            foldr2clr = 'C:\Users\DrJTHome\Dropbox\JohnAThompson_Matlab\ClusterizedSpikeTimes';
        else
            foldr2clr = 'C:\Users\MatlabUser\Dropbox\JohnAThompson_Matlab\ClusterizedSpikeTimes';
        end
        
    case 8
        
        if strcmp(hostPCname,'DRJT')
            foldr2clr = 'E:\Dropbox\JohnAThompson_Matlab\TremorCellInfo_TH';
        elseif strcmp(hostPCname,'JAT-PC')
            foldr2clr = 'E:\Dropbox\JohnAThompson_Matlab\TremorCellInfo_TH'; % FOR DEBUGGING ON OFFICE COMPUTER
        elseif strcmp(hostPCname,'DRJTHOME-PC')
            foldr2clr = 'C:\Users\DrJTHome\Dropbox\JohnAThompson_Matlab\TremorCellInfo_TH';
        else
            foldr2clr = 'C:\Users\MatlabUser\Dropbox\JohnAThompson_Matlab\TremorCellInfo_TH';
        end
        
end


end

