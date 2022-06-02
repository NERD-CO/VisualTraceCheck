function [] = OSort_path_setUP_css(mainLOC)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


if nargin == 0
    useLoc = uigetdir();
else
    useLoc = mainLOC;
end

cd(useLoc)
% check for .ncs files
[ncCk , mesAge] = NSCcheck(useLoc);


if ~ncCk
    disp(mesAge)
    return
else
    disp(mesAge)
end

dataFold = [useLoc , filesep , 'rawDemo'];


if ~exist(dataFold,'dir')

    mkdir(dataFold)
    nscDir = dir('*.ncs');
    nscDirn = {nscDir.name};

    for ni = 1:length(nscDirn)
        olddir = [useLoc , filesep , nscDirn{ni}];
        newdir = [dataFold , filesep , nscDirn{ni}];
        movefile(olddir , newdir)


    end
end




end



function [outChk , meSSage] = NSCcheck(inLOc)


cd(inLOc)
nscDir = dir('*.ncs');
nscDirn = {nscDir.name};

if isempty(nscDirn)
    outChk = false;
    meSSage = 'Folder does NOT contain NSC files';
else
    outChk = true;
    meSSage = 'Folder location set!';
end


end