initialize; %variables (needed for nucleus)
WORK_DIR='D:\MATLAB_WORK\';
[num_gen, XLSgeneral]=xlsread(strcat(WORK_DIR,'surgeries.xls'),'general');
switch nucleus
    case 'S', listname = 'STN'; [num_STN, STNlist]=xlsread(strcat(WORK_DIR,'surgeries.xls'),'STN');STN_DIR=XLSgeneral{1,2};
    case 'V', listname = 'ViM'; [num_ViM, ViMlist]=xlsread(strcat(WORK_DIR,'surgeries.xls'),'ViM');ViM_DIR=XLSgeneral{2,2};
    case 'G', listname = 'GPi'; [num_GPi, GPilist]=xlsread(strcat(WORK_DIR,'surgeries.xls'),'GPi');GPi_DIR=XLSgeneral{3,2};
end
clear INlist OUTlist DATA_DIR;
eval(sprintf('INlist=%slist;',listname)); eval(sprintf('DATA_DIR=%s_DIR;',listname));
for m=2:size(INlist,1) %m=1 is the headings
    local_dir=INlist{m,3}; 
    if local_dir(end) ~= '\', local_dir = strcat(local_dir,'\'); end
    OUTlist{m}.dir=strcat(DATA_DIR,local_dir); %load data directories
    elec_vector=[strcmp(INlist{m,4},'E1') strcmp(INlist{m,5},'E2')*2]; %load electrodes
    OUTlist{m}.elec=elec_vector(elec_vector>0); %remove zeros from variable
    OUTlist{m}.datamissing=strcmp(INlist{m,4},'NO DATA') | strcmp(INlist{m,5},'NO DATA');
    OUTlist{m}.use_traj=strcmp(INlist{m,1},'y'); OUTlist{m}.test_traj=strcmp(INlist{m,1},'t');
    stab_vector=[~isempty(strfind(INlist{m,9},'E1')) ~isempty(strfind(INlist{m,9},'E2'))];
    OUTlist{m}.done_stab=all(stab_vector(OUTlist{m}.elec));
    OUTlist{m}.cent_track=strcmp(INlist{m,7},'E1') + strcmp(INlist{m,7},'E2')*2; %str2num(INlist{m,7});
    OUTlist{m}.imp=[str2num(INlist{m,20}) str2num(INlist{m,21})];
    if length(OUTlist{m}.cent_track)==0, OUTlist{m}.cent_track=2; end %default
    %save the in/out to file in the traj directory
    In=[str2num(INlist{m,10}) str2num(INlist{m,11})];
    Out=[str2num(INlist{m,12}) str2num(INlist{m,13})];
    soma2lim=[str2num(INlist{m,14}) str2num(INlist{m,15})];
    InSNr=[str2num(INlist{m,16}) str2num(INlist{m,17})];
    OutSNr=[str2num(INlist{m,18}) str2num(INlist{m,19})];
    if (OUTlist{m}.dir(end-1) ~= 'X') & ~strcmp(OUTlist{m}.dir(end-7:end-1),'NO DATA') %i.e. if there is a traj directory
        save(strcat(OUTlist{m}.dir,'InOut.mat'),'In','Out','soma2lim','InSNr','OutSNr');
        yr_idx=findstr(local_dir,'20'); %assumes that all data is within the years 20XX (y2.1k bug is here) 
        OUTlist{m}.date=local_dir(yr_idx:yr_idx+9); 
    end
end
eval(sprintf('%s_list=OUTlist;',listname));
clear DATA_DIR
save(strcat(WORK_DIR,'PSD_list.mat'),'listname','*_list','*_DIR','nucleus');


