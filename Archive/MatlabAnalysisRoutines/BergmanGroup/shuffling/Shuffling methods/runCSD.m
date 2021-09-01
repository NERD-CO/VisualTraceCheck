% Writen by: Michal Rivlin.
% Last updated: 12.4.2005

% Computes the CSD and finds a confidence level based on the ISI global 
% shuffling method.
% spike_timeA: A vector containing the bins in wich a spike has occured.
% spike_timeA(i)=number of bin in which the ith spike of neuron A has occured.
% spike_timeB: A vector containing the bins in wich a spike has occured.
% spike_timeB(i)=number of bin in which the ith spike of neuron B has occured.
% dt: The time resolution in spike_time.
% num_rand: The number of repetitions on the shuffling process.
function [comp,freq,conf] = runCSD(spike_timeA,spike_timeB,dt,num_rand)

global NFFT NUM_RAND DT P_VAL CONF_PERCENT

% NFFT:
% Determines the window length to calculate the psd. For a ~0.25 Hz resolution, take NFFT=4096.
NFFT=4096;

% NUM_RAND:
% Determines the number of repetitions done to calculate the confidence interval. 
NUM_RAND=num_rand;

%P_VAL:
% Determines the p value.
P_VAL=0.01; 

%CONF_PERCENT:
% The confidence level is established based on the last CONF_PERCENT percent
CONF_PERCENT=10; 

% DT
% The time resolution in spike_time
DT=dt;

figure;
[comp,freq,conf] = checkCouple(spike_timeA,spike_timeB,2,1,[1 2]);

return

