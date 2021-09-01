function h = plotBarStackGroupsSbplt(stackData, groupLabels, subplotdims)
%% Plot a set of stacked bars, but group them according to labels provided.
%%
%% Params: 
%%      stackData is a 3D matrix (i.e., stackData(i, j, k) => (Group, Stack, StackElement)) 
%%      groupLabels is a CELL type (i.e., { 'a', 1 , 20, 'because' };)
%%
%% Copyright 2011 Evan Bollig (bollig at scs DOT fsu ANOTHERDOT edu
%%
%% 
%% HPJ, 02-2020
% This is a custom version which uses subplot_tight instead
% Specify subplot matrix [m,n,p] when calling function
% Modify function directly to adjust subplot margins


NumGroupsPerAxis = size(stackData, 1); % Number of rows
NumStacksPerGroup = size(stackData, 2); % Number of columns
m = subplotdims(1); % Subplot number of rows
n = subplotdims(2); % Subplot number of columns
p = subplotdims(3); % Active subplot number


% Count off the number of bins
groupBins = 1:NumGroupsPerAxis;
MaxGroupWidth = .85; % Fraction of 1. If 1, then we have all bars in groups touching
groupOffset = MaxGroupWidth/NumStacksPerGroup;
%figure
    %hold on; 
for i=1:NumStacksPerGroup

    Y = squeeze(stackData(:,i,:));
    
    % Center the bars:
    
    internalPosCount = i - ((NumStacksPerGroup+1) / 2);
    
    % Offset the group draw positions:
    groupDrawPos = (internalPosCount)* groupOffset + groupBins;
    
    if i == 1; subplot_tight(m,n,p,[.12 .07]); end
    h(i,:) = bar(Y, 'stacked'); hold on;
    set(h(i,:),'BarWidth',groupOffset);
    set(h(i,:),'XData',groupDrawPos);
end
hold off;
set(gca,'XTickMode','manual');
set(gca,'XTick',1:NumGroupsPerAxis);
set(gca,'XTickLabelMode','manual');
set(gca,'XTickLabel',groupLabels);
end 
