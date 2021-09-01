%Main Dir
MainDir = 'Z:\Crane_Summer2020\SummaryData\RMS_summary';


clearvars
%Conditionals plotting sections
% If you need to change the processed dataTable(dataTable2), change
% saveTables = 1
saveTables = 0;
plotLine = 1;
saveLine = 0;
plotBarThirds = 0;
saveBarThirds = 0;
plotSplitelecBarThirds = 1;
saveSplitelecBarThirds = 1;


%Load Data
allFiles = dir('*.mat');
fileNames = {allFiles.name};

% mi = 64 - 12_08_2016 - depth 1, e3; depth 2&3, e1 e2 e3
% mi = 52 - 10_16_2015 - depth 1, e1 e2; depth 2&3, e1 e2
% mi = 66 - 12_19_2013 - all 3 at all depths

for mi = 1:length(fileNames)
    close all
    %load file
    tmpfileNames = fileNames{mi};
    load(tmpfileNames);
    
    if saveTables == 1
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
    end
    
    %% plot Depth Vs. RMS by electrode
    if plotLine == 1
        
        close all
        fig1 = figure;
        colors = {'k-','r-','b--'};
        legNames = {'Electrode 1','Electrode 2','Electrode 3'};
        
        for i = 1:3
            elecNum = dataTable2.Eldbl;
            idx = elecNum == i;
            elecRMS = dataTable2.RMS(idx);
            depthElec = dataTable2.DepthNum(idx);
            
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
        
        if saveLine == 1
            saveas(fig1, [tmpfileNames(1:end-4) '.png'])
        end
        
        %%%Get y limits to have bar and line plots have same Y axis limits
        ax = gca;
        lineYlims = ax.YLim;
        %%%
    end
    
    %% split depths into thirds; plot thirds
    if plotBarThirds == 1
        fig2 = figure;
        
        elecNum = dataTable2.Eldbl;
        RMSfull = dataTable2.RMS;
        depthfull = dataTable2.DepthNum;
        all3rdidx = find3rds(depthfull);
        top3rdidx = all3rdidx(:,1);
        mid3rdidx = all3rdidx(:,2);
        btm3rdidx = all3rdidx(:,3);
        % ^ variables to index into depth and RMS vectors
        
        
        
        for thirdloop = 1:3
            depthNum = depthfull(all3rdidx(:,thirdloop));
            meanDepth = mean(depthNum);
            RMSNum = RMSfull(all3rdidx(:,thirdloop));
            meanRMS = mean(RMSNum);
            stdRMS = std(RMSNum);
            bar(thirdloop,meanRMS);
            hold on;
            
            er = errorbar(thirdloop,meanRMS,stdRMS,'CapSize',25);
            er.Color = [0 0 0];
            er.LineStyle = 'none';
            er.LineWidth = 1;
            
        end
        
        ylabel('RMS voltage (mV?)')
        xticks([1 2 3])
        xticklabels({'Top3rd', 'Mid3rd', 'Btm3rd'})
        title(['RMS (all electrodes averaged) Vs. Depth by third (' tmpfileNames(1:end-4) ')'],...
            'FontSize',11,'Interpreter','none')
        
        if saveBarThirds == 1
            saveas(fig2, [tmpfileNames(1:end-4) ' by thirds.png'])
        end
        
    end
    
    %% split into 1/3 by electrode
    if plotSplitelecBarThirds == 1
        close all
        fig3 = figure;
        
        
        elecNum = dataTable2.Eldbl;
        RMSfull = dataTable2.RMS;
        depthfull = dataTable2.DepthNum;
        AbbreviatedDbl = [elecNum,RMSfull,depthfull];
        all3rdidx = find3rds(depthfull);
        top3rdidx = all3rdidx(:,1);
        mid3rdidx = all3rdidx(:,2);
        btm3rdidx = all3rdidx(:,3);
        % ^ variables to index into depth and RMS vectors
        
        depthByElec = zeros(3,3);
        depthByElecSTD = zeros(3,3);
        
        for thirdloop = 1:3
            depthNum = depthfull(all3rdidx(:,thirdloop));
            thirdElecNum = elecNum(all3rdidx(:,thirdloop));
            % meanDepth = mean(depthNum)
            RMSNum = RMSfull(all3rdidx(:,thirdloop));
            meanRMS = mean(RMSNum);
            
            for electrodeloopi = 1:3
                idx2 = thirdElecNum == electrodeloopi;
                depth_elec = depthNum(idx2);
                meandepth_elec = mean(depth_elec);
                RMS_elec = RMSNum(idx2);
                meanRMS_elec = mean(RMS_elec);
                stdRMS_elec = std(RMS_elec);
                depthByElec(thirdloop,electrodeloopi) = meanRMS_elec;
                depthByElecSTD(thirdloop,electrodeloopi) = stdRMS_elec;
            end
        end
        
        % ['depthByElec = ...'
        %             'top  e1 e2 e3'
        %             'mid  e1 e2 e3'
        %             'btm  e1 e2 e3']
        
        %bar(depthByElec)
        %hold on;
        
        er = errorbar_groups(depthByElec',depthByElecSTD','FigID',fig3);
        
        ylabel('RMS voltage (mV?)')
        ylim(lineYlims);
        xticks(1:9)
        xticklabels({'','Top3rd','', '','Mid3rd','','', 'Btm3rd',''})
        
        if saveSplitelecBarThirds == 1
            saveas(fig3, [tmpfileNames(1:end-4) ' by electrode by thirds.png'])
        end
        
    end
    %% normalize by electrode
    
    
    
    
    %% Compare first & Second surgery by patient
end


%% local functions
function out = find3rds(in)
% this takes a vector of depths as input and outputs a Nx3 array with the
% top third in first column, mid third in 2nd col, etc, where N is the
% length of input vector

depthMax = max(in);
depthMin = min(in);
depthRng = depthMax - depthMin;
thirdSize = depthRng/3;

thirdBounds = [depthMax, depthMax - thirdSize,...
    depthMax - 2*thirdSize, depthMax - 3*thirdSize];
out = zeros(length(in),3);
for i = 1:3
    this3rd = [thirdBounds(i), thirdBounds(i+1)];
    i1 = in <= this3rd(1);
    i2 = in > this3rd(2);
    if i == 3
        i2 = in >= this3rd(2); % this makes sure that min value is included
    end
    out(:,i) = i1 & i2;
end
out = logical(out);
end

