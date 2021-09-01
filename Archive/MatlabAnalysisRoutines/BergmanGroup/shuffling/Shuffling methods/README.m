% Writen by: Michal Rivlin.
% Last updated: 12.4.2005

% README first:

% The folder contains Matlab programs that use the ISI shuffling method in
% order to compute a confidence level to the power spectral density (PSD) and 
% the cross spectral density (CSD). Periodic oscillations can be detected
% based on that confidence level.
% NOTE: The local shuffling is a heavy program to run, be patient.

% For PSD:
% Run the fuction runPSD(spike_time,dt,local,num_rand).
% The input parameters are:
%
% spike_time:  A vector containing the bins in wich a spike has occured.
%                           spike_time(i)=number of bin in which the ith
%                           spike has occured.
%
% dt:                    The time resolution in spike_time. 
%                           For example, dt=0.001 if the sampling rate is 1 KHz.
%
% local:            If local>0, a local shuffling is done, and the segments' length are
%                          distributed uniformly: U(local,local+50). 
%                          Otherwise, for local=0, a global shuffling is done.
%                          For example, local=175.
%
% num_rand:     The number of repetitions of the random shuffling.             
%                          For example, num_rand=10.
%
% Change runPSD:
% If you want to change the nfft (NFFT) that is used in the FFT computations,
% the p value (P_VAL) of the confidence level,
% or the percent of the high frequencies (CONF_PERCENT) based on which 
% the mean and std are computed in order to construct the confidence level.
%
% The function runPSD calls localShuffling function or the globalShuffling
% function, depend on the input parameter 'local'. In those functions the
% original PSD is calculated, and the shuffling is done NUM_RAND times.
% Both functions call figPSD function to plot the original PSD (black) 
% and the shuffled PSD (RED).
% Then the function runPSD calls the compence function in order to compute
% the compensation term. The result is also plotted, including a confidence
% level which is based on last CONF_PERCENT percent and its p value is
% P_VAL.
%
% The output parameters are:
%
% comp:  The vector of the compensation term.
%
% freq:  The vector of the frequencies of the compensated term.
%
% conf:  The value of the confidence level for the compensated term.

% For CSD:
% Run the fuction runCSD(spike_timeA,spike_timeB,dt,num_rand).
% The input parameters are:
%
% spike_timeA:  A vector containing the bins in wich a spike has occured in neuron A.
%                             spike_time(i)=number of bin in which the ith spike has occured.
%
% spike_timeB:  A vector containing the bins in wich a spike has occured in neuron B.
%                             spike_time(i)=number of bin in which the ith spike has occured.
%
% dt:                      The time resolution in both spike_timeA and spike_timeB (should be the same). 
%                             For example, dt=0.001 if the sampling rate is 1 KHz.
%
% num_rand:        The number of repetitions of the random shuffling.
%
% Change runCSD:
% If you want to change the nfft (NFFT) that is used in the FFT computations,
% the p value (P_VAL) of the confidence level,
% or the percent of the high frequencies (CONF_PERCENT) based on which 
% the mean and std are computed in order to construct the confidence level.
%
% The function runCSD calls the checkCouple function that cuts the two spike
% trains to contain only the time that is common to both spike trains.
% Then checkCouple function calls crossConf where the original CSD is 
% calculated and the actual shuffling of both spike trains is done NUM_RAND times.
% The figPSD function is called from crossConf to plot the original CSD (black) 
% and the shuffled CSD (RED).
% After that  checkCouple calls the compense function in order to compute
% the compensation term. The result is also plotted, including a confidence
% level which is based on last CONF_PERCENT percent and its p value is
% P_VAL.
%
% The output parameters are:
%
% comp:  The vector of the compensation term.
%
% freq:  The vector of the frequencies of the compensated term.
%
% conf:  The value of the confidence level for the compensated term.
