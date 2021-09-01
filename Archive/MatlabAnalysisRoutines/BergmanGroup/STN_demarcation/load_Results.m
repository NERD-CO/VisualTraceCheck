if USE_MAT, file=strcat(traj_Directory,'AOMatlab\',ResultsFile);
else file=strcat(traj_Directory,ResultsFile); end
if size(dir(file),1)==0 %if the file doesn't exist
    disp(sprintf('No %s file was found!:',ResultsFile));
    disp(file);
    return
end
load(file);
date_of_surgery=strrep(traj_Directory(findstr('\20',traj_Directory)+1:findstr('\20',traj_Directory)+10),'_','-');
traj=traj_Directory(findstr('raj',traj_Directory)-1:end-1);
