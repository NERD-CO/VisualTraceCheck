function [baseSD,NSD,NSD_av,NSD_var,NSD_diff,STN_step,STN_len] = sd_sort_plot (Depth,SD_full,In,Out,header,channel,Pallidotomy,do_plot,sort_plot)

if do_plot
    figure;set(gcf,'color','w');
end
% annotation position 
annot_pos=[.6 .6 .25 .23]; %for view(0,90): [left bottom width height]
annot_pos=[.2 .6 .25 .23]; %for view(180,-90): [left bottom width height]
if ismember(1,channel) %If Electrode 1 chosen
    if length(channel)==2
        subplot(2,1,1);
    end
    A=(sortrows([Depth;SD_full(:,1)']'))'; %sort the SD according to ascending Depth Row 1 of A is sorted Depth, Row 2 is SD 
    In_index=min(find(A(1,:)>In(1))); 
    Out_index=max(find(A(1,:)<=Out(1)));
    baseSD(1)=mean(A(2,In_index:length(A(1,:))));
    if sort_plot
        mid=floor((Out_index+In_index)/2);
        NSD(:,1)=[[sort(A(2,Out_index+1:mid))],[sort(A(2,mid+1:In_index-1),'descend')]]/baseSD(1);
    else
        NSD(:,1)=A(2,Out_index+1:In_index-1)/baseSD(1);
    end
    NSD_av(1)=mean(NSD(:,1));
    NSD_var(1)=var(NSD(:,1));
    NSD_diff(1)=mean(abs(NSD(1:length(NSD(:,1))-1,1)-NSD(2:length(NSD(:,1)),1))); %MSD
    STN_step(1)=mean(abs(A(1,Out_index+2:In_index-1)-A(1,Out_index+1:In_index-2)));
    STN_len(1) = (In(1)-Out(1))/1000;
    if do_plot
        if sort_plot
            bar(A(1,:)./1000,[[A(2,1:Out_index)],[sort(A(2,Out_index+1:mid))],[sort(A(2,mid+1:In_index-1),'descend')],[A(2,In_index:length(A(2,:)))]]/baseSD(1),'k');
        else
            bar(A(1,:)./1000,A(2,:)/baseSD(1),'k');
        end
        set(gca,'fontsize',14);
        ylabel('NRMS','fontsize',14) %'FontWeight','demi'
        xlabel('EDT (mm)','fontsize',14)
        hold on;
        if ~(isnan(In(1)) || isnan(Out(1)))
            plot([In(1) In(1)]./1000,[max(A(2,:))/baseSD(1) 0],'--k','LineWidth',2);
            plot([Out(1) Out(1)]./1000,[max(A(2,:))/baseSD(1) 0],'--k','LineWidth',2);
        end
        plot(A(1,:)./1000,ones(1,length(A(1,:))),'--k','LineWidth',2); %plot baseline 
        plot([Out(1) In(1)]./1000,[NSD_av(1) NSD_av(1)],':k','LineWidth',2) %plot average 
        title(strcat(header,': ELECTRODE 1'),'Interpreter','none','fontsize',14,'fontweight','demi');
        ylim([0 4.1]);%ylim([0 1.1*max(A(2,:))/baseSD(1)]);
        annot=annotation('textbox',annot_pos); %changed y from 0.65 because of postprint
        out_text=sprintf('Avg. %.2f\nVar. %.2f\nMSD  %.2f',NSD_av(1),NSD_var(1),NSD_diff(1)); %\t doesn't work here!
        set(annot,'FitHeightToText','on','string',out_text,'fontsize',15,'FontName','courier','FontWeight','demi','HorizontalAlignment','left');
    end
end
if ismember(2,channel) %If Electrode 2 chosen
    if length(channel)==2
        subplot(2,1,2);
    end
    A=(sortrows([Depth;SD_full(:,2)']'))'; %sort the SD according to ascending Depth Row 1 of A is sorted Depth, Row 2 is SD
    In_index=min(find(A(1,:)>In(2))); 
    Out_index=max(find(A(1,:)<Out(2)));
    baseSD(2)=mean(A(2,In_index:length(A(1,:))));
    NSD(:,2)=A(2,Out_index+1:In_index-1)/baseSD(2);
    NSD_av(2)=mean(NSD(:,2));
    NSD_var(2)=var(NSD(:,2));
    NSD_diff(2)=mean(abs(A(2,Out_index+2:In_index-1)-A(2,Out_index+1:In_index-2))/baseSD(2));
    STN_step(2)=mean(abs(A(1,Out_index+2:In_index-1)-A(1,Out_index+1:In_index-2)));
    STN_len(2) = (In(2)-Out(2))/1000;
    if do_plot
        %sort plot not implemented here - not necessary
        bar(A(1,:)./1000,A(2,:)/baseSD(2),'k');
        set(gca,'fontsize',14);
        ylabel('NRMS','fontsize',14,'FontWeight','demi')
        xlabel('EDT (mm)','fontsize',14,'FontWeight','demi')
        hold on;
        if ~(isnan(In(2)) || isnan(Out(2)))
            plot([In(2) In(2)]./1000,[max(A(2,:))/baseSD(2) 0],'--k','LineWidth',2);
            plot([Out(2) Out(2)]./1000,[max(A(2,:))/baseSD(2) 0],'--k','LineWidth',2);
        end
        plot(A(1,:)./1000,ones(1,length(A(1,:))),'--k','LineWidth',2); %plot baseline 
        plot([Out(2) In(2)]./1000,[NSD_av(2) NSD_av(2)],':k','LineWidth',2) %plot average 
        title(strcat(header,': ELECTRODE 2'),'Interpreter','none','fontsize',12,'fontweight','demi');
        ylim([0 4.1]);%ylim([0 1.1*max(A(2,:))/baseSD(2)]);
        annot=annotation('textbox',annot_pos);
        out_text=sprintf('Avg %.2f\nVar %.2f\nMSD %.2f',NSD_av(2),NSD_var(2),NSD_diff(2)); %\t doesn't work here!
        set(annot,'FitHeightToText','on','string',out_text,'fontsize',15,'FontName','courier','FontWeight','demi','HorizontalAlignment','left');
    end
end



