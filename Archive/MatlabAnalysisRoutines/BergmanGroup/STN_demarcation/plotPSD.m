function [P1_STN,PSD1,PSD_top1,PSD_bottom1,PSD_prior1,P2_STN,PSD2,PSD_top2,PSD_bottom2,PSD_prior2,h_RMS,h_PSD] = plotPSD(traj_Directory,electrode,PLOT,MARGIN_PSD)%the output variables & electrode are loaded from the file
%P* - matrix depth vs PSD (to calculate mean STN. PSD* - vector mean PSD
global logscale; %(0 or 1) plots PSD & freq. logscale
global mean_PSD_resolution; %In-Out resolution for mean spectrogram
global DO_GONIOM_PSD;
global goniom_cutoff;
global ONLY_STN; 
global cutoff_freq;
global plot_freq;
global PLOT_forpub;
global USE_MAT;
if nargin < 1, disp('Useage: plotPSD(traj_Directory,*electrode=[1 2],*PLOT=1,*MARGIN_PSD=1)'); return, end
if nargin < 2, electrode=[1 2]; end
if nargin < 3, PLOT=1; end
if nargin < 4, MARGIN_PSD=1; end
if traj_Directory(end) ~= '\', traj_Directory = strcat(traj_Directory,'\'); end
[In,Out,soma2lim,InSNr,OutSNr]=load_InOut(traj_Directory);
ResultsFile=sprintf('PSD_summary_%uHz.mat',cutoff_freq(2)); load_Results; %to load f_resolution
%cutoff_freq = plot_freq; %%%%OVERRIDE the FILE (ofcourse must be in the limits of what was saved)
zero_the_PSD(1:cutoff_freq(2) * f_resolution+1)=0;
PSD1=zero_the_PSD;PSD_top1=zero_the_PSD;PSD_bottom1=zero_the_PSD;PSD_prior1=zero_the_PSD;%mean PSD across depths (vector)
PSD2=zero_the_PSD;PSD_top2=zero_the_PSD;PSD_bottom2=zero_the_PSD;PSD_prior2=zero_the_PSD;
P1_STN([1:mean_PSD_resolution],1:cutoff_freq(2) * f_resolution+1)=NaN;P2_STN=P1_STN;%PSD per depth (matrix)
F=plot_freq(1):1/f_resolution:plot_freq(2); %frequency values for 'depth-spectrogram'
if PLOT==1 %PLOT RMS
    figure;set(gcf,'color','w');
    plotRMS(traj_Directory,electrode,0);
    if PLOT_forpub
        Pos=get(gca,'Position'); A_Pos = [(Pos(1)-0.1) (Pos(2)+Pos(4)) 0.07 0.07];
        ann_A = annotation(gcf,'textbox','Position',A_Pos,'LineStyle','none','FitHeightToText','off','FontSize',18,'FontWeight','bold','String',{'A'});
    end
end
for i=1:length(electrode)
    elec=electrode(i);
    ResultsFile=sprintf('PSD%u_%uHz.mat',elec,cutoff_freq(2)); load_Results;
    %Determine PSD within STN, and NORMALIZE depth [1:100] - 1=Out, 100=In
    if ~isnan(In(elec)) & ~isnan(Out(elec)) %check that STN has In and Out
        eval(sprintf('P_STN=P%u(depth%u > Out(elec) & depth%u <= In(elec) ,:);',elec,elec,elec));%PSD matrix WITHIN the STN
        eval(sprintf('depth_STN=depth%u(depth%u > Out(elec) & depth%u <= In(elec));',elec,elec,elec));%depth matrix WITHIN the STN
        xi=[min(depth_STN):(max(depth_STN)-min(depth_STN))/(mean_PSD_resolution-1):max(depth_STN)]; %normalize the depth
        eval(sprintf('P%u_STN = interp1(depth_STN,P_STN,xi,''nearest'');',elec));% interpolate to normalized depth
    end
    if PLOT==1 %PLOT MEAN/MAX BETA on RMS graph
        h_RMS(i)=subplot(2,length(electrode),i);hold on;
        eval(sprintf('plot(depth%u/1000,smooth_freq(beta%u,2/3,3),''c'');',elec,elec));
        eval(sprintf('plot(depth%u/1000,smooth_freq(beta_max%u,2/3,3),''m'');',elec,elec)); %can also use maxmean
        %eval(sprintf('plot(depth%u/1000,smooth_freq(gamma%u,2/3,3),''c'');',elec,elec)); %can also use highgamma
        Pos=get(gca,'Position'); Pos(3)=Pos(3)*0.9;set(gca,'Position',Pos);%need to shift graph for MarginPSD
        %PLOT SPECTROGRAM
        h_PSD(i)=subplot(2,length(electrode),length(electrode)+i);
        if PLOT_forpub
            Pos=get(gca,'Position'); B_Pos = [(Pos(1)-0.1) (Pos(2)+Pos(4)) 0.07 0.07];
            ann_B = annotation(gcf,'textbox','Position',B_Pos,'LineStyle','none','FitHeightToText','off','FontSize',18,'FontWeight','bold','String',{'B'});
        end
        eval(sprintf('plotSpectrogram(P%u(:,plot_freq(1)*f_resolution+1:plot_freq(2)*f_resolution+1),depth%u,F,1);',elec,elec)); hold on;
        if i<2, xlabel('Freq. (Hz)'); end
        if PLOT_forpub header =('PSD'); else header=sprintf('Date: %s - %s - E%u',date_of_surgery,traj,elec); end
        title(strrep(header,'_','-'));
        if logscale ==1, set(gca,'XScale','log'); end %Freq. PSD (Z axis) ALREADY LOGGED in the plotSpectrogram function!
        if ~isnan(InSNr(elec)) & ~ONLY_STN, plot3([min(F) max(F)],[InSNr(elec) InSNr(elec)]./1000,20*[1 1],'k--','LineWidth',2); end
        if ~isnan(OutSNr(elec)) & ~ONLY_STN, plot3([min(F) max(F)],[OutSNr(elec) OutSNr(elec)]./1000,20*[1 1],'k--','LineWidth',2); end
        Pos=get(gca,'Position'); Pos(3)=Pos(3)*0.9;set(gca,'Position',Pos);
        if ~isnan(In(elec))
            if ONLY_STN & ~isnan(Out(elec))
                ylim([Out(elec) In(elec)]./1000);
            else %plot STN borders
                plot3([min(F) max(F)],[In(elec) In(elec)]./1000,20*[1 1],'k','LineWidth',2);
                if ~isnan(Out(elec)), plot3([min(F) max(F)],[Out(elec) Out(elec)]./1000,20*[1 1],'k','LineWidth',2); end
            end
            if ~isnan(soma2lim(elec)), plot3([min(F) max(F)],[soma2lim(elec) soma2lim(elec)]./1000,20*[1 1],'k-.','LineWidth',2); end %plot soma2limbic border
            if MARGIN_PSD %plot margin PSDs
                subplot('Position',[Pos(1)+Pos(3) Pos(2) Pos(3)/6 Pos(4)]); hold on;
                eval(sprintf('plot(F,PSD%u(plot_freq(1)* f_resolution+1:plot_freq(2) * f_resolution+1));',elec));
                eval(sprintf('plot(F,PSD_top%u(plot_freq(1)* f_resolution+1:plot_freq(2) * f_resolution+1),''r'');',elec));
                eval(sprintf('plot(F,PSD_bottom%u(plot_freq(1)* f_resolution+1:plot_freq(2) * f_resolution+1),''g'');',elec));
                view(90,-90); xlim(plot_freq); set(gca,'ytick',[]);set(gca,'xtick',[]); ylim([0.7 4.5]);
                if logscale ==1
                    set(gca,'XScale','log'); %Freq.
                    set(gca,'YScale','log'); %PSD
                end
            end
        end
    end
end

if PLOT & DO_GONIOM_PSD & size(dir(strcat(traj_Directory,'PSD_gon.mat')),1)~=0 %file exists
    ResultsFile=sprintf('PSD_gon.mat'); load_Results;
    figure;set(gcf,'color','w');
    F=goniom_cutoff(1):1/f_resolution:goniom_cutoff(2); 
    subplot(2,1,1); plotSpectrogram(P_goniom_wrist(:,goniom_cutoff(1)*f_resolution+1:goniom_cutoff(2)*f_resolution+1),depth_gon,F,0);%don't smooth?
    if PLOT_forpub header =('wrist'); else header=sprintf('Date: %s - %s. wrist goniometer',date_of_surgery,traj); end
    title(strrep(header,'_','-')); xlabel('Freq. (Hz)');
    if logscale ==1, set(gca,'XScale','log'); end %Freq. PSD (Z axis) ALREADY LOGGED in the plotSpectrogram function!
    subplot(2,1,2); plotSpectrogram(P_goniom_elbow(:,goniom_cutoff(1)*f_resolution+1:goniom_cutoff(2)*f_resolution+1),depth_gon,F,0);
    if PLOT_forpub header =('elbow'); else header=sprintf('Date: %s - %s. elbow goniometer',date_of_surgery,traj); end 
    title(strrep(header,'_','-')); xlabel('Freq. (Hz)');
    if logscale ==1, set(gca,'XScale','log'); end %Freq. PSD (Z axis) ALREADY LOGGED in the plotSpectrogram function!
end

%remove a PSD artifact (around 177.5Hz there is a peak in the Pre-STN PSD, of Elec2) - Can be done on ALL in "calc_PSD.m" (for averaging) and "PSDsmoothlog.m"
%If plotting [3 400] freq. need to do this on ALL trajs (b/c for the patients before 14/1/2008 I see the artifact at 355Hz.
%if strcmp(traj_Directory(findstr(traj_Directory,'20'):end),'2007_11_28_PD_STN\traj1\')
    bad_idx=177.5 * f_resolution; idx=[1:length(PSD_prior2)];
    if sum(PSD_prior2)~=0 & ~isnan(sum(PSD_prior2)), PSD_prior2(idx> 10*f_resolution & ((mod(idx,bad_idx)< 2.5*f_resolution) | (mod(idx,bad_idx)>bad_idx-2.5*f_resolution)))=1; end
    if sum(PSD_prior1)~=0 & ~isnan(sum(PSD_prior1)), PSD_prior1(idx> 10*f_resolution & ((mod(idx,bad_idx)< 2.5*f_resolution) | (mod(idx,bad_idx)>bad_idx-2.5*f_resolution)))=1; end
%end


