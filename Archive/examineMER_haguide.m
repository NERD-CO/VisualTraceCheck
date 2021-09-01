function [] = examineMER_haguide(folderLoc, nCode , EleNum)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% Example usage examineMER('Y:\PreProcessEphysData\03_27_2015',1);

cd(folderLoc);

fDIR = dir('*.mat');

fNames = {fDIR.name};

[~ , depO , ordNames] = getOrder(fNames);

nFnames = ordNames;

% [ordNamesT , ~] = getTimeOrder(fNames);
%
% nFnames = ordNamesT;



if nCode
    
    numSamps = 200000;
    
else
    
    numSamps = 100000;
    
end

ele1 = zeros(length(nFnames),numSamps,'double');
ele2 = zeros(length(nFnames),numSamps,'double');
ele3 = zeros(length(nFnames),numSamps,'double');
ele4 = zeros(length(nFnames),numSamps,'double');

kNkeep = false(length(nFnames),1);

for fi = 1:length(nFnames)
    
    
    tF = nFnames{fi};
    
    if strcmp(tF,'AbvTrgt_5_21092.mat')
        continue
    else
        load(tF)
    end
    
    if exist('CElectrode1','var')
        
        noC = 0;
        
        if length(CElectrode1) < numSamps
            continue
        else
            
            kNkeep(fi) = true;
            
            ele1(fi,:) = double(CElectrode1(1:numSamps));
            ele2(fi,:) = double(CElectrode2(1:numSamps));
            ele3(fi,:) = double(CElectrode3(1:numSamps));
        end
        
    else
        
        noC = 1;
        
        if length(CSPK_01) < numSamps
            continue
        else
            
            if mean(abs(CSPK_01)) > 100
                continue
            else
                
                kNkeep(fi) = true;
                
                ele1(fi,:) = CSPK_01(1:numSamps);
%                 ele2(fi,:) = CSPK_02(1:numSamps);
                %                 ele3(fi,:) = CSPK_03(1:numSamps);
                
                if exist('CSPK_02','var')
                    ele2(fi,:) = CSPK_02(1:numSamps);
                end
                
                if exist('CSPK_03','var')
                    ele3(fi,:) = CSPK_03(1:numSamps);
                end
                
                if exist('CSPK_04','var')
                    ele4(fi,:) = CSPK_04(1:numSamps);
                end
                
            end
        end
        
        
    end
    
end




switch EleNum
    case 1
        plotFUN(ele1, 1, depO, noC, kNkeep)
    case 2
        plotFUN(ele2, 2, depO, noC, kNkeep)
    case 3
        plotFUN(ele3, 3, depO, noC, kNkeep)
    case 4
        plotFUN(ele4, 4, depO, noC, kNkeep)
end






end



function [order , depO , ordNames] = getOrder(names)


strparts = cellfun(@(x) strsplit(x,{'_','.'}), names, 'UniformOutput',false) ;
strAB = cellfun(@(x) x{1}(1), strparts, 'UniformOutput',false);
strNum = cell2mat(cellfun(@(x) str2double(x{2}), strparts, 'UniformOutput', false));


aNames = cellfun(@(x) strcmp(x,'A'), strAB);
[~ , aOrd] = sort(strNum(aNames));

aNamesAct = names(aNames);
aNamesAct = aNamesAct(aOrd);

bNames = ~aNames;
[~ , bOrd] = sort(strNum(bNames));

bNamesAct = names(bNames);
bNamesAct = bNamesAct(bOrd);

adepths = cellfun(@(x) x{3}, strparts(aNames), 'UniformOutput',false);
bdepths = cellfun(@(x) x{3}, strparts(~aNames), 'UniformOutput',false);
bdepths = cellfun(@(x) ['-',x], bdepths, 'UniformOutput',false);

order = [aOrd , bOrd];

depO = [adepths(aOrd) , bdepths(bOrd)];
ordNames = [aNamesAct , bNamesAct];



end


function [] = plotFUN(electrode, num, depYvals, noC, kVec)

electrode = electrode(kVec,:);
depYvals = depYvals(kVec);


numDeps = size(electrode,1);
i = numDeps - 1;
i2 = 1;
while i > 0
    
    if noC
        
        electrode(i,:) = electrode(i,:) + (100*i2);
        
    else
        
        electrode(i,:) = electrode(i,:) + (5000*i2);
    end
    
    
    i = i - 1;
    i2 = i2 + 1;
end

xAxis = repmat(1:length(electrode),numDeps,1);

colors = 'rgbk';

figure;
for i = 1:numDeps
    
    plot(xAxis(i,:),electrode(i,:),colors(num))
    hold on
    
end

% oldY = get(gca,'YTick');

% newY = linspace(min(oldY),max(oldY),size(electrode,1));

yTs = mean(electrode,2);
fud = sort(yTs,'ascend');

set(gca,'YTick',fud);
set(gca,'YTickLabel',fliplr(depYvals));
ylim([min(yTs) max(yTs)])
set(gca,'XTick',[]);



end


function [ordNames , startTimes] = getTimeOrder(names)

staTime = zeros(length(names),1);
for fi = 1:length(names)
    
    tf = names{fi};
    
    load(tf);
    
    staTime(fi) = mer.timeStart;
    
    fprintf('Depth %d out of %d depths Done! \n', fi, length(names));
    
end

[startTimes, timeOrder] = sort(staTime);

ordNames = names(timeOrder);


end

