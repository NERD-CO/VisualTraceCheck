function [TRANS, EMIS] = estHMM(traj_Directory,elec,n_state,n_tag);
global WARNINGS USE_MAT
if nargin==0, disp('Useage: estHMM(traj_Directory,elec)'); return, end
if traj_Directory(end) ~= '\', traj_Directory = strcat(traj_Directory,'\'); end
[In,Out,soma2lim,InSNr,OutSNr]=load_InOut(traj_Directory);
ResultsFile=sprintf('RMS%u.mat',elec);load_Results;
eval(sprintf('depth=Elec_Depth%u;',elec));
eval(sprintf('tag=tag%u;',elec));
create_states;

if ~isnan(In(elec)) %skips out trajs where there is no 'In' defined
    [TRANS, EMIS] = hmmestimate(flipud(tag), flipud(states)); %flip to get correct order of sequence
elseif WARNINGS
    TRANS = zeros(n_state); %i.e. won't be used to calculate matrices
    EMIS = zeros(n_state,n_tag);
    disp('No ''In'' demarcation in file - traj not used!');
end
