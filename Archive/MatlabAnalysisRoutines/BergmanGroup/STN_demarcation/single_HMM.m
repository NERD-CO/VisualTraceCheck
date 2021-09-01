function [Error,Status,TRANS_tot,EMIS_tot] = single_HMM(list,DO_BOTH_ELECs,PLOT,PLOT_quantization);
n_state=4; n_tag=6;
TRANS_tot = zeros(n_state); EMIS_tot = zeros(n_state,n_tag); TRANS_sum = zeros(n_state,1); EMIS_sum = zeros(n_state,1);
count=0;
%train HMM (estimate transition and emission matrices)
for m=2:size(list,2)
    if DO_BOTH_ELECs & ~list{m}.datamissing, list{m}.elec=[1 2]; end
    if size(list{m}.elec,2)>0 && list{m}.use_traj && ~strcmp(list{m}.dir,'D:\PD_human\DBS_data\STN\STN\X')
        for i=1:length(list{m}.elec)
            elec=list{m}.elec(i);
            [TRANS, EMIS] = estHMM(list{m}.dir,elec,n_state,n_tag);
            if size(TRANS)==[3 3], TRANS=[TRANS [0;0;0];[0 0 0 1]]; end
            if size(EMIS,1)==n_state-1, EMIS=[EMIS ;zeros(1,n_tag)]; end  %if the last state isn't visited
            if size(EMIS,2)< n_tag, EMIS=[EMIS , zeros(n_state,n_tag-size(EMIS,2))]; end      
            if sum(sum(TRANS))~=0 & sum(sum(EMIS))~=0
                TRANS_tot=TRANS_tot + TRANS; TRANS_sum=TRANS_sum + sum(TRANS,2);
                EMIS_tot=EMIS_tot + EMIS; EMIS_sum=EMIS_sum + sum(EMIS,2);
            end
        count=count+1;
        end
    end
end
EMIS_tot=EMIS_tot./repmat(EMIS_sum,1,n_tag); TRANS_tot=TRANS_tot./repmat(TRANS_sum,1,n_state);
%test HMM
for m=2:size(list,2)
    if size(list{m}.elec,2)>0 && list{m}.test_traj
        for i=1:length(list{m}.elec)
            elec=list{m}.elec(i);
            [STATES,Error(i,:),Status(i,:)] = doHMM(list{m}.dir,elec, TRANS_tot, EMIS_tot, PLOT); %flip to get correct order of sequence
        end
    end
end
            
        

