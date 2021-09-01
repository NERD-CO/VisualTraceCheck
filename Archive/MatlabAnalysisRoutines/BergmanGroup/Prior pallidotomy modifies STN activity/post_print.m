initialize_post
number_of_ipsis = 5;
no_plot=0;
%Print average time duration of all the recordings
header = sprintf('\n\nThe mean recording duration is: %.3f s\t\twith SD: %.3f s\n',mean_DATA_LEN,std_DATA_LEN);
disp(header);

%print averages and SD of:average, var, diff, step and len:
header = sprintf('\n\nIn STN\n\t\t\t\t\tIPSI(n=%u)\t\tCONTRA(n=%u)\t\tNONE(n=%u)',length(NSD_av_ipsi),length(NSD_av_contra),length(NSD_av_none));
out1 = sprintf('\nmean(NSD_avg):\t\t%f\t\t%f\t\t%f',av_NSD_av_ipsi,av_NSD_av_contra,av_NSD_av_none);
out2 = sprintf('\nstd(NSD_avg):\t\t%f\t\t%f\t\t%f',sd_NSD_av_ipsi,sd_NSD_av_contra,sd_NSD_av_none);
out3 = sprintf('\n\nmean(NSD_var):\t\t%f\t\t%f\t\t%f',av_NSD_var_ipsi,av_NSD_var_contra,av_NSD_var_none);
out4 = sprintf('\nstd(NSD_var):\t\t%f\t\t%f\t\t%f',sd_NSD_var_ipsi,sd_NSD_var_contra,sd_NSD_var_none);
out5 = sprintf('\n\nmean(NSD_diff):\t\t%f\t\t%f\t\t%f',av_NSD_diff_ipsi,av_NSD_diff_contra,av_NSD_diff_none);
out6 = sprintf('\nstd(NSD_diff):\t\t%f\t\t%f\t\t%f',sd_NSD_diff_ipsi,sd_NSD_diff_contra,sd_NSD_diff_none);
out7 = sprintf('\n\nmean(STN_step):\t\t%f\t\t%f\t\t%f',av_STN_step_ipsi,av_STN_step_contra,av_STN_step_none);
out8 = sprintf('\nstd(STN_step):\t\t%f\t\t%f\t\t%f',sd_STN_step_ipsi,sd_STN_step_contra,sd_STN_step_none);
out9 = sprintf('\n\nmean(STN_len):\t\t%f\t\t%f\t\t%f',av_STN_len_ipsi,av_STN_len_contra,av_STN_len_none);
out10 = sprintf('\nstd(STN_len):\t\t%f\t\t%f\t\t%f',sd_STN_len_ipsi,sd_STN_len_contra,sd_STN_len_none);
disp(strcat(header,out1,out2,out3,out4,out5,out6,out7,out8,out9,out10));

%need to be same length to plot matrix (Box) and do ANOVA
l=max([length(NSD_av_none),length(NSD_av_contra),length(NSD_av_ipsi)]);
NSD_av_none(length(NSD_av_none)+1:l)=NaN;     
NSD_av_contra(length(NSD_av_contra)+1:l)=NaN;
NSD_av_ipsi(length(NSD_av_ipsi)+1:l)=NaN;
l=max([length(NSD_var_none),length(NSD_var_contra),length(NSD_var_ipsi)]);
NSD_var_none(length(NSD_var_none)+1:l)=NaN;     
NSD_var_contra(length(NSD_var_contra)+1:l)=NaN;
NSD_var_ipsi(length(NSD_var_ipsi)+1:l)=NaN;
l=max([length(NSD_diff_none),length(NSD_diff_contra),length(NSD_diff_ipsi)]);
NSD_diff_none(length(NSD_diff_none)+1:l)=NaN;     
NSD_diff_contra(length(NSD_diff_contra)+1:l)=NaN;
NSD_diff_ipsi(length(NSD_diff_ipsi)+1:l)=NaN;
l=max([length(STN_step_none),length(STN_step_contra),length(STN_step_ipsi)]);
STN_step_none(length(STN_step_none)+1:l)=NaN;     
STN_step_contra(length(STN_step_contra)+1:l)=NaN;
STN_step_ipsi(length(STN_step_ipsi)+1:l)=NaN;
l=max([length(STN_len_none),length(STN_len_contra),length(STN_len_ipsi)]);
STN_len_none(length(STN_len_none)+1:l)=NaN;     
STN_len_contra(length(STN_len_contra)+1:l)=NaN;
STN_len_ipsi(length(STN_len_ipsi)+1:l)=NaN;

%one-way ANOVA
side=[{'none'},{'contra'},{'ipsi'}];
sprintf('\nANOVA analysis\n--------------\n1 - No pallidotomy\n2 - contralateral pallidotomy\n3 - ipsilateral pallidotomy\n')
[p_av,table_av,stat_av]=anova1([NSD_av_none,NSD_av_contra,NSD_av_ipsi],side,'off');
alpha = 0.05 %for multcompare
if p_av < 0.05 
    disp(strcat('The averages are significantly different, P= ',num2str(p_av)));
    c_av = multcompare(stat_av,'display','off','ctype','bonferroni','alpha',alpha)
end
[p_var,table_var,stat_var]=anova1([NSD_var_none,NSD_var_contra,NSD_var_ipsi],side,'off');
if p_var < 0.05
    disp(strcat('The variances are significantly different, P= ',num2str(p_var)));
    c_var = multcompare(stat_var,'display','off','ctype','bonferroni','alpha',alpha)
end
%MSD is logged for variance equalization
[p_diff,table_diff,stat_diff]=anova1(log([NSD_diff_none,NSD_diff_contra,NSD_diff_ipsi]),side,'off');
if p_diff < 0.05
    disp(strcat('The MSDs are significantly different, P= ',num2str(p_diff)));
    c_diff = multcompare(stat_diff,'display','off','ctype','bonferroni','alpha',alpha)
end
[p_step,table_step,stat_step]=anova1([STN_step_none,STN_step_contra,STN_step_ipsi],side,'off');
if p_step < 0.05
    disp(strcat('The step sizes are significantly different, P= ',num2str(p_step)));
    c_step = multcompare(stat_step,'display','off','ctype','bonferroni','alpha',alpha)
end
[p_len,table_len,stat_len]=anova1([STN_len_none,STN_len_contra,STN_len_ipsi],side,'off');
if p_len < 0.05
    disp(strcat('The STN lenghts are significantly different, P= ',num2str(p_len)));
    c_len = multcompare(stat_len,'display','off','ctype','bonferroni','alpha',alpha)
end

%Box Plots for the average, var and diff (for ipsi, contra and none)
figure;set(gcf,'color','w');
pos=get(gcf,'Position');
pos(4) = pos(4)*1.3; %resize to make room for error bars
pos(2) = 0.5*pos(2);
set(gcf,'Position',pos)

no_of_plots=3;
subplot(1,no_of_plots,1);
Xticks={'IL', 'CL', 'NP'};
maboxplot([NSD_av_ipsi NSD_av_contra NSD_av_none],Xticks,'Title','AVERAGE','colors','kkk')
set(gca,'PlotBoxAspectRatio',[1,no_of_plots,1])
ylabel('');
hold on; 
plot([1 2 3],[av_NSD_av_ipsi av_NSD_av_contra av_NSD_av_none],'--diamond','LineWidth',2); %changed from '--o'
subplot(1,no_of_plots,2);
maboxplot([NSD_var_ipsi NSD_var_contra NSD_var_none],Xticks,'Title','VARIANCE')
set(gca,'PlotBoxAspectRatio',[1,no_of_plots,1])
ylabel('');
hold on; 
plot([1 2 3],[av_NSD_var_ipsi av_NSD_var_contra av_NSD_var_none],'--diamond','LineWidth',2);
%MSD is logged for variance equalization
subplot(1,no_of_plots,no_of_plots);
maboxplot(log([NSD_diff_ipsi NSD_diff_contra NSD_diff_none]),Xticks,'Title','log(MSD)')
set(gca,'PlotBoxAspectRatio',[1,no_of_plots,1])
ylabel('');
hold on; 
plot([1 2 3],log([av_NSD_diff_ipsi av_NSD_diff_contra av_NSD_diff_none]),'--diamond','LineWidth',2);
set(findobj(gcf,'Type','axes'),'fontsize',14)
h=get(findobj(gcf,'Type','axes'),'Title');
set(cell2mat(h),'fontsize',14); %change titles fontsize to 14
%significance markers

% x=0.1850; % for 2 subplots
% dx=0.2218;
% y=0.108;
% text1 = [0.2643 0.02373 0.06786 0.09841];
% text2 = [0.7069 0.02373 0.06786 0.09841];
x=0.175; %for 3 subplots
dx=0.135;
y=0.128;
text1 = [0.2054 0.04252 0.06786 0.09841];
text2 = [0.7726 0.04583 0.06483 0.09286];
dy=0.0150;
offset=0.03;
annotation(gcf,'line',[x x+dx],[y y],'LineWidth',2);
annotation(gcf,'line',[x x],[y y+dy],'LineWidth',2);
annotation(gcf,'line',[x+dx x+dx],[y y+dy],'LineWidth',2);
annotation(gcf,'textbox','Position',text1,'LineStyle','none','FitHeightToText','off','FontSize',30,'String',{'*'},'HorizontalAlignment','center');
% x=0.63; % for 2 subplots
x=0.738; %for 3 subplots
annotation(gcf,'line',[x x+dx],[y y],'LineWidth',2);
annotation(gcf,'line',[x x],[y y+dy],'LineWidth',2);
annotation(gcf,'line',[x+dx x+dx],[y y+dy],'LineWidth',2);
annotation(gcf,'textbox','Position',text2,'LineStyle','none','FitHeightToText','off','FontSize',30,'String',{'*'},'HorizontalAlignment','center');

%% Create A,B,C for figure legend
% annotation(gcf,'textbox','Position',[0.08431 0.9067 0.06786 0.09841],'LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'A'},'HorizontalAlignment','center');
% annotation(gcf,'textbox','Position',[0.5079 0.8995 0.06786 0.09841],'LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'B'},'HorizontalAlignment','center');
annotation(gcf,'textbox','Position',[0.08431 0.9067 0.06786 0.09841],'LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'A'},'HorizontalAlignment','center');
annotation(gcf,'textbox','Position',[0.3793 0.9068 0.06786 0.09841],'LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'B'},'HorizontalAlignment','center');
annotation(gcf,'textbox','Position',[0.6686 0.9086 0.06786 0.09841],'LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'C'},'HorizontalAlignment','center');

%Box Plot for the "number_of_ipsis" unilateral pallidotomy patients 
ymin = 0.5;
ymax = 4;
whisker_length=3;
Xticks={'IL', 'CL'};
figure;set(gcf,'color','w');
subplot(1,number_of_ipsis,1);
l=max([length(NSD_ipsi1),length(NSD_contra1)]);
NSD_ipsi1(length(NSD_ipsi1)+1:l)=NaN;
NSD_contra1(length(NSD_contra1)+1:l)=NaN;%changed from patient A to Patient 1
maboxplot([NSD_ipsi1 NSD_contra1],Xticks,'notch','off','Title','Patient A','Whiskerlength',whisker_length) %'Patient Z.N.'
hold on; 
plot([1 2],[NSD_av_ipsi(1) NSD_av_contra(1)],'--diamond','LineWidth',2);
ylabel('NRMS in STN','fontsize',14);
ylim([ymin ymax]);
subplot(1,number_of_ipsis,2);
l=max([length(NSD_ipsi2),length(NSD_contra2)]);
NSD_ipsi2(length(NSD_ipsi2)+1:l)=NaN;
NSD_contra2(length(NSD_contra2)+1:l)=NaN;
maboxplot([NSD_ipsi2 NSD_contra2],Xticks,'Title','Patient B','Whiskerlength',whisker_length) %'Patient T.A.'

set(gca,'YTickLabel','')%this removes the yticks numbers
    
hold on; 
plot([1 2],[NSD_av_ipsi(2) NSD_av_contra(2)],'--diamond','LineWidth',2);
ylabel('');
ylim([ymin ymax]);
subplot(1,number_of_ipsis,3);
l=max([length(NSD_ipsi3),length(NSD_contra3)]);
NSD_ipsi3(length(NSD_ipsi3)+1:l)=NaN;
NSD_contra3(length(NSD_contra3)+1:l)=NaN;
maboxplot([NSD_ipsi3 NSD_contra3],Xticks,'Title','Patient C','Whiskerlength',whisker_length) %'Patient Z.L.'
set(gca,'YTickLabel','')%this removes the yticks numbers
hold on; 
plot([1 2],[NSD_av_ipsi(3) NSD_av_contra(3)],'--diamond','LineWidth',2); %change from '--o'
ylabel('');
ylim([ymin ymax]);
subplot(1,number_of_ipsis,4);
l=max([length(NSD_ipsi4),length(NSD_contra4)]);
NSD_ipsi4(length(NSD_ipsi4)+1:l)=NaN;
NSD_contra4(length(NSD_contra4)+1:l)=NaN;
maboxplot([NSD_ipsi4 NSD_contra4],Xticks,'Title','Patient D','Whiskerlength',whisker_length) %'Patient 
set(gca,'YTickLabel','')%this removes the yticks numbers
hold on; 
plot([1 2],[NSD_av_ipsi(4) NSD_av_contra(4)],'--diamond','LineWidth',2);
ylabel('');
ylim([ymin ymax]);
subplot(1,number_of_ipsis,5);
l=max([length(NSD_ipsi5),length(NSD_contra5)]);
NSD_ipsi5(length(NSD_ipsi5)+1:l)=NaN;
NSD_contra5(length(NSD_contra5)+1:l)=NaN;
maboxplot([NSD_ipsi5 NSD_contra5],Xticks,'Title','Patient E','Whiskerlength',whisker_length) %'Patient 
set(gca,'YTickLabel','')%this removes the yticks numbers
hold on; 
plot([1 2],[NSD_av_ipsi(5) NSD_av_contra(5)],'--diamond','LineWidth',2);
ylabel('');
ylim([ymin ymax]);

set(findobj(gcf,'Type','axes'),'fontsize',14)
h=get(findobj(gcf,'Type','axes'),'Title');
set(cell2mat(h),'fontsize',14); %change titles fontsize to 14

if no_plot==1
    % make all lines (of plots till) now black (for publishing)
    set(findobj('Type','line'),'Color','k')
    return;
end

%to recalculate and plot best typical
From_Mat = 1; 
Directory_none='D:\PD_human\DBS_data\STN\STN\2004_02_26_PD_STN_PALLIDstudy\traj2\';
[NSD_best_none,avg,variance,diff,step]=Calc_SD(Directory_none,[1],'None',From_Mat,1,0);
lengthen_fig;
annotation(gcf,'textbox','Position',[0.08431 0.9067 0.06786 0.09841],'LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'A'},'HorizontalAlignment','center');
title('NO-PALLIDOTOMY','fontsize',14);
[NSD_best_contra,avg,variance,diff,step]=Calc_SD('D:\PD_human\DBS_data\STN\STN_Pallidotomy\2006_02_02_PD_STN_PALLIDstudy\L_hem_traj1\',[1],'Contralateral',From_Mat,1,0);
lengthen_fig;
annotation(gcf,'textbox','Position',[0.08431 0.9067 0.06786 0.09841],'LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'C'},'HorizontalAlignment','center');
title('CONTRALATERAL','fontsize',14);
[NSD_best_ipsi,avg,variance,diff,step]=Calc_SD('D:\PD_human\DBS_data\STN\STN_Pallidotomy\2006_02_02_PD_STN_PALLIDstudy\R_hem_traj2\',[1],'Ipsilateral',From_Mat,1,0);
lengthen_fig;
annotation(gcf,'textbox','Position',[0.08431 0.9067 0.06786 0.09841],'LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'D'},'HorizontalAlignment','center');
title('IPSILATERAL','fontsize',14);
[NSD_best_ipsi,avg,variance,diff,step]=Calc_SD('D:\PD_human\DBS_data\STN\STN_Pallidotomy\2005_12_08_PD_STN_PALLIDstudy\traj3\',[1],'Ipsilateral',From_Mat,1,0);
lengthen_fig;
annotation(gcf,'textbox','Position',[0.08431 0.9067 0.06786 0.09841],'LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'B'},'HorizontalAlignment','center');
title('IPSILATERAL','fontsize',14);

%to recalculate and plot SORTED best typical
[NSD_best_none,avg,variance,diff,step]=Calc_SD(Directory_none,[1],'None',From_Mat,1,1);
title('SORTED NO-PALLIDOTOMY','fontsize',14);
annotation(gcf,'textbox','Position',[0.08431 0.9067 0.06786 0.09841],'LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'B'},'HorizontalAlignment','center');
lengthen_fig;

% make all lines black (for publishing)
set(findobj('Type','line'),'Color','k')

