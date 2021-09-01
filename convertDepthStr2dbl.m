%Load Data
clearvars

allFiles = dir('*.mat')
fileNames = {allFiles.name}

for mi = 1:length(fileNames)
    %load file
     tmpfileNames = fileNames{mi};
     
     load(tmpfileNames);
     
dataTable2 = dataTable;

for i = 1:height(dataTable2)
    str = dataTable2{i,1};
    str = str{1};
    tmpstr = str(end-8:end-4);
    dblstr = str2double(tmpstr);
    if contains(str,'Blw')
        dblstr = dblstr * -1;
    end
    dataTable2.DepthNum(i) = dblstr;
    
    strEl = dataTable2{i,2};
     strEl = strEl{1};
     tmpstrEl = strEl(end);
     dblstrEl = str2double(tmpstrEl);
     dataTable2.Eldbl(i) = dblstrEl ;
end

save(tmpfileNames, 'dataTable', 'dataTable2')


%% plot Depth Vs. RMS by electrode 
close all
fig1 = figure('WindowState','maximized')
colors = {'k-','r-','b--'}
legNames = {'Electrode 1','Electrode 2','Electrode 3'}

for i = 1:3
elecNum = dataTable2.Eldbl
idx = elecNum == i
elecRMS = dataTable2.RMS(idx)
depthElec = dataTable2.DepthNum(idx)

plot(depthElec,elecRMS,colors{i})
%plot Electrode 1 Vs. depth of eletrode 1
set(gca,'xdir','reverse','FontSize',14)
%reverse x-axis
hold on 
end 

legend(legNames)

xlabel('depth (um)')
ylabel('RMS voltage (mV?)')
title(['Depth Vs. RMS voltage (' tmpfileNames(1:end-4) ')'],'FontSize',18,...
       'Interpreter','none')
%Add legend and labels to figure

saveas(fig1, [tmpfileNames(1:end-4) '.png'])
end
