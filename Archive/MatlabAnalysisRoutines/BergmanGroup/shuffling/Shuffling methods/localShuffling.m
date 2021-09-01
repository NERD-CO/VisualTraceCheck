% Writen by: Michal Rivlin.
% Last updated: 12.4.2005

% Uses the psd Matlab function to calculate the power spectral density of a
% given spike train. 
% sp is a vector containing the times of the spike occurences
% a,b,c are integers for plotting the results in the given subplot. 
% The function calls plotPower function that plots the results.
function [freq, pow, freq_rand, pow_rand] = localShuffling(sp,a,b,c)

global NFFT NUM_RAND LOCAL DT DF 

%Build the spike train.
len=sp(end)-sp(1)+1;
train=zeros(1,len);
train(sp-sp(1)+1)=1;

% Calculate the power on the spike train
hann = hanning(NFFT);     
[pow,freq] = psd(train-mean(train),NFFT,1/DT,hann);  

% Calculate the power on a localy shuffled spike train with the same ISI
% This calculation will be done NUM_RAND times to constract a confidence level
tr_shuff=zeros(1,len);
isi=diff(sp);
cum_isi=cumsum(isi);
all_pow_rand=zeros(NUM_RAND,length(freq));
for i=1:NUM_RAND
    t_beg=0; t_end=0; j=0;
    while t_end<length(isi)
        tmp = (find(cum_isi>LOCAL+50*rand));
        if (tmp)
            t_end = tmp(1);
        else
            t_end = length(isi);
        end
        tmp = shuffle(isi(t_beg+1:t_end));
        isi_shuf(t_beg+1:t_end) =tmp;
        cum_isi=cum_isi-cum_isi(t_end);
        t_beg=t_end; 
        j=j+1;
    end
    cum_isi=cumsum(isi);
    train_shuf = trainByISI(isi_shuf);
    tr_shuff=tr_shuff+train_shuf;
    [pow_rand,freq_rand] = psd(train_shuf-mean(train_shuf),NFFT,1/DT,hann);
    all_pow_rand(i,:)=pow_rand';
end

if (NUM_RAND>1)
    pow_rand = mean(all_pow_rand);
end

% Plots the power spectrum of the original spike train, and the mean 
% power spectrum of the shuffled trains
PlotPower(freq,pow,freq_rand,pow_rand,a,b,c)

return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function isi_shuf = shuffle(isi)

r=randperm(length(isi));
isi_shuf(r)=isi;

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function train = trainByISI(isi)

y=cumsum(isi);
train([1 y+1])=1;

return

