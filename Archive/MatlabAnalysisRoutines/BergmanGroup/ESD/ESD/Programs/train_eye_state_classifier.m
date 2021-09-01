function [dark_threshold, dark_num] = train_eye_state_classifier(fileName, column, row)
% function [dark_threshold, dark_num] = train_eye_state_classifier_2(fileName, column, row)
% Use a picture sample and get classifier threshold (to classify a dot to black/white) and the number of black
% dots in that threshold (above - opened eye, below - closed)

TRAIN_SIZE = 100;%1;%

[eye_vec, classifier] = get_training_set(fileName,TRAIN_SIZE,column,row);

% plot classes histograms and get threshold for seperation from user
inx_open = find(classifier == true);
inx_close = find(classifier == false);
% Get probabilty histograms
all_open  = eye_vec(inx_open,:);
all_close = eye_vec(inx_close,:);
all_open_vec = reshape(all_open, 1, size(all_open,1)*size(all_open,2));
all_close_vec = reshape(all_close, 1, size(all_close,1)*size(all_close,2));
INX = 1:256;
[open_count, open_val] = hist(all_open_vec,INX);
open_prob = open_count/sum(open_count);
[close_count, close_val] = hist(all_close_vec,INX);
close_prob = close_count/sum(close_count);
% plot histograms
figure;

x_guess = find((close_count>0),1,'first')-1;

subplot(2,1,1); 
bar(open_val,open_prob);
xs=axis;
hold on
plot([x_guess x_guess],xs(3:4),'-r')
ylabel('Open eye histogram');
subplot(2,1,2); bar(close_val,close_prob);
ylabel('Close bar histogram');
% get threshold from user - this threshold determins what's white and what's black
txt = 'Click to set thrshold (Red line marks darkest point of closed eye)';
title(txt, 'FontSize', 14);
xs=axis;
hold on
plot([x_guess x_guess],xs(3:4),'-r')



theresholdOK=false;
while ~theresholdOK
    
    [x_i y button ] = ginput(1);
    if button==double(' ')
        x=x_guess;
    elseif button==1
        x=x_i;
    else
        x=NaN;
    end
        
    if x>0 && x<256
        theresholdOK=true;
    else
        txt = 'Threshold must be between 0 to 256';
        beep
        disp(txt);
    end
    %     title(txt, 'FontSize', 14);
    %     error(txt);
end

if(x<10 || x>100)
    txt = ['Threshold = ' num2str(x) ' x value might be too small or to big'];
    title(txt, 'FontSize', 14);
    beep
    disp(txt);
end
txt = ['Threshold = ' num2str(x)];
title(txt, 'FontSize', 14);
dark_threshold = round(x);

% find the open eye with minimal dark pixels
min_count =inf;
for i=1:size(all_open,1)
    curr_open = all_open(i,:);
    curr_count =length(find(curr_open < dark_threshold));
    min_count = min(min_count, curr_count);
end

% find the closed eye with maximal dark pixels
max_count =0;
for i=1:size(all_close,1)
    curr_close = all_close(i,:);
    curr_count = length(find(curr_close < dark_threshold));
    max_count = max(max_count, curr_count);
end

% This is a mistake!
% % set the number of dark to the middle between the extreme cases
% dark_num = ( min_count - max_count)/2;
% if(dark_num <0)
%     error('Can not find classifier on training set - We have not solved this case yet')
%     %     disp('Cannot set a classifier that is 100% correct on the training set. Trying the best possible');
% 
% end

%This is the right version (corrected on: 26/3/08)
% set the number of dark to the middle between the extreme cases

if (min_count - max_count <0)
    error('Can not find classifier on training set - We have not solved this case yet')
    %     disp('Cannot set a classifier that is 100% correct on the training set. Trying the best possible');
else
    dark_num = ( min_count + max_count)/2;
end



%less_than_thr_open = length(find(all_open_vec< dark_threshold));
%less_than_thr_open = less_than_thr_open/ length(inx_open);
%less_than_thr_close = length(find(all_close_vec< dark_threshold));
%less_than_thr_close = less_than_thr_close/ length(inx_close);
%dark_num = (less_than_thr_open - less_than_thr_close)/2;

return;
