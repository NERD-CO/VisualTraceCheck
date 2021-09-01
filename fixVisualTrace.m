sL = cellfun(@(x) length(x) ~= 1, DepthIND, 'UniformOutput', true);

%%

DepthIND{46} = [0;0;0];
%%

DepthIND = DepthIND(1:32);
%%

DepthID = DepthID(1:32);
%%

DepthIND = cellfun(@(x) x(1:3), DepthIND, 'UniformOutput', false);
%%

save('VC_02_08_2017_1_s1.mat','DepthID','DepthIND','CaseNum','fedTable')
%%

clear


%%

mfF = dir('*.mat');
mfFn = {mfF.name};

%%

for m = 43:length(mfFn)
    
    load(mfFn{m});
    
    emptyID = ~cellfun(@(x) isempty(x), DepthID , 'UniformOutput', true);
    
    DepthIND = DepthIND(emptyID);
    DepthID = DepthID(emptyID);
    
    DepthIND = cellfun(@(x) x(1:3), DepthIND, 'UniformOutput', false);
    
    save(mfFn{m},'DepthID','DepthIND','CaseNum','fedTable')
    
    clear 'DepthID' 'DepthIND' 'CaseNum' 'fedTable'
    
end




%%

for m = 45:53
    
    oldname = mfFn{m};
    newname = oldname(1:22);
    
    movefile(oldname,newname)
    
end