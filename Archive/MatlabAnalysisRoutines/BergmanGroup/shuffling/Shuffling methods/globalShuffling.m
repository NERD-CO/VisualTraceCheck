% Writen by: Michal Rivlin.
% Last updated: 12.4.2005

% Uses the psd Matlab function to calculate the power spectral density of a
% given spike train. 
% sp is a vector containing the times of the spike occurences
% a,b,c are integers for plotting the results in the given subplot. 
% The function calls plotPower function that plots the results.
function [freq,pow,freq_rand,pow_rand] = globalShuffling(sp,a,b,c)

global NFFT NUM_RAND DT DF 

len=sp(end)-sp(1)+1;
train=zeros(1,len);
train(sp-sp(1)+1)=1;

% Calculate the psd on the spike train
hann = hanning(NFFT);     
[pow,freq] = psd(train-mean(train),NFFT,1/DT,hann);

% Calculate the psd on a globaly shuffled spike train with the same ISI
% This calculation will be done NUM_RAND times to constract a confidence level
isi=diff(sp);
isi=isi(isi>0); %if DT is not small enough, we might get 2 spikes in the same bin
all_pow_rand=zeros(NUM_RAND,length(freq));
for i=1:NUM_RAND
    r=randperm(length(isi));
    rand_isi(r)=isi;
    y=cumsum(rand_isi);
    rand_train=zeros(1,length(train));
    rand_train([1 y+1])=1; 
    [pow_rand,freq_rand] = psd(rand_train-mean(rand_train),NFFT,1/DT,hann);
    all_pow_rand(i,:)=pow_rand';
end
if(NUM_RAND>1)
    pow_rand = mean(all_pow_rand);
end

% Plots the power spectrum of the original spike train, and the mean 
% power spectrum of the shuffled trains
PlotPower(freq,pow,freq_rand,pow_rand,a,b,c)

return
