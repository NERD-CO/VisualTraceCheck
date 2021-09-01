function plotSpectrogram(P,depth,F,DO_SMOOTH)
global PLOT_forpub;
PLOT_EACH_PSD=0;
if nargin <4, DO_SMOOTH=1; end %the default of the function is to smooth the spectrogram for plotting 
depth=reshape(depth,length(depth),1); %make certain depth is a column vector
if PLOT_EACH_PSD %plots each PSD not spectrogram
    plot(F,PSDsmoothLog(P));
else
    temp = sortrows([depth P]); %sort the PSD in order of depth
    P=temp(:,2:end);
    d=temp(:,1);
    P_forplot=PSDsmoothLog(P,F,DO_SMOOTH); 
    h=pcolor(F,d/1000,P_forplot); shading interp; view(-90,90);%%%%%%%%currently with log
    if PLOT_forpub, colorbar; end
%     imagesc(F,d/1000,P_forplot); %shading interp; %%%%%%%%currently with log (originally surf) 
    [min_P,I_min] = min(reshape(P_forplot',1,[]));V_min=ceil(I_min/size(P_forplot,2));%which trace gives the min PSD?
    [max_P,I_max] = max(reshape(P_forplot',1,[]));V_max=ceil(I_max/size(P_forplot,2));%which trace gives the max PSD?
    if PLOT_forpub ylabel('EDT (mm)'); else ylabel(sprintf('EDT (mm). minP @%dum; maxP @%dum',d(V_min),d(V_max))); end
    axis xy; axis tight; colormap(jet);
    F_ticks=F([find(F==2),find(F==10),find(F==20),find(F==100),find(F==200),find(F==1000)]); set(gca,'xtick',F_ticks);   
end