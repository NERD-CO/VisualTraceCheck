function doCluster(traj_Directory,electrode,PLOT);
%PLOT=1;
global Num_forNorm USE_MAT
if nargin==0
    disp('Useage: doCluster(traj_Directory,*electrode=[1 2]),*PLOT=0');
    disp('* means optional. (Default value indicated)');
    return
end
if nargin<3, PLOT=0; end
if nargin<2, electrode=[1 2]; end
if traj_Directory(end) ~= '\', traj_Directory = strcat(traj_Directory,'\'); end
%%PLOT RMS
if PLOT, figure;set(gcf,'color','w'); plotRMS(traj_Directory,electrode,0), end
for i=1:length(electrode)
    elec=electrode(i);
    ResultsFile=sprintf('PSD%u_200Hz.mat',elec);load_Results; ResultsFile=sprintf('RMS%u.mat',elec);load_Results;
    eval(sprintf('depth=depth%u;',elec));
    eval(sprintf('RMS=RMS%u/mean(RMS%u((end-Num_forNorm+1):end));',elec,elec)); %use first 10 RMSs (no smoothing)
    eval(sprintf('diffPSD=beta%u-gamma%u;',elec,elec)); diffPSD=smooth_freq(diffPSD,2/3,3);
    eval(sprintf('betaPSD=beta%u;',elec)); betaPSD=smooth_freq(betaPSD,2/3,3);%SD=2/3 units, n=3 X SDs.
    eval(sprintf('betaPSD_max=beta_max%u;',elec)); betaPSD_max=smooth_freq(betaPSD_max,2/3,3);
    eval(sprintf('betaPSD_maxmean=beta_maxmean%u;',elec)); betaPSD_maxmean=smooth_freq(betaPSD_maxmean,2/3,3);
    eval(sprintf('gammaPSD=gamma%u;',elec)); gammaPSD=smooth_freq(gammaPSD,2/3,3);       
    eval(sprintf('highgammaPSD=highgamma%u;',elec)); highgammaPSD=smooth_freq(highgammaPSD,2/3,3);      
    %% Custom clustering
    tag=zeros(length(RMS),1); tag_beta=zeros(length(RMS),1); tag_beta_max =zeros(length(RMS),1); tag_beta_maxmean =zeros(length(RMS),1); tag_depth=zeros(length(RMS),1);
    tag_gamma=zeros(length(RMS),1);tag_highgamma=zeros(length(RMS),1); tag_diff=zeros(length(RMS),1); tag_diff_2b=zeros(length(RMS),1); tag_beta_2b=zeros(length(RMS),1); tag_beta_maxmean_2b=zeros(length(RMS),1);
    RMS_lim1=1.25;
    RMS_lim2=RMS_lim1+0.25*(mean(RMS(RMS>RMS_lim1))-RMS_lim1);  
    % RMS_lim2=prctile(RMS(RMS>RMS_lim1),15);
    % figure; hist(RMS); title(strcat('RMS_lim2=',num2str(RMS_lim2)));
    tag(RMS < RMS_lim1)=1; tag(RMS >= RMS_lim1 & RMS < RMS_lim2)=2;
    highest_RMS=3; tag(RMS >= RMS_lim2)=highest_RMS;
    medBeta=median(betaPSD); beta0p25=prctile(betaPSD,25); beta0p75=prctile(betaPSD,75); %could use tag>=2
    medBeta_max=median(betaPSD_max); 
    medBeta_maxmean=median(betaPSD_maxmean); beta_maxmean0p25=prctile(betaPSD_maxmean,25); beta_maxmean0p75=prctile(betaPSD_maxmean,75); %could use tag>=2
    medGamma=median(gammaPSD(tag>=2)); medhighGamma=median(highgammaPSD(tag>=2));
    medDiff=median(diffPSD(tag>=2)); diff0p25=prctile(diffPSD(tag>=2),25); diff0p75=prctile(diffPSD(tag>=2),75);
    %1 bit tags (added to high RMS tags only!)
    tag_beta(tag==highest_RMS & betaPSD<=medBeta) = 1; 
    tag_beta_max(tag==highest_RMS & betaPSD_max<=medBeta_max) = 1; 
    tag_beta_maxmean(tag==highest_RMS & betaPSD_maxmean<=medBeta_maxmean) = 1; 
    tag_gamma(tag==highest_RMS & gammaPSD<=medGamma) = 1; 
    tag_highgamma(tag==highest_RMS & highgammaPSD<=medhighGamma) = 1; 
    tag_diff(tag==highest_RMS & diffPSD<=medDiff) = 1; 
    %2 bit diff
    tag_diff_2b(tag==highest_RMS & diffPSD<=diff0p25) = 0; tag_diff_2b(tag==highest_RMS & diffPSD>diff0p25 & diffPSD<=medDiff) = 1;
    tag_diff_2b(tag==highest_RMS & diffPSD>medDiff & diffPSD<=diff0p75) = 2; tag_diff_2b(tag==highest_RMS & diffPSD>diff0p75) = 3;
    %2 bit beta
    tag_beta_2b(tag==highest_RMS & betaPSD<=beta0p25) = 0; tag_beta_2b(tag==highest_RMS & betaPSD>beta0p25 & betaPSD<=medBeta) = 1;
    tag_beta_2b(tag==highest_RMS & betaPSD>medBeta & betaPSD<=beta0p75) = 2; tag_beta_2b(tag==highest_RMS & betaPSD>beta0p75) = 3;
    %2 bit betamaxmean
    tag_beta_maxmean_2b(tag==highest_RMS & betaPSD_maxmean<=beta_maxmean0p25) = 0; tag_beta_maxmean_2b(tag==highest_RMS & betaPSD_maxmean>beta_maxmean0p25 & betaPSD_maxmean<=medBeta_maxmean) = 1;
    tag_beta_maxmean_2b(tag==highest_RMS & betaPSD_maxmean>medBeta_maxmean & betaPSD_maxmean<=beta_maxmean0p75) = 2; tag_beta_maxmean_2b(tag==highest_RMS & betaPSD_maxmean>beta_maxmean0p75) = 3;
    
    tag = tag + tag_beta_max + tag_beta*2;
    
    if PLOT
        subplot(2,length(electrode),length(electrode)+i); hold on; 
        scatter3(RMS,betaPSD,depth,5,tag);xlabel('RMS');ylabel('beta');zlabel('EDT');
        %%PLOT BETA and tags on RMS graph
        subplot(2,length(electrode),i); hold on; eval(sprintf('plot(depth%u/1000,beta%u,''r'');',elec,elec));
        plot(depth/1000,RMS,'k'); plot(depth/1000,RMS_lim1,'g'); plot(depth/1000,RMS_lim2,'g');        
        plot(depth/1000,betaPSD,'m'); plot(depth/1000,tag/2,'b'); 
        set(gca,'XDir','reverse'); axis tight;
    end
    ResultsFile=sprintf('RMS%u.mat',elec); eval(sprintf('tag%u=tag;',elec));
    if USE_MAT, eval(sprintf('save(strcat(traj_Directory,''AOMatlab\\'',ResultsFile),''-v6'',''tag%u'',''-append'');',elec));
    else, eval(sprintf('save(strcat(traj_Directory,ResultsFile),''-v6'',''tag%u'',''-append'');',elec)); end;
end

