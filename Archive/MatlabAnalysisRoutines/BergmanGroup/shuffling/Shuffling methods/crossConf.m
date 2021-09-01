% Writen by: Michal Rivlin.
% Last updated: 12.4.2005

% Uses the csd Matlab function to calculate the cross spectral density of 2
% given spike trains. 
% spA,spB are vectors containing the times of the spike occurences
% a,b,c are integers for plotting the results in the given subplot. 
% The function calls plotPower function that plots the results.
function [freq,Pab,freq_rand,Pab_rand] = crossConf(spA,spB,len,a,b,c)

global NFFT NUM_RAND DT 

trainA=zeros(1,len);
trainB=zeros(1,len);
trainA(spA)=1;
trainB(spB)=1;

% Calculate the csd
hann = hanning(NFFT);     
[Pab,freq] = csd(trainA-mean(trainA),trainB-mean(trainB),NFFT,1/DT,hann);
Pab=abs(Pab);

% Calculate the csd while one of the spike trains is shuffled
% This calculation will be done NUM_RAND times to constract a confidence level
isiA=diff(spA);
isiA=isiA(isiA>0); %if DT is not small enough, we might get 2 spikes in the same bin
isiB=diff(spB);
isiB=isiB(isiB>0); %if DT is not small enough, we might get 2 spikes in the same bin
all_Pab_rand=zeros(NUM_RAND,length(freq));
for i=1:NUM_RAND
    % shuffling spA
    rA=randperm(length(isiA));
    rand_isiA(rA)=isiA;
    yA=cumsum(rand_isiA);
    rand_trainA=zeros(1,len);
    rand_trainA([1 yA+1])=1; 
    
    % shuffling spB
    rB=randperm(length(isiB));
    rand_isiB(rB)=isiB;
    yB=cumsum(rand_isiB);
    rand_trainB=zeros(1,len);
    rand_trainB([1 yB+1])=1; 

    % Computing the CSD of the shuffled trains
    [Pab_rand,freq_rand] = csd(rand_trainA-mean(rand_trainA),rand_trainB-mean(rand_trainB),NFFT,1/DT,hann);
    Pab_rand=abs(Pab_rand);
    all_Pab_rand(i,:)=Pab_rand';
end

% Averaging all CSDs of the shuffled trains
if (NUM_RAND>1)
    Pab_rand = mean(all_Pab_rand);
end

% Plots the cross spectrum of the original spike trains, and the mean 
% cross spectrum of the shuffled trains
PlotPower(freq,Pab,freq_rand,Pab_rand,a,b,c);

return