initialize; %variables
DO_GONIOM_PSD=0;        % (global) don't use goniom here
load('PSD_list.mat');
list=STN_list;
PLOT_quantization=0;
Error=[];Status=[];
count=0; TRANS_sum=zeros(4); EMIS_sum=zeros(4,6);
for m=2:size(list,2)
    if size(list{m}.elec,2)>0 && ~strcmp(list{m}.dir,'D:\PD_human\DBS_data\STN\STN\X')
        use(m)=list{m}.use_traj; test(m)=list{m}.test_traj;
        if use(m) || test(m)
            doCluster(list{m}.dir,list{m}.elec,PLOT_quantization); %to calc. & save tags.
        end
    end
end
if sum(test)~=0 & sum(use)~=0 %if there is a 'test_traj' defined in the XLS do a single test
    [Error Status]=single_HMM(list,DO_BOTH_ELECs,PLOT,PLOT_quantization);
else %o/w test each 'use_traj' while using all the other 'use_traj's for the HMM
    for i=2:length(use)
        if use(i)
            new_list=list; new_list{i}.use_traj=0; new_list{i}.test_traj=1;
            [Err,Stat,TRANS,EMIS]=single_HMM(new_list,DO_BOTH_ELECs,PLOT,0);
            Error=[Error;Err]; Status=[Status;Stat];
            TRANS_sum=TRANS_sum+TRANS; EMIS_sum=EMIS_sum+EMIS; count=count+1;
        end
    end
    mean_error=nanmean(Error); std_error=nanstd(Error); hist_lim=max(max(abs(Error)));
    Hits=sum(Status==1); False_alarms=sum(Status==2); Misses=sum(Status==3); Correct_rejections=sum(Status==4);
    DR=round(100*(Hits+Correct_rejections)./(Hits+Correct_rejections+False_alarms+Misses));
    if PLOT_forpub
        title_in='''In'' Transition Error'; title_trans='''Dorsal-Ventral'' Transition Error'; title_out='''Out'' Transition Error';
    else
        title_in=sprintf('In: mean=%.3f; std= %.3f; Hits=%u; CRs=%u; Misses=%u; FAs=%u; DR=%u%%',mean_error(1),std_error(1),Hits(1),Correct_rejections(1),Misses(1),False_alarms(1),DR(1));
        title_trans=sprintf('Soma2lim: mean=%.3f; std= %.3f; Hits=%u; CRs=%u; Misses=%u; FAs=%u; DR=%u%%',mean_error(2),std_error(2),Hits(2),Correct_rejections(2),Misses(2),False_alarms(2),DR(2));
        title_out=sprintf('Out: mean=%.3f; std= %.3f; Hits=%u; CRs=%u; Misses=%u; FAs=%u; DR=%u%%',mean_error(3),std_error(3),Hits(3),Correct_rejections(3),Misses(3),False_alarms(3),DR(3));
    end
    save('D:\MATLAB_WORK\STN_analysis\HMM_results','Error','mean_error','std_error','use');
    figure; 
    subplot(3,1,1); hist(Error(:,1));title(title_in);xlabel('mm');xlim([-hist_lim hist_lim]);ylabel('counts');
    if PLOT_forpub
        Pos=get(gca,'Position'); A_Pos = [(Pos(1)-0.1) (Pos(2)+Pos(4)) 0.07 0.07];
        ann_A = annotation(gcf,'textbox','Position',A_Pos,'LineStyle','none','FitHeightToText','off','FontSize',18,'FontWeight','bold','String',{'A'});
    end
    subplot(3,1,2); hist(Error(:,2));title(title_trans);xlabel('mm');xlim([-hist_lim hist_lim]);ylabel('counts');
    if PLOT_forpub
        Pos=get(gca,'Position'); B_Pos = [(Pos(1)-0.1) (Pos(2)+Pos(4)) 0.07 0.07];
        ann_A = annotation(gcf,'textbox','Position',B_Pos,'LineStyle','none','FitHeightToText','off','FontSize',18,'FontWeight','bold','String',{'B'});
    end
    subplot(3,1,3); hist(Error(:,3));title(title_out);xlabel('mm');xlim([-hist_lim hist_lim]);ylabel('counts');
    if PLOT_forpub
        Pos=get(gca,'Position'); C_Pos = [(Pos(1)-0.1) (Pos(2)+Pos(4)) 0.07 0.07];
        ann_A = annotation(gcf,'textbox','Position',C_Pos,'LineStyle','none','FitHeightToText','off','FontSize',18,'FontWeight','bold','String',{'C'});
    end
    h = findobj(gcf,'Type','patch');
    set(h,'FaceColor','k','EdgeColor','none')
end



