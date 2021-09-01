%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%to smooth and log the PSD for spectrogram

%currently for distance spectrogram I smooth, but for time spectrogram I
%don't - this may beed to be reassed??

function [X] = PSDsmoothLog(X,F,DO_SMOOTH);
%if nargin <3, DO_SMOOTH=1; end
X(:,F>10 & (mod(F,50)<2.5 | mod(F,50)>47.5))=mean(mean(X));%1;
%X(:,F>10 & (mod(F,177.5)<2.5 | mod(F,177.5)>175))=1; %due to some artifacts in pre-STN (maybe limit to onlt the relevant?)
if DO_SMOOTH
    for i=1:size(X,1), X(i,:)=smooth_freq(X(i,:),1); end
end
X=10*log10(abs(X));
TF=isnan(X);
X=max(X,-6);
X(TF)=NaN;
