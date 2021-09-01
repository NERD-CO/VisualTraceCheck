function [HMM_STATES,Error,Status] = doHMM(traj_Directory,elec, TRANS, EMIS ,PLOT);
global WARNINGS USE_MAT
reliability_range=2; %mm
if nargin==0, disp('Useage: doHMM(traj_Directory,elec, TRANS, EMIS)'); return, end
if traj_Directory(end) ~= '\', traj_Directory = strcat(traj_Directory,'\'); end
[In,Out,soma2lim]=load_InOut(traj_Directory); ResultsFile=sprintf('RMS%u.mat',elec); load_Results;
eval(sprintf('depth=Elec_Depth%u;',elec)); eval(sprintf('tag=tag%u;',elec)); eval(sprintf('RMS=RMS%u;',elec));
create_states; %for comparison to HMM_STATES
HMM_STATES = fliplr(hmmviterbi(flipud(tag), TRANS, EMIS)); %flip to get correct order of sequence
In_error=(depth(find(states==1,1,'first')-1)-depth(find(HMM_STATES==1,1,'first')-1))/1000;
if abs(In_error)<reliability_range, In_status=1; else In_status=3; end %HIT/miss
trans2bit = (max(states==2) & max(states==3)) + 2*(max(HMM_STATES==2) & max(HMM_STATES==3));
switch trans2bit
    case 3 %if there is a 'trans' in both 'states' and 'HMM_STATES'
        trans_error=(depth(find(states==2,1,'first')-1)-depth(find(HMM_STATES==2,1,'first')))/1000;
        if abs(trans_error)<reliability_range, trans_status=1; else trans_status=3; end %HIT/miss
    case 2 %if there is a 'trans' in 'HMM_STATES' but not in 'states'
        trans_error=NaN;trans_status=2; %false alarm
    case 1 %if there is a 'trans' in 'states' but not in 'HMM_STATES'
        trans_error=NaN;trans_status=3; %misses
    case 0 %if there is NO 'trans' in both 'states' and 'HMM_STATES'
        trans_error=NaN;trans_status=4; %correct rejection
end
Out2bit = max(states==4) + 2*max(HMM_STATES==4);
switch Out2bit
    case 3 %if there is an 'Out' in both 'states' and 'HMM_STATES'
        Out_error=(depth(find(states==4,1,'last'))-depth(find(HMM_STATES==4,1,'last')))/1000;
        if abs(Out_error)<reliability_range, Out_status=1; else Out_status=3; end %HIT/miss
    case 2 %if there is an 'Out' in 'HMM_STATES' but not in 'states'
        Out_error=NaN; Out_status=2; %false alarm
    case 1 %if there is an 'Out' in 'states' but not in 'HMM_STATES'
        Out_error=NaN;Out_status=3; %misses
    case 0 %if there is NO 'Out' in both 'states' and 'HMM_STATES'
        Out_error=NaN;Out_status=4; %correct rejection
end
Error=[In_error trans_error Out_error]; Status=[In_status trans_status Out_status];

if PLOT
    [P1_STN,PSD1,PSD_top1,PSD_bottom1,PSD_prior1,P2_STN,PSD2,PSD_top2,PSD_bottom2,PSD_prior2,h_RMS,h_PSD]=plotPSD(traj_Directory,elec,PLOT,0);
    subplot(h_RMS); hold on;
    %plot(depth/1000,states/2,'b');
    plot(depth/1000,tag/2,'b','linewidth',1.5);
    plot(depth/1000,HMM_STATES/2,'g','linewidth',1.5);
    %legend('NRMS','In','dorsal-ventral','Out','mean \beta','max \beta','HMM state')
end
