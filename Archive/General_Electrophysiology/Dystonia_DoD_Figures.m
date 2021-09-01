

%% GPe Neuron

% File location
cd('Y:\AlphaOmegaMatlabData\08_07_2014_1')

% load data
load('16006.mat')

% Get first GPe cell
spikeData = CElectrode1;
sampleRate = CElectrode1_KHz;

%% Seconds recorded
sR = sampleRate*1000;

% Time Axes
timeAxisLONG = linspace(0,length(spikeData)/(sR),length(spikeData));
shortAXISind = timeAxisLONG <= 5;
timeAxisSHORT = timeAxisLONG(timeAxisLONG <= 5);

%% TEST PLOT

plot(timeAxisSHORT,spikeData(shortAXISind))


%% For figure plot

startIndex = find(timeAxisLONG >= 2,1,'first');
endIndex = find(timeAxisLONG <= 3,1,'last');

plot(timeAxisLONG(startIndex:endIndex),spikeData(startIndex:endIndex))



%% GPi Neuron
clear all; close all;

% load data
load('07213.mat')

% Get first GPi cell
spikeData = CElectrode2;
sampleRate = CElectrode2_KHz;

%% Seconds recorded
sR = sampleRate*1000;

% Time Axes
timeAxisLONG = linspace(0,length(spikeData)/(sR),length(spikeData));
shortAXISind = timeAxisLONG <= 5;
timeAxisSHORT = timeAxisLONG(timeAxisLONG <= 5);

%% TEST PLOT

plot(timeAxisSHORT,spikeData(shortAXISind))

%% For figure plot

startIndex = find(timeAxisLONG >= 0.5,1,'first');
endIndex = find(timeAxisLONG <= 1.5,1,'last');

plot(timeAxisLONG(startIndex:endIndex),spikeData(startIndex:endIndex))






