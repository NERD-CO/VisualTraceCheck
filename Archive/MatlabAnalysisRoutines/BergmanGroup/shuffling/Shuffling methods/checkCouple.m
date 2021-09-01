% Writen by: Michal Rivlin.
% Last updated: 12.4.2005

% This function takes only the common recording time of both given spike
% trains, and then calls crossConf and compense functions that calculate the 
% confidence level and plot the CSD and compensatsion term.
% If there is no common time to both spike trains, a message is diplayed.
% spA,spB are vectors containing the times of the spike occurences
% a,b,c are integers for plotting the results in the given subplot. 
% The function calls plotPower function that plots the results.
function [comp,freq,conf] = checkCouple(spA,spB,a,b,c)

global NFFT NUM_RAND DT 

% we must take only the time both neurons were active to calculate the
% coherence
min_time=max(spA(1),spB(1));
max_time=min(spA(end),spB(end));
spA=spA(spA>=min_time & spA<=max_time);
spB=spB(spB>=min_time & spB<=max_time);
spA=spA-min_time+1;
spB=spB-min_time+1;
len=max_time-min_time+1
if len<=1
    f=sprintf('function checkCouple: no common time for the two neurons')
    return
end

% The double-global shuffling
[freq,Pab,freq_rand,Pab_rand] = crossConf(spA,spB,len,a,b,c(1));
% The compensation
[comp,conf] = compens(freq,Pab,freq_rand,Pab_rand,a,b,c(2));

return