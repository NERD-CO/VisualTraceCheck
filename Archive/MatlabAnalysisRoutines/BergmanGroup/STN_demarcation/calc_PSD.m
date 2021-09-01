function [P,w] = calc_PSD(Data,Fs,cutoff_freq,window_sec,noverlap_sec,PLOT,RECTIFY,SUBTR_MEAN,DOWN_SAMP,NORM)
global f_resolution
if nargin < 3, disp('Useage: calc_PSD(Data,Fs,cutoff_freq,*window_sec,*noverlap_sec,*PLOT,*RECTIFY,*SUBTR_MEAN,*DOWN_SAMP,*NORM)'); return, end
if nargin < 4, window_sec = 1; end
if nargin < 5, noverlap_sec = window_sec/2; end
if nargin < 6, PLOT = 0; end
if nargin < 7, RECTIFY = 1; end
if nargin < 8, SUBTR_MEAN = 1; end
if nargin < 9, DOWN_SAMP = 1; end
if nargin < 10, NORM = 1; end

if DOWN_SAMP, down=max(round(Fs/16e3),1); Data = downsample(Data,down); Fs_rect=Fs/down;
else Fs_rect=Fs; end
if RECTIFY, Data = abs(Data); end
window = floor(window_sec * Fs_rect); %window = dpss(window_sec*round(Fs_rect),4,1);
noverlap= round(noverlap_sec * Fs_rect);
nfft = round(f_resolution * Fs_rect); %resolution of 1/3 Hz. (nfft/sampling-rate = resolution)
if SUBTR_MEAN, [P,w] = my_pwelch(Data,window,noverlap,nfft,Fs_rect,'onesided'); % removed for EACH window in 'my_computeperiodogram.m'.'my_welch','my_pwelch' etc. needed to call my_compute...		
else [P,w] = pwelch(Data,window,noverlap,nfft,Fs_rect,'onesided'); end
P = P(1:cutoff_freq(2) * f_resolution+1); %reduce PSD range to [0 cutoff_freq(2)]
idx = [(cutoff_freq(1)*f_resolution+1):(cutoff_freq(2)*f_resolution+1)];%indexes to use for normalizing
idx = idx(~(((idx-1)/f_resolution)>10 & (mod((idx-1)/f_resolution,50)<2.5 | mod((idx-1)/f_resolution,50)>47.5))); %remove 50Hz artifact indexes
%idx = idx(~(((idx-1)/f_resolution)>10 & (mod((idx-1)/f_resolution,177.5)<2.5 | mod((idx-1)/f_resolution,177.5)>175))); %due to some artifacts in pre-STN (maybe limit to onlt the relevant?)
if NORM, P = (P/mean(P(idx))); end; %normalize
