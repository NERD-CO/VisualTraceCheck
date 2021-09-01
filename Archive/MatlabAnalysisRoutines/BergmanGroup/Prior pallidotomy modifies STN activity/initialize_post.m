load av_values.mat;
load SD_values.mat;


% %vector of SD averages for pallidotomy or no pallidotomy - THIS MAY HAVE
% %BECOME REDUNDANT DUE TO MY CHANGE AT THE END OF CALC_SD
% [i,j,NSD_av_none]=find(reshape(NSD_av_none,[],1));
% [i,j,NSD_av_contra]=find(reshape(NSD_av_contra,[],1));
% [i,j,NSD_av_ipsi]=find(reshape(NSD_av_ipsi,[],1));
% [i,j,NSD_var_none]=find(reshape(NSD_var_none,[],1));
% [i,j,NSD_var_contra]=find(reshape(NSD_var_contra,[],1));
% [i,j,NSD_var_ipsi]=find(reshape(NSD_var_ipsi,[],1));
% [i,j,NSD_diff_none]=find(reshape(NSD_diff_none,[],1));
% [i,j,NSD_diff_contra]=find(reshape(NSD_diff_contra,[],1));
% [i,j,NSD_diff_ipsi]=find(reshape(NSD_diff_ipsi,[],1));
% [i,j,STN_step_none]=find(reshape(STN_step_none,[],1));
% [i,j,STN_step_contra]=find(reshape(STN_step_contra,[],1));
% [i,j,STN_step_ipsi]=find(reshape(STN_step_ipsi,[],1));
% [i,j,STN_len_none]=find(reshape(STN_len_none,[],1));
% [i,j,STN_len_contra]=find(reshape(STN_len_contra,[],1));
% [i,j,STN_len_ipsi]=find(reshape(STN_len_ipsi,[],1));

av_NSD_av_ipsi = mean(NSD_av_ipsi);
av_NSD_av_contra = mean(NSD_av_contra);
av_NSD_av_none = mean(NSD_av_none);
sd_NSD_av_ipsi = std(NSD_av_ipsi,1);
sd_NSD_av_contra = std(NSD_av_contra,1);
sd_NSD_av_none = std(NSD_av_none,1);

av_NSD_var_ipsi = mean(NSD_var_ipsi);
av_NSD_var_contra = mean(NSD_var_contra);
av_NSD_var_none = mean(NSD_var_none);
sd_NSD_var_ipsi = std(NSD_var_ipsi,1);
sd_NSD_var_contra = std(NSD_var_contra,1);
sd_NSD_var_none = std(NSD_var_none,1);

av_NSD_diff_ipsi = mean(NSD_diff_ipsi);
av_NSD_diff_contra = mean(NSD_diff_contra);
av_NSD_diff_none = mean(NSD_diff_none);
sd_NSD_diff_ipsi = std(NSD_diff_ipsi,1);
sd_NSD_diff_contra = std(NSD_diff_contra,1);
sd_NSD_diff_none = std(NSD_diff_none,1);

av_STN_step_ipsi = mean(STN_step_ipsi);
av_STN_step_contra = mean(STN_step_contra);
av_STN_step_none = mean(STN_step_none);
sd_STN_step_ipsi = std(STN_step_ipsi,1);
sd_STN_step_contra = std(STN_step_contra,1);
sd_STN_step_none = std(STN_step_none,1);

av_STN_len_ipsi = mean(STN_len_ipsi);
av_STN_len_contra = mean(STN_len_contra);
av_STN_len_none = mean(STN_len_none);
sd_STN_len_ipsi = std(STN_len_ipsi,1);
sd_STN_len_contra = std(STN_len_contra,1);
sd_STN_len_none = std(STN_len_none,1);