function post_print_spectrum(file);
load(file)

%plot No-pallidotomy Data
x=(1/f_resolution:1/f_resolution:nf);
cutoff_freq=[3 60];
ymax=5 ;ymin=0;
% ymax=5;ymin=0.5;
ymax_factor=0.6;
xlabel_Hz='Hz';
PSD_none_tot(1:f_resolution*nf)=0;PSD_none_low_tot(1:f_resolution*nf)=0;PSD_none_high_tot(1:f_resolution*nf)=0;
PSD_ipsi_tot(1:f_resolution*nf)=0;PSD_ipsi_low_tot(1:f_resolution*nf)=0;PSD_ipsi_high_tot(1:f_resolution*nf)=0;
PSD_contra_tot(1:f_resolution*nf)=0;PSD_contra_low_tot(1:f_resolution*nf)=0;PSD_contra_high_tot(1:f_resolution*nf)=0;
plot_together=1; %plot data as subplots. 1 figure for None, 1 for ipsi vs. contra and 1 for bilateral.

for j = 1:21
    PSD=PSD_none{j};PSD_none_tot=PSD_none_tot+PSD_none{j};
    PSD_low=PSD_none_low{j};PSD_none_low_tot=PSD_none_low_tot+PSD_none_low{j};
    PSD_high=PSD_none_high{j};PSD_none_high_tot=PSD_none_high_tot+PSD_none_high{j};
    [C,I] = max(PSD(cutoff_freq*f_resolution:length(PSD)));
    peak_freq = cutoff_freq+I/f_resolution;
    if (j==1) || (plot_together==0)
        figure;
    end
    if plot_together==1
        subplot(4,6,j);
    end
    plot(x,mylog(PSD));title(sprintf('None %u.',j));axis([cutoff_freq(1) cutoff_freq(2) ymin ymax]);xlabel(xlabel_Hz);
end

%plot contralateral pallidotomy Data
for k = 1:5
    PSD=PSD_contra{k};PSD_contra_tot=PSD_contra_tot+PSD_contra{k};
    PSD_low=PSD_contra_low{k};PSD_contra_low_tot=PSD_contra_low_tot+PSD_contra_low{k};
    PSD_high=PSD_contra_high{k};PSD_contra_high_tot=PSD_contra_high_tot+PSD_contra_high{k};
    [C,I] = max(PSD(cutoff_freq*f_resolution:length(PSD)));
    peak_freq = cutoff_freq+I/f_resolution;
    if (k==1) || (plot_together==0)
        figure
    end
    if plot_together==1 
        subplot(5,2,2*k);
    end
    plot(x,mylog(PSD));title(sprintf('Contra %u.',k));axis([cutoff_freq(1) cutoff_freq(2) ymin ymax]);xlabel(xlabel_Hz);
end

%plot ipsilateral pallidotomy Data  Split in two 1-5 and 6-7 for plotting
%purposes
for l = 1:5 %6 and 7 are from billateral pallidotomy plotted below
    PSD=PSD_ipsi{l};PSD_ipsi_tot=PSD_ipsi_tot+PSD_ipsi{l};
    PSD_low=PSD_ipsi_low{l};PSD_ipsi_low_tot=PSD_ipsi_low_tot+PSD_ipsi_low{l};
    PSD_high=PSD_ipsi_high{l};PSD_ipsi_high_tot=PSD_ipsi_high_tot+PSD_ipsi_high{l};
    [C,I] = max(PSD(cutoff_freq*f_resolution:length(PSD)));
    peak_freq = cutoff_freq+I/f_resolution;
    if plot_together==0
        figure
    end
    if plot_together==1 %plotted on the same figure as ipsi
        subplot(5,2,2*l-1);
    end
    plot(x,mylog(PSD));title(sprintf('Ipsi %u.',l));axis([cutoff_freq(1) cutoff_freq(2) ymin ymax]);xlabel(xlabel_Hz);
end
for m = 6:7 %bilateral pallidotomy 
    PSD=PSD_ipsi{m};PSD_ipsi_tot=PSD_ipsi_tot+PSD_ipsi{m};
    PSD_low=PSD_ipsi_low{m};PSD_ipsi_low_tot=PSD_ipsi_low_tot+PSD_ipsi_low{m};
    PSD_high=PSD_ipsi_high{m};PSD_ipsi_high_tot=PSD_ipsi_high_tot+PSD_ipsi_high{m};
    [C,I] = max(PSD(cutoff_freq*f_resolution:length(PSD)));
    peak_freq = cutoff_freq+I/f_resolution;
    if (m==6) || (plot_together==0)
        figure
    end
    if plot_together==1
        subplot(2,1,m-5);
    end
    plot(x,mylog(PSD));title(sprintf('Ipsi %u.',m));axis([cutoff_freq(1) cutoff_freq(2) ymin ymax]);xlabel(xlabel_Hz);
end

%plot the average PSD for none/ipsi/contra and average for RMS values above/below average RMS
figure;set(gcf,'color','w');

h3=subplot(2,3,1);hold on;set(gca,'DataAspectRatio',[16 1 1]);
plot(x,mylog(PSD_ipsi_tot/m));axis([cutoff_freq(1) cutoff_freq(2) ymin ymax*ymax_factor]);ylabel('PSD','fontsize',14);
p3=get(h3,'position');
set(h3,'position',p3 + [0 -0.1 0 0]);
h4=subplot(2,3,4);hold on;set(gca,'DataAspectRatio',[16 1 1]);
plot(x,mylog(PSD_ipsi_low_tot/m));axis([cutoff_freq(1) cutoff_freq(2) ymin ymax*ymax_factor]);ylabel('PSD','fontsize',14);
p4=get(h4,'position');
set(h4,'position',p4);
plot(x,mylog(PSD_ipsi_high_tot/m),':');xlabel(xlabel_Hz,'fontsize',14);axis([cutoff_freq(1) cutoff_freq(2) ymin ymax*ymax_factor]);

h5=subplot(2,3,2);hold on;set(gca,'DataAspectRatio',[16 1 1]);
plot(x,mylog(PSD_contra_tot/k));axis([cutoff_freq(1) cutoff_freq(2) ymin ymax*ymax_factor]);
p5=get(h5,'position');
set(h5,'position',p5 + [0 -0.1 0 0]);
h6=subplot(2,3,5);hold on;set(gca,'DataAspectRatio',[16 1 1]);
plot(x,mylog(PSD_contra_low_tot/k));axis([cutoff_freq(1) cutoff_freq(2) ymin ymax*ymax_factor]);
p6=get(h6,'position');
set(h6,'position',p6);
plot(x,mylog(PSD_contra_high_tot/k),':');xlabel(xlabel_Hz,'fontsize',14);axis([cutoff_freq(1) cutoff_freq(2) ymin ymax*ymax_factor]);

h1=subplot(2,3,3);hold on;set(gca,'DataAspectRatio',[16 1 1]);
plot(x,mylog(PSD_none_tot/j));axis([cutoff_freq(1) cutoff_freq(2) ymin ymax*ymax_factor]);
p1=get(h1,'position');
set(h1,'position',p1 + [0 -0.1 0 0]);
h2=subplot(2,3,6);hold on;set(gca,'DataAspectRatio',[16 1 1]);
plot(x,mylog(PSD_none_low_tot/j));axis([cutoff_freq(1) cutoff_freq(2) ymin ymax*ymax_factor]);
p2=get(h2,'position');
set(h2,'position',p2);
plot(x,mylog(PSD_none_high_tot/j),':');xlabel(xlabel_Hz,'fontsize',14);axis([cutoff_freq(1) cutoff_freq(2) ymin ymax*ymax_factor]);

% make all lines black (for publishing)
set(findobj('Type','line'),'Color','k')
% change fontsize to 14
set(findobj(gcf,'Type','axes'),'fontsize',14)
h=get(findobj(gcf,'Type','axes'),'Title');
set(cell2mat(h),'fontsize',14); %change titles fontsize to 14
%reshape figure size
pos=get(gcf,'Position');
pos(4) = pos(4)*1.4; %lengthen
pos(2) = 0.4*pos(2);
pos(3) = pos(3)*1.4; %widen
pos(1) = 0.4*pos(1);
set(gcf,'Position',pos)

%% Create textboxes
annotation1 = annotation(gcf,'textbox','Position',[0.1301 0.89 0.2105 0.067],'HorizontalAlignment','center','LineStyle','none','FitHeightToText','off','FontSize',14,'String',{'IPSILATERAL'});
annotation2 = annotation(gcf,'textbox','Position',[0.4107 0.89 0.2105 0.067],'HorizontalAlignment','center','LineStyle','none','FitHeightToText','off','FontSize',14,'String',{'CONTRALATERAL'});
annotation3 = annotation(gcf,'textbox','Position',[0.6926 0.89 0.2105 0.067],'HorizontalAlignment','center','LineStyle','none','FitHeightToText','off','FontSize',14,'String',{'NO-PALLIDOTOMY'});

annotationA = annotation(gcf,'textbox','Position',[0.0625 0.8173 0.1 0.067],'HorizontalAlignment','center','LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'A'});
annotationB = annotation(gcf,'textbox','Position',[0.3431 0.8173 0.1 0.067],'HorizontalAlignment','center','LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'B'});
annotationC = annotation(gcf,'textbox','Position',[0.6186 0.8173 0.1 0.067],'HorizontalAlignment','center','LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'C'});
annotationD = annotation(gcf,'textbox','Position',[0.0625 0.4357 0.1 0.067],'HorizontalAlignment','center','LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'D'});
annotationE = annotation(gcf,'textbox','Position',[0.3431 0.4357 0.1 0.067],'HorizontalAlignment','center','LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'E'});
annotationF = annotation(gcf,'textbox','Position',[0.6186 0.4357 0.1 0.067],'HorizontalAlignment','center','LineStyle','none','FitHeightToText','off','FontSize',28,'String',{'F'});



