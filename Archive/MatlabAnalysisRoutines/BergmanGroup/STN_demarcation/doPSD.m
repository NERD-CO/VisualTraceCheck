function doPSD(traj_Directory,electrode,AO_MATformat);
global WARNINGS DO_GONIOM_PSD goniom_cutoff ONLY_STN f_resolution cutoff_freq VERBOSE AUTO_STAB
%INPUTS AND PARAMETERS%
%%%%%%%%%%%%%%%%%%%%%%%
beta_range = [13 30]; gamma_range = [31 47.5]; highgamma_range = [57.5 97.5];
if nargin<1, disp('Useage: doPSD(traj_Directory,*electrode=[1 2],*AO_MATformat=0)'); return, end
if nargin<2, electrode=[1 2]; end
if nargin<3
    if size(dir(strcat(traj_Directory,'\AOMatlab\*.mat')),1)>10, AO_MATformat=1; %if there are Mat files use them
    else, AO_MATformat=0; end
end
if traj_Directory(end) ~= '\', traj_Directory = strcat(traj_Directory,'\'); end
joint_name{1}='wrist';joint_name{2}='elbow';
PSD1(1:cutoff_freq(2) * f_resolution+1)=0;PSD2(1:cutoff_freq(2) * f_resolution+1)=0; %average PSD (across all depths). +1 b/c w[1]=0Hz
PSD_top1(1:cutoff_freq(2) * f_resolution+1)=0;PSD_top2(1:cutoff_freq(2) * f_resolution+1)=0; %average PSD across 1st half of the STN
PSD_bottom1(1:cutoff_freq(2) * f_resolution+1)=0;PSD_bottom2(1:cutoff_freq(2) * f_resolution+1)=0; %average PSD across 2nd half of the STN
PSD_prior1(1:cutoff_freq(2) * f_resolution+1)=0;PSD_prior2(1:cutoff_freq(2) * f_resolution+1)=0; %average PSD before entering the STN (white matter)
count=[0 0];count_E=[0 0];count_top=[0 0];count_bottom=[0 0]; count_prior=[0 0];
[In,Out,soma2lim,InSNr,OutSNr]=load_InOut(traj_Directory);
b_idx=[(beta_range(1)*f_resolution+1):(beta_range(2)*f_resolution+1)];
g_idx=[(gamma_range(1)*f_resolution+1):(gamma_range(2)*f_resolution+1)];
h_idx=[(highgamma_range(1)*f_resolution+1):(highgamma_range(2)*f_resolution+1)];
if (isnan(In(1)) | isnan(Out(1))) & ismember(1,electrode) & WARNINGS, disp('WARNING: elec 1 doesn''t have In/Out defined.'); end
if (isnan(In(2)) | isnan(Out(2))) & ismember(2,electrode) & WARNINGS, disp('WARNING: elec 2 doesn''t have In/Out defined.'); end
if AO_MATformat, FileList = dir(strcat(traj_Directory,'\AOMatlab\*.mat'));%load MAT files
else, FileList = dir(strcat(traj_Directory,'*.map')); end %load MAP files

%PSD LOOP%
%%%%%%%%%%
if VERBOSE, disp(traj_Directory); end
for i = 1:length(FileList)
    filename=FileList(i).name; filesizeM=(FileList(i).bytes)/(1024)^2;
    if VERBOSE, disp(filename); end
    Current_Depth=str2num(filename(1:length(filename)-4)); %electr. depth from STN target (remove file ext.)
    clear PSD_START* PSD_END*;
    if (filesizeM<80) & abs(Current_Depth)<20000 %If a few files are at depth 999 they are named: 999.MAP 999001.MAP 999002.MAP etc.
        skip_trace=[0 0];
        if ~AO_MATformat  %reads 2 electrodes' Data, Size and Info from MAP file
            fullpathfilename = strcat(traj_Directory,filename);
            [Data1,Data2,Data3,Data4,Info,n] = getE1_E2_gon(fullpathfilename); % Data3/4 are the wrist/elbow goniometers
            if AUTO_STAB, [Data1,Data2,skip_trace]=check_stab(Data1,Data2,Info); end %excl trace if longest stable section <1s
            if WARNINGS & any(skip_trace), disp(strcat('WARNING: file # ',num2str(i),' name: ',filename,' elec(s):',num2str(find(skip_trace)),' excluded. Longest stable section was <1s.'));end
        else
            fullpathfilename = strcat(traj_Directory,'AOMatlab\',filename); load(fullpathfilename);  %reads Data, Size and Info from MAT file
            for j=1:length(electrode)
                elec=electrode(j);
                Info(elec).SampleRate = eval(sprintf('CElectrode%u_KHz*1000;',elec));
                if exist(sprintf('PSD_START%u',elec)) & exist(sprintf('PSD_END%u',elec))
                    PSD_START=eval(sprintf('PSD_START%u',elec));PSD_END=eval(sprintf('PSD_END%u',elec));
                    if (PSD_START*PSD_END)>0
                        eval(sprintf('Data%u = CElectrode%u(PSD_START:min(PSD_END,end));',elec,elec));
                    else, skip_trace(elec)=1; end
                else, eval(sprintf('Data%u = CElectrode%u;',elec,elec)); end
            end
            if (exist('C1_AI015') && exist('C1_AI016'))
                Data3=C1_AI015; Data4=C1_AI016;
                Info(3).SampleRate=C1_AI015_KHz*1000; Info(4).SampleRate=C1_AI016_KHz*1000;
            else, Data3=NaN; Data4=NaN; end
        end
        if DO_GONIOM_PSD & length(Data3)>1 & length(Data4)>1 %i.e. not NaN
            goniom{1}=Data3(min(find(Data3)):max(find(Data3))); 
            goniom{2}=Data4(min(find(Data4)):max(find(Data4))); 
            P_goniom_wrist(i,:)=calc_PSD(goniom{1},Info(3).SampleRate,goniom_cutoff); %this rectifies etc! - change?
            P_goniom_elbow(i,:)=calc_PSD(goniom{2},Info(4).SampleRate,goniom_cutoff);
            depth_gon(i)=Current_Depth;
        else, P_goniom_wrist=NaN;P_goniom_elbow=NaN;depth_gon=NaN; end %so that save doesn't have errors
        for j=1:length(electrode)
            elec=electrode(j);
            STN_length=In(elec)-Out(elec);
            if ~skip_trace(elec) & (~ONLY_STN | ((Current_Depth > Out(elec) | isnan(Out(elec))) && (Current_Depth <= In(elec)))) %If do PSD on whole traj OR file is within STN
                count_E(elec) = count_E(elec)+1;
                eval(sprintf('Fs%u(count_E(elec)) = Info(elec).SampleRate;',elec));
                eval(sprintf('Data_len%u(count_E(elec)) = length(Data%u)/Fs%u(count_E(elec));',elec,elec,elec));
                eval(sprintf('P%u(count_E(elec),:)=calc_PSD(Data%u,Fs%u(count_E(elec)),cutoff_freq);',elec,elec,elec));
                eval(sprintf('depth%u(count_E(elec))=Current_Depth;',elec));
                eval(sprintf('beta%u(count_E(elec))=mean(P%u(count_E(elec),b_idx),2);',elec,elec));
                eval(sprintf('[beta_max%u(count_E(elec)) I]=max(smooth_freq(P%u(count_E(elec),b_idx),1));',elec,elec));
                eval(sprintf('beta_maxmean%u(count_E(elec))=mean(P%u(count_E(elec),b_idx(I)-f_resolution*2:b_idx(I)+f_resolution*2),2);',elec,elec));%mean around 2Hz of max
                eval(sprintf('gamma%u(count_E(elec))=mean(P%u(count_E(elec),g_idx),2);highgamma%u(count_E(elec))=mean(P%u(count_E(elec),g_idx),2);',elec,elec,elec,elec));
                if Current_Depth > In(elec) %white matter
                    count_prior(elec)=count_prior(elec)+1;
                    eval(sprintf('PSD_prior%u = PSD_prior%u+P%u(count_E(elec),:);',elec,elec,elec));
                elseif (Current_Depth > Out(elec) | isnan(Out(elec))) & (Current_Depth <= In(elec)) % in the STN
                    count(elec)=count(elec)+1;
                    eval(sprintf('PSD%u = PSD%u+P%u(count_E(elec),:);',elec,elec,elec));
                    if isnan(soma2lim(elec)), soma2lim_border = Out(elec)+STN_length/2; % TOP part of the STN
                    else ,soma2lim_border = soma2lim(elec); end
                    if Current_Depth > soma2lim_border  % TOP part of the STN
                        count_top(elec)=count_top(elec)+1;
                        eval(sprintf('PSD_top%u = PSD_top%u+P%u(count_E(elec),:);',elec,elec,elec));
                    elseif Current_Depth < soma2lim_border % if soma2lim=NaN and Out=NaN top/bottom =0.
                        count_bottom(elec)=count_bottom(elec)+1;
                        eval(sprintf('PSD_bottom%u = PSD_bottom%u+P%u(count_E(elec),:);',elec,elec,elec));
                    end
                end
            end
        end
    elseif WARNINGS, disp(strcat('WARNING: file # ',num2str(i),'. The file :',filename,' was not opened. Size: ',num2str(filesizeM),'Mb')); end
end

% SAVE RESULTS %
%%%%%%%%%%%%%%%%
if AO_MATformat, save_dir=strcat(traj_Directory,'AOMatlab\');
else save_dir=traj_Directory; end
for i=1:length(electrode)
    elec=electrode(i);
    eval(sprintf('temp=sortrows([depth%u'' beta%u'' beta_max%u'' beta_maxmean%u'' gamma%u'' highgamma%u'' P%u]);',elec,elec,elec,elec,elec,elec,elec));%sort in order of depth
    eval(sprintf('depth%u=temp(:,1);',elec)); eval(sprintf('beta%u=temp(:,2);',elec));
    eval(sprintf('beta_max%u=temp(:,3);',elec)); eval(sprintf('beta_maxmean%u=temp(:,4);',elec));
    eval(sprintf('gamma%u=temp(:,5);',elec)); eval(sprintf('highgamma%u=temp(:,6);',elec));
    eval(sprintf('P%u=temp(:,7:end);',elec));
    eval(sprintf('Fs%u=median(Fs%u);',elec,elec));%assuming they are all the same!
    eval(sprintf('Av_Data_len%u=mean(Data_len%u);',elec,elec));
    eval(sprintf('PSD_prior%u = PSD_prior%u/count_prior(%u);',elec,elec,elec));
    eval(sprintf('PSD_top%u = PSD_top%u/count_top(%u);',elec,elec,elec));
    eval(sprintf('PSD_bottom%u = PSD_bottom%u/count_bottom(%u);',elec,elec,elec));
    eval(sprintf('PSD%u = PSD%u/count(%u);',elec,elec,elec));
    ResultsFile=sprintf('PSD%u_%uHz.mat',elec,cutoff_freq(2));
    save(strcat(save_dir,ResultsFile),'-v6',sprintf('P%u',elec),sprintf('depth%u',elec),sprintf('Fs%u',elec),sprintf('Av_Data_len%u',elec)...
        ,sprintf('PSD%u',elec),sprintf('PSD_top%u',elec),sprintf('PSD_prior%u',elec),sprintf('PSD_bottom%u',elec),sprintf('beta%u',elec)...
        ,sprintf('beta_max%u',elec),sprintf('beta_maxmean%u',elec),sprintf('gamma%u',elec),sprintf('highgamma%u',elec));
end
ResultsFile=sprintf('PSD_summary_%uHz.mat',cutoff_freq(2));
save(strcat(save_dir,ResultsFile),'-v6','f_resolution')
if DO_GONIOM_PSD & ~isnan(depth_gon)
    ResultsFile=sprintf('PSD_gon.mat');
    save(strcat(save_dir,ResultsFile),'-v6','P_goniom*','depth_gon');
end

