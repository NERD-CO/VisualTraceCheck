function [PSD,PSD_low,PSD_high,Fs,Av_Data_len] = plotAllPSD(Directory,electrode,Pallidotomy,f_resolution,traj_no,nf);
%input directory name eg: 'D:\DBS_human\STN_regular\2005_03_24\R_hem_traj_2\'
%Plots MAP files 
if nargin<2
    electrode = 1;
end
%PARAMETERS
freq_normalize_range=[55 95]; %range to be used to normalize the PSD for each recording
plot_all = 0; %PLOTS EACH STEP
cutoff_freq = [1/3 60];
count=0;count_low=0;count_high=0;
f=sprintf('run %s%s',Directory,'In_STN_Out'); %This calculates and the In and Out variables of the trajectory
eval(f);
load('av_values.mat')
PSD(1:nf * f_resolution)=0; %average PSD (across all depths)
PSD_high(1:nf * f_resolution)=0; %average PSD for depths that RMS values are below the average
PSD_low(1:nf * f_resolution)=0; %average PSD for depths that RMS values are above the average
switch (Pallidotomy)
    case 'None'
        av=NSD_av_none(traj_no)*baseSD_none(traj_no); %normalized average multiplied by baseline gives real average
    case {'Ipsilateral','Bilateral'}
        av=NSD_av_ipsi(traj_no)*baseSD_ipsi(traj_no);
    case 'Contralateral'
        av=NSD_av_contra(traj_no)*baseSD_contra(traj_no);
end                                      
warnings = 0;
From_Mat =1;
if From_Mat %load matlab files
    FileList = dir(strcat(Directory,'\Matlab\*.mat'));
else        %load MAP files
    FileList = dir(strcat(Directory,'*.map'));
end
for i = 1:length(FileList)
    filename=FileList(i).name;
    filesizeM=(FileList(i).bytes)/(1024)^2;  
    fullpathfilename = strcat(Directory,filename);
    %extract depth of measurement in relation to the target (zero) - microns
    Current_Depth=str2num(filename(1:length(filename)-4)); %electr. depth from STN target (remove file ext.)
    %(The depth parameter is the same for both Electrodes)
    if (filesizeM<20) && abs(Current_Depth)<15000
    %If larger then ~20MB not an appropriate file - Ignored
    %If a few files are at depth 999 they are named: 999.MAP 999001.MAP 999002.MAP etc.
    %reads 2 electrodes' Data, Size and Info from MAP file
        if ~From_Mat  %reads 2 electrodes' Data, Size and Info from MAP file
            fullpathfilename = strcat(Directory,filename);
            [Data1,Data2,Info,n] = getE1_E2(fullpathfilename); 
        else
            fullpathfilename = strcat(Directory,'Matlab\',filename);
            load(fullpathfilename);  %reads 2 electrodes' Data, Size and Info from MAT file
        end
        
        noverlap=[];
        if ismember(1,electrode) && (Current_Depth > Out(1)) && (Current_Depth <= In(1)) %If Electrode 1 chosen and file is within STN
            Fs(i)=Info(1).SampleRate;
            Data_len(i)=length(Data1)/Fs(i);
            %[Data1_RMS,Fs1_RMS] = rms_downsample(Data1,10,1,Fs(i));
            Data1_RMS = abs(Data1);Fs1_RMS=Fs(i); %called RMS to keep name, but it is really rectified
            Data1_RMS_mean0=Data1_RMS-mean(Data1_RMS);  
            window_size = round(Fs1_RMS);%window for FFT is 1s long   *******WINDOW CHARACTERISTICS - DONT FORGET ELEC2!!!
            window=window_size;%dpss(window_size,4,1);
            nfft = f_resolution * round(Fs1_RMS); %to give resolution of 1/3 Hz
            [P1,w]=pwelch(Data1_RMS_mean0,window,noverlap,nfft,Fs1_RMS);
            %normalize PSD by tail (i.e. as defined in freq_normalize_range)
            P1=P1/mean(P1(f_resolution*freq_normalize_range(1):f_resolution*freq_normalize_range(2)));
            if plot_all == 1;
            %This section plots the origninal Data, the processed Data and the frequency
                figure;
                subplot(3,1,1);x=[1/Fs(i):1/Fs(i):length(Data1)/Fs(i)];
                plot(x,Data1);title(strcat('Original Data, sampled F =',num2str(Fs(i))));xlabel('seconds'); %for testing !!!
                subplot(3,1,2);x=[1/Fs1_RMS:1/Fs1_RMS:length(Data1_RMS)/Fs1_RMS];
                plot(x,Data1_RMS_mean0);title('Processed Data (mean 0)');xlabel('seconds');
                subplot(3,1,3);
                plot(w(1:nf * f_resolution),P1(1:nf * f_resolution));title('Frequency');xlabel('Hz');
                xlim(cutoff_freq);
            end
            PSD(1:nf * f_resolution) = PSD(1:nf * f_resolution)+P1(1:nf * f_resolution)';
            count=count+1;
            %This compares RMS values above or below the average (to prove MSD is due to oscillations)
            if std(Data1,1) < av %if RMS value is below the average
                PSD_low(1:nf * f_resolution) = PSD_low(1:nf * f_resolution)+P1(1:nf * f_resolution)';
                count_low=count_low+1;
            else
                PSD_high(1:nf * f_resolution) = PSD_high(1:nf * f_resolution)+P1(1:nf * f_resolution)';
                count_high=count_high+1;
            end
                
        end
        if ismember(2,electrode) && (Current_Depth > Out(2)) && (Current_Depth <= In(2)) %If Electrode 2 chosen
            Fs(i)=Info(2).SampleRate;
            Data_len(i)=length(Data2)/Fs(i);
            %[Data2_RMS,Fs2_RMS] = rms_downsample(Data2,10,1,Fs(i));
            Data2_RMS = abs(Data2);Fs2_RMS=Fs(i);
            Data2_RMS_mean0=Data2_RMS-mean(Data2_RMS);
            window_size = round(Fs2_RMS);% window for FFT is 1s long ******WINDOW CHARACTERISTICS - DONT FORGET ELEC1!!!
            window=window_size;%dpss(window_size,4,1);
            nfft = f_resolution * round(Fs2_RMS); %to give resolution of 1/3 Hz
            [P2,w]=pwelch(Data2_RMS_mean0,window,noverlap,nfft,Fs2_RMS);
            %normalize PSD by tail (i.e. as defined in freq_normalize_range)
            P2=P2/mean(P2(f_resolution*freq_normalize_range(1):f_resolution*freq_normalize_range(2)));
            if plot_all == 1;
            %This section plots the origninal Data, the processed Data and the frequency
                figure;
                subplot(3,1,1);x=[1/Fs(i):1/Fs(i):length(Data2)/Fs(i)];
                plot(x,Data2);title(strcat('Original Data, sampled F =',num2str(Fs(i))));xlabel('seconds'); %for testing !!!
                subplot(3,1,2);x=[1/Fs2_RMS:1/Fs2_RMS:length(Data2_RMS)/Fs2_RMS];
                plot(x,Data2_RMS_mean0);title('Processed Data (mean 0)');xlabel('seconds');
                subplot(3,1,3);
                plot(w(1:nf * f_resolution),P2(1:nf * f_resolution));title('Frequency');xlabel('Hz');
                xlim(cutoff_freq);
            end
            PSD(1:nf * f_resolution) = PSD(1:nf * f_resolution)+P2(1:nf * f_resolution)';
            count=count+1;
            %to compare RMS values above or below the average (to prove MSD is due to oscillations)
            if std(Data2,1) < av %if RMS value is below the average
                PSD_low(1:nf * f_resolution) = PSD_low(1:nf * f_resolution)+P2(1:nf * f_resolution)';
                count_low=count_low+1;
            else
                PSD_high(1:nf * f_resolution) = PSD_high(1:nf * f_resolution)+P2(1:nf * f_resolution)';
                count_high=count_high+1;
            end
        end
    elseif warnings ==1;
        disp(strcat('WARNING: file # ',num2str(i),'. The file :',filename,' was not opened. Size: ',num2str(filesizeM),'Mb'))
    end
end
PSD=PSD/count; %find the average PSD for the STN (average is needed since STNs may have a different number of recordings)
PSD_low=PSD_low/count_low;
PSD_high=PSD_high/count_high;
Fs=mean(Fs(Fs~=0));  %Because some values will be zero if recording is not within STN
Av_Data_len=mean(Data_len(Data_len~=0));

%This plots the mean PSD for the trajectory
% figure;
% x=(1/f_resolution:1/f_resolution:nf);
% plot(x,mylog(PSD));title(sprintf('mean'));xlabel('Hz');xlim(cutoff_freq);

