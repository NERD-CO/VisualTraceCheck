function [child_IDs,parent_IDs,child_names,parent_names] = GOdist_get_parent_GO(infile,term,ontology,GETNAMES,wbH);



% Get the file and the top node for the selected ontology path
switch ontology
    case 'cc'
        TOP_ID = 5575; % This is for the cellular component   
        onto_str = 'Cellular Component';
    case 'mf'
        TOP_ID = 3674; 
        onto_str = 'Molecular Function';
    case 'bp'
        TOP_ID = 8150; 
        onto_str = 'Biological Process';
end


waitbar(0.4,wbH,['Reading ' onto_str ' ontology file']);

% Read the ontology file
S = readtext(infile);

% Get all lines where this term occurs as a first term
lines = [];
for Li = 1:length(S)
    [ID,name] = get_first_GO_in_line(S{Li},GETNAMES);
    if ID == term
        child_IDs(1) = ID;
        if GETNAMES
            child_names{1} = name;
        end        
        lines = [lines Li];
    end
end

% Get all parent terms of this term
PC = 1;
if  ~(term  == TOP_ID)
    for k = 1:length(lines)
        currentline = lines(k);
        while 1
            [parent_IDs(PC),currentline,parent_names{PC}] = get_parent(S,currentline,GETNAMES);        
            if parent_IDs(PC) == TOP_ID;  parent_IDs(PC) = []; parent_names(PC) = [] ;break; end
            PC = PC+1;
        end
    end
end

waitbar(0.8,wbH,['Getting ' onto_str ' ontology children']);
% Get all child terms
CC = 2; % A counter over all child terms
for k = 1:length(lines)
    CCi = 1; % A counter of child terms of this instance of the term
    currentline = lines(k); 
    LeadS = Nspaces(S{currentline});
    while 1
        if currentline+CCi <= length(S) % We need this because we may get beyond the last line otherwise
            downLeadS = Nspaces(S{currentline+CCi});
            if downLeadS > LeadS                
                [child_IDs(CC),child_names{CC}] = get_first_GO_in_line(S{currentline+CCi},GETNAMES);
                CC= CC+1;  CCi= CCi+1;
            else
                break;
            end
        else
            break % Because we reached the end
        end
    end
end


% Make the list unique
if exist('parent_IDs')
    [parent_IDs,ord] = unique(parent_IDs);
    if GETNAMES
        parent_names = parent_names(ord);
    else
        parent_names = [];
    end
else
    parent_IDs = [];
    parent_names = [];        
end
if exist('child_IDs')
    [child_IDs,ord] = unique(child_IDs);
    if GETNAMES
        child_names = child_names(ord);        
    else
        child_names = [];
    end
else
    child_IDs = [];
    child_names = [];        
end


return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  [node,nextcurrentline,name] = get_parent(S,currentline,GETNAMES);
% get immediate parent of a term and return  it and the line containing it
% as well
LeadS = Nspaces(S{currentline});
% Now start going up until we reach a line with a smaller number of spaces
ui = 1;
if  ~LeadS  % This can only occur if this is the uppermost term
    [node name] = get_first_GO_in_line(S{currentline(2:end)},GETNAMES);
    nextcurrentline = [];
    return
end
while 1
    upLeadS = Nspaces(S{currentline-ui});
    if upLeadS < LeadS
        break
    else
        ui = ui + 1;
    end
end
[node name ] = get_first_GO_in_line(S{currentline-ui},GETNAMES);
nextcurrentline = currentline-ui;
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ID,name] = get_first_GO_in_line(L,GETNAMES);
name = [];
GO_ind = min(findstr(' GO',L));  
ID = str2num(L(GO_ind+4:GO_ind+10));
if GETNAMES
    if ~isempty(GO_ind)
        % A line must begin with either % or < - it is the first symbol
        % which is relevant for the first GO term
        starti1 = findstr('%',L);
        starti2 = findstr('<',L);
        starti3 = findstr('$',L);
        starti = min([starti1 starti2 starti3]);
        name = L(starti+1:GO_ind-2);
    end
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function LeadS = Nspaces(L)
space_inds = findstr(' ',L);
% Find the last consecutive space
for i = 1:length(space_inds)
    if space_inds(i) == i
    else
        break
    end
end
LeadS = i-1;
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%