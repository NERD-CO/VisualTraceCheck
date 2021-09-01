% Writen by: Michal Rivlin.
% Last updated: 12.4.2005

% Computes the PSD and finds a confidence level based on the ISI shuffling method.
% spike_time: A vector containing the bins in wich a spike has occured.
% spike_time(i)=number of bin in which the ith spike has occured.
% dt: The time resolution in spike_time.
% local: If local>0, a local shuffling is done, and the segments' length are
% distributed uniformly: U(local,local+50). 
% Otherwise, for local=0, a global shuffling is done.
% num_rand: The number of repetitions on the shuffling process.
function [comp,freq,conf] = runPSD(spike_time,dt,local,num_rand)

global NFFT NUM_RAND LOCAL DT P_VAL CONF_PERCENT

% NFFT:
% Determines the window length to calculate the psd. For a ~0.25 Hz resolution, take NFFT=4096.
NFFT=4096;

% NUM_RAND:
% Determines the number of repetitions done to calculate the confidence interval. 
NUM_RAND=num_rand;

% LOCAL: 
% Determines the Tr parameter: the spike trains will be divided into segments of length
% Tr, where Tr is a random number uniformly distributed over 50 bins: Tr~U(175,225).
LOCAL=local;

%P_VAL:
% Determines the p value.
P_VAL=0.01; 

% CONF_PERCENT:
% The confidence level is established based on the last CONF_PERCENT percent
CONF_PERCENT=10; 

% DT
% The time resolution in spike_time
DT=dt;

figure;
if (LOCAL>0) %the local shuffling
    [freq,pow,freq_rand,pow_rand] = localShuffling(spike_time,2,1,1);
else %the global shuffling
    [freq,pow,freq_rand,pow_rand] = globalShuffling(spike_time,2,1,1);
end %the compensation
[comp,conf] = compens(freq,pow,freq_rand,pow_rand,2,1,2);

return
