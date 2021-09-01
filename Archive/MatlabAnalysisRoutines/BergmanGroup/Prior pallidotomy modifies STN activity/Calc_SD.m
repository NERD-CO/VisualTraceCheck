function [baseSD,NSD,NSD_av,NSD_var,NSD_diff,STN_step,STN_len,Data_len] = Calc_SD(Directory,channel,Pallidotomy,From_Mat,plot_all,sort_plot);
global DATA_LEN
warnings = 0;
min_Data_len=1000000;
if From_Mat %load matlab files
    FileList = dir(strcat(Directory,'\Matlab\*.mat'));
else        %load MAP files
    FileList = dir(strcat(Directory,'*.map'));
end
f=sprintf('run %s%s',Directory,'In_STN_Out'); %This calculates and the In and Out variables of the trajectory
eval(f);
j=1;
Data_len = []; %vector of time lengths of all the recordings

for i = 1:length(FileList)
    filename=FileList(i).name;
    filesizeM=(FileList(i).bytes)/(1024)^2;  
    %extract depth of measurement in relation to the target (zero) - microns
    Current_Depth=str2num(filename(1:length(filename)-4)); %electr. depth from STN target (remove file ext.)
    %(The depth parameter is the same for both Electrodes)

    if abs(Current_Depth)<15000 && (filesizeM<20)
    %If larger then ~20MB not an appropriate file - Ignored
    %If a few files are at depth 999 they are named: 999.MAP 999001.MAP 999002.MAP etc.
    %I have ignored these files for the same reason as large files
        
    if ~From_Mat  %reads 2 electrodes' Data, Size and Info from MAP file
        fullpathfilename = strcat(Directory,filename);
        [Data1,Data2,Info,n] = getE1_E2(fullpathfilename); 
    else
        fullpathfilename = strcat(Directory,'Matlab\',filename);
        load(fullpathfilename);  %reads 2 electrodes' Data, Size and Info from MAT file
    end
    %extract sample rate from file Info 
        SampleFreq(1)=Info(1).SampleRate;
        SampleFreq(2)=Info(2).SampleRate;

    %Calculate Standard Deviation
        if ismember(1,channel) %If Electrode 1 chosen
            SD_full(j,1)=std(Data1,1);
            DATA_LEN(length(DATA_LEN)+1)=length(Data1)/SampleFreq(1);
            if size(Data1)/SampleFreq(1)<1
                recording_length=length(Data1)/SampleFreq(1);
                out_length = sprintf('\nlength:\t%f \t at depth:\t%f',recording_length,Current_Depth);
                display(strcat('ERROR, recording length shorter than 1s. ',out_length));
            end
        end
        if ismember(2,channel) %If Electrode 2 chosen
            SD_full(j,2)=std(Data2,1);
            DATA_LEN(length(DATA_LEN)+1)=length(Data1)/SampleFreq(1);
            if size(Data2)/SampleFreq(2)<1
                recording_length=length(Data2)/SampleFreq(2);
                out_length = sprintf('\nlength:\t%f \t at depth:\t%f',recording_length,Current_Depth);
                display(strcat('ERROR, recording length shorter than 1s. ',out_length));
            end
        end

    %add depth to vector
        Elec_Depth(j)=Current_Depth;       
        j=j+1;
    elseif warnings ==1;
        disp(strcat('WARNING: file # ',num2str(i),'. The file :',filename,' was not opened. Size: ',num2str(filesizeM),'Mb'))
    end
end
TotalFiles = j-1;
clear NSD NSD_av NSD_var NSD_diff STN_step STN_len;
[baseSD,NSD,NSD_av,NSD_var,NSD_diff,STN_step,STN_len]=sd_sort_plot(Elec_Depth,SD_full,In,Out,strcat('Pallidotomy: ',Pallidotomy,' - ',Directory(13:length(Directory))),channel,Pallidotomy,plot_all,sort_plot);
% if channel ==1
%     NSD_av=[NSD_av 0];
%     NSD_var=[NSD_var 0];
%     NSD_diff=[NSD_diff 0];
%     STN_step=[STN_step 0];
%     STN_len=[STN_len 0];
%     baseSD =[baseSD 0];%This was added in at a later stage b/c of freq. analysis
% end
if channel ==2 %it is assumed here that only 1 channel is used. So the output is a single value  
    NSD_av=NSD_av(2);
    NSD_var=NSD_var(2);
    NSD_diff=NSD_diff(2);
    STN_step=STN_step(2);
    STN_len=STN_len(2);
    baseSD = baseSD(2);
end