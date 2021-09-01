function plotRMS(traj_Directory,electrode,RMS_only);
%input traj_Directory name eg: 'D:\DBS_human\STN_regular\2005_03_24\R_hem_traj_2\' (If 'In_STN_Out.m' in  traj_Directory,  In/Out are also plotted)
%This is used by both plot_RMS and plot_PSD!
global WARNINGS Num_forNorm PLOT_forpub USE_MAT
if nargin==0
    disp('Useage: plotRMS(traj_Directory,*electrode=[1 2],*RMS_only=1)');%currently electrode is loaded from the file
    return
end
if nargin<2, electrode=[1 2]; end
if nargin<3, RMS_only=1; end
if traj_Directory(end) ~= '\', traj_Directory = strcat(traj_Directory,'\'); end
if RMS_only; %i.e. only RMS plot without PSD
    n_col=1; n_row=length(electrode);
    figure; set(gcf,'color','w');
else, n_col=length(electrode); n_row=2; end
[In,Out,soma2lim,InSNr,OutSNr]=load_InOut(traj_Directory);
set_ylim = 3; %sets the ylim of the plots by: 'max', 'mean' or a value (e.g. 3)
for i=1:length(electrode)
    elec=electrode(i);
    ResultsFile=sprintf('RMS%u.mat',elec); load_Results;
    eval(sprintf('RMS=RMS%u;',elec)); eval(sprintf('Elec_Depth=Elec_Depth%u;',elec));
    RMS_handle(i)=subplot(n_row,n_col,i);
    baseSD(elec)=mean(RMS((end-Num_forNorm+1):end));%baseline estimate. if Num_forNorm==0 use RMS till STN-entry (if In defined)
    if ~(isnan(In(elec)) || isnan(Out(elec)))
        In_index=min(find(Elec_Depth>In(elec))); Out_index=max(find(Elec_Depth<=Out(elec)));
        if ~Num_forNorm baseSD(elec)=mean(RMS(In_index:length(Elec_Depth))); end %find baseline based on In and Out
        meanSD(elec)=mean(RMS(Out_index+1:In_index-1)/baseSD(elec));
    end
    h_bar=bar(Elec_Depth/1000,RMS/baseSD(elec),'k'); 
    %set(h_bar,'FaceColor',[0 0 1],'EdgeColor','none');
    ymax(elec)=max(RMS/baseSD(elec));
    hold on; %plot IN and OUT
    if ~isnan(In(elec)), plot([In(elec) In(elec)]./1000,[max(RMS)/baseSD(elec) 0],'r','LineWidth',2); end
    if ~isnan(soma2lim(elec)), plot([soma2lim(elec) soma2lim(elec)]./1000,[max(RMS)/baseSD(elec) 0],'r-.','LineWidth',2); end
    if ~isnan(Out(elec)), plot([Out(elec) Out(elec)]./1000,[max(RMS)/baseSD(elec) 0],'r','LineWidth',2);end
    if ~isnan(InSNr(elec)), plot([InSNr(elec) InSNr(elec)]./1000,[max(RMS)/baseSD(elec) 0],'r--','LineWidth',2);end
    if ~isnan(OutSNr(elec)), plot([OutSNr(elec) OutSNr(elec)]./1000,[max(RMS)/baseSD(elec) 0],'r--','LineWidth',2);end
    if PLOT_forpub header =('Example trajectory'); else header=sprintf('Date: %s - %s - E%u',date_of_surgery,traj,elec); end
    title(strrep(header,'_','-')); xlabel('EDT (mm)')
    if i<2, ylabel('NRMS'); end
    axis tight; set(gca,'XDir','reverse');%this reverses the EDT (x) axis to represent timecourse of the surgery
end
if strcmp(set_ylim,'max')%set ylim for both plots to be the same
    yaxis_lim=max(ymax(electrode));
elseif strcmp(set_ylim,'mean')
    if sum(isnan([In(electrode) Out(electrode)]))~=0
        if WARNINGS,disp('WARNING: In/Out not defined to use mean for ylimit. Ylim set to 3');end
        yaxis_lim=3;
    else,  yaxis_lim=max(meanSD(electrode))*1.5; end
else, yaxis_lim=set_ylim; end
set(findobj(RMS_handle,'Type','axes'),'Ylim',[0 yaxis_lim]); 
if PLOT_forpub factor=0.28; else, factor=0.4; end
set(gcf,'Units','normalized'); set(gcf,'Position',[0.1 0.05 factor*n_col factor*n_row]);%set figure position and size (to get good proportion)

