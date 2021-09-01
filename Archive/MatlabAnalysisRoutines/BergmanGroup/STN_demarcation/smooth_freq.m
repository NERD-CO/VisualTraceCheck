function [smoothed_data]  = smooth_freq(raw_data, SD, n)
if nargin < 3
    n=3; %n should be 3 to get a guassian window of 3 SDs. (SD together with n define the window length)
end
if nargin <2
    SD=1; %Choose the standard deviation. The window will include "n" SDs
end
prefix(n*SD:-1:1)=1;%1 used because P is normalized
suffix(n*SD:-1:1)=1;
if size(raw_data,1)==1
    raw_data = [prefix,raw_data,suffix];
else
    raw_data = [prefix';raw_data;suffix'];
end

win=normpdf(-n*SD:n*SD,0,SD);
win = win/sum(win);

smoothed_data = filtfilt(win,1,raw_data);
smoothed_data = smoothed_data(n*SD+1:end-n*SD);