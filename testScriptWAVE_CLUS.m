load('AbvTrgt_32_04569.mat')
plot(CSPK_01(1:100000))
tmpSpk = CSPK_01;
save('tmpspk.mat','data')
sr = mer.sampFreqHz;
save('tmpspk.mat','data','sr')


Get_spikes('tmpspk.mat')
Do_clustering('tmpspk_spikes.mat')
load('times_tmpspk.mat')
unique(cluster_class(:,1))
plot(transpose(spikes(cluster_class(:,1) == 1,:)))
plot(transpose(spikes(cluster_class(:,1) == 2,:)))

