function doRMS(traj_Directory,electrode,AO_MATformat);
global WARNINGS AUTO_STAB
%input traj_Directory name eg: 'D:\DBS_human\STN_regular\2005_03_24\R_hem_traj_2\'
%AO_MATformat = 1 means that data is CElectrode1 CElectrode1_KHz etc. (otherwise I use Data1 etc.)
if nargin==0
    disp('Useage: doRMS(traj_Directory,electrode*=[1 2],*AO_MATformat=1-if exists)');
    disp('* means optional. (Default value indicated)');
    return
end
if traj_Directory(end) ~= '\', traj_Directory = strcat(traj_Directory,'\'); end
if nargin<2, electrode=[1 2]; end
if nargin<3
    if size(dir(strcat(traj_Directory,'AOMatlab\*.mat')),1)>10, AO_MATformat=1;%if there are Mat files use them
    else, AO_MATformat=0; end
end
count=0;count_E(1)=0;count_E(2)=0;
DirectoryMat=strcat(traj_Directory,'AOMatlab\');
if AO_MATformat, FileList = dir(strcat(DirectoryMat,'*.mat')); %load matlab files
else FileList = dir(strcat(traj_Directory,'*.map')); end %load MAP files
if size(FileList) == [0 1]
    disp('No files were found!'); disp('Check directory name.');
    if AO_MATformat, disp(DirectoryMat);
    else, disp(traj_Directory); end
    return
end
date_traj=strrep(strrep(traj_Directory(findstr('\20',traj_Directory)+1:end),'_','-'),'\','; ');
for i = 1:length(FileList)
    filename=FileList(i).name; filesizeM=(FileList(i).bytes)/(1024)^2;
    Current_Depth=str2num(filename(1:length(filename)-4)); %electr. depth from STN target (remove file ext.)
    if abs(Current_Depth)<20000 & (filesizeM<80) %If a few at depth 999 they are named: 999.MAP 999001.MAP 999002.MAP etc.
        skip_trace=[0 0];
        if ~AO_MATformat  %reads 2 electrodes' Data, Size and Info from MAP file
            fullpathfilename = strcat(traj_Directory,filename);
            [Data1,Data2,Info,n] = getE1_E2(fullpathfilename);
            if AUTO_STAB, [Data1,Data2,skip_trace]=check_stab(Data1,Data2,Info); end %excl trace if longest stable section <1s
            if WARNINGS & any(skip_trace), disp(strcat('WARNING: file # ',num2str(i),' name: ',filename,' elec(s):',num2str(find(skip_trace)),' excluded. Longest stable section was <1s.'));end
        else
            fullpathfilename = strcat(DirectoryMat,filename); load(fullpathfilename);  %reads 2 electrodes' Data, Size and Info from MAT file
            for j=1:length(electrode)
                elec=electrode(j); Info(elec).SampleRate = eval(sprintf('CElectrode%u_KHz*1000;',elec));
                if exist(sprintf('PSD_START%u',elec)) & exist(sprintf('PSD_END%u',elec)) %start and end (stability) are used to define the data
                    PSD_START=eval(sprintf('PSD_START%u',elec));PSD_END=eval(sprintf('PSD_END%u',elec));
                    if (PSD_START*PSD_END)>0, eval(sprintf('Data%u = CElectrode%u(PSD_START:min(PSD_END,end));',elec,elec));
                    else, skip_trace(elec)=1; end                 
                else
                    eval(sprintf('Data%u = CElectrode%u;',elec,elec));
                    if WARNINGS, display(strcat('WARNING, AO_MATformat used, but no start/stop defined (stability - RMS may include zeros): ',filename)); end
                end
            end
            clear PSD_START* PSD_END*
        end
        for j=1:length(electrode) %Calculate RMS (Standard Deviation)
            elec=electrode(j); SampleFreq(elec)=Info(elec).SampleRate; %extract sample rate from file Info
            if ~skip_trace(elec)
                count=count+1; count_E(elec) = count_E(elec)+1;
                eval(sprintf('SD_full(count_E(elec),elec)=std(Data%u,1);',elec));
                eval(sprintf('len_data=length(Data%u);',elec));
                recording_length(count_E(elec),elec)=len_data/SampleFreq(elec);
                if recording_length(count_E(elec),elec)<1
                    out_length = sprintf('\nlength:\t%f \t at depth:\t%f',recording_length(count_E(elec),elec),Current_Depth);
                    if WARNINGS, display(strcat('WARNING, recording length shorter than 1s. ',out_length)); end
                end
                Depth(count_E(elec),elec)=Current_Depth;
            end           
        end
    elseif WARNINGS, disp(strcat('WARNING: file # ',num2str(i),'. The file :',filename,' was not opened. Size: ',num2str(filesizeM),'Mb')); end
end

% SAVE RESULTS %
for i=1:length(electrode)
    elec=electrode(i);
    temp=sortrows([Depth(SD_full(:,elec)~=0,elec)';SD_full(SD_full(:,elec)~=0,elec)';recording_length(SD_full(:,elec)~=0,elec)']'); %sort the RMS in order of depth
    eval(sprintf('RMS%u=temp(:,2);',elec)); eval(sprintf('Elec_Depth%u=temp(:,1);',elec)); eval(sprintf('recording_length%u=temp(:,3);',elec)); 
    ResultsFile=sprintf('RMS%u.mat',elec);
    if AO_MATformat, eval(sprintf('save(strcat(DirectoryMat,ResultsFile),''-v6'',''Elec_Depth%u'',''RMS%u'',''recording_length%u'');',elec,elec,elec));
    else, eval(sprintf('save(strcat(traj_Directory,ResultsFile),''-v6'',''Elec_Depth%u'',''RMS%u'',''recording_length%u'');',elec,elec,elec));end
end

