function GOdist_make_relative_list(infile,outfile,ontology,wbH);
% Generate matrices containing all the child terms and all the parent
% terms of each term in the GO.
% P is parents, IP contains immediate parent(s)
% Each matrix contains in the first colum a list of starting nodes 
% and the rest of the line contains parent terms or immediate parent terms.
% The variables are padded with zeros when necessary.
% This function is to be run once for each onotology, and the data (P,IP) are to
% is saved under the name 
% GO_cc_child_parent_mtx - cellular component
% GO_bp_child_parent_mtx - biological process
% GO_mf_child_parent_mtx - molecular function


% Get the file and the top node for the selected ontology path
SUPER_TOP_ID = 3673; % The code for "gene ontology"
switch ontology
    case 'cc'
        onto_str = 'Cellular Component';
        TOP_ID = 5575; 
        P  = sparse(1500,30); % These are starting values and can be extended        
        IP = sparse(1500,30);
        LINES = zeros(3000,1); % Assuming each term appears twice as a first term in line
        SPACES = zeros(3000,1);
        TERMS = zeros(3000,1);
    case 'mf'
        onto_str = 'Molecular Function';
        TOP_ID = 3674; 
        P  = sparse(10000,30); % I think this is good for a start       
        IP = sparse(10000,30);
        LINES = zeros(20000,1); % Assuming each term appears twice as a first term in line
        SPACES = zeros(20000,1);
        TERMS = zeros(20000,1);
    case 'bp'
        onto_str = 'Biological Process';
        TOP_ID = 8150; 
        P  = sparse(10000,30); % I think this is good for a start        
        IP = sparse(10000,30);
        LINES= zeros(20000,1); % Assuming each term appears twice as a first term in line
        SPACES = zeros(20000,1);
        TERMS = zeros(20000,1);
end

% Read the ontology file
waitbar(0,wbH,['Reading ' onto_str ' ontology file']);
S = readtext(infile);

for Li = 1:length(S)
    id = get_first_GO_in_line(S{Li});    
    if ~isempty(id)
        TERMS(Li) = id;
        SPACES(Li) = Nspaces(S{Li});
    else
        TERMS(Li) = 0;
        SPACES(Li) = 0;
    end
end

LL = length(find(TERMS));
TERMS = TERMS(1:LL);
SPACES = SPACES(1:LL);

ALL_TERMS = setdiff(TERMS,TOP_ID);
ALL_TERMS = setdiff(ALL_TERMS,SUPER_TOP_ID);
ALL_TERMS = setdiff(ALL_TERMS,0);

% Run over all terms and generate the matrix
N = length(ALL_TERMS);
for K = 1:N
    term = ALL_TERMS(K);
    P(K,1)   = term;  
    IP(K,1) = term;
    rel_lines = find(TERMS == term);
    PC = 1;    IPC = 1;
    parents = [];    i_parents = [];
    
    if ~rem(K,50)
      waitbar(K/N,wbH,['Analyzing structure of ' onto_str ' ontology file']);
    end
    
    % Get all parent terms of this term  
    
    for k = 1:length(rel_lines)
        cl = rel_lines(k);
        IMMEDIATE_PARENT = 1;
        while 1
            [parents(PC),cl] = get_parent(cl,TERMS,SPACES);                
            if parents(PC) == TOP_ID;  parents(PC) = []; ;break; end
            if IMMEDIATE_PARENT % If this is the first and therefore immediate parent
                i_parents(IPC) = parents(PC);
                IPC = IPC + 1;
                IMMEDIATE_PARENT = 0;
            end                    
            PC = PC+1;
        end
    end
    
    % Make the list unique and add it to the matrix
    if ~isempty(parents)
        [parents] = unique(parents);
        P(K,2:length(parents)+1) = parents;
    end
    % Same for immediate parents category
    if ~isempty(i_parents)
        [i_parents] = unique(i_parents);
        IP(K,2:length(i_parents)+1) = i_parents;
    end    
end

% Trim the parent matrix
last_column = max(find(sum(P)));
last_line = max(find(sum(P,2)));
P = P(:,1:last_column);
P = P(1:last_line,:);

% Trim the immediate parent matrix
last_column = max(find(sum(IP)));
last_line = max(find(sum(IP,2)));
IP = IP(:,1:last_column);
IP = IP(1:last_line,:);

save(outfile,'P','IP');

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
function  [node,nextcl] = get_parent(cl,TERMS,SPACES);
% get immediate parent of a term and return  it and the line containing it
% as well
LeadS = SPACES(cl);
% Now start going up until we reach a line with a smaller number of spaces
ui = 1;
if  ~LeadS  % This can only occur if this is the uppermost term
    [node] = TERMS(cl);
    nextcl = [];
    return
end
while 1
    upLeadS = SPACES(cl-ui);
    if upLeadS < LeadS
        break
    else
        ui = ui + 1;
    end
end
[node ] = TERMS((cl-ui));
nextcl = cl-ui;
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ID] = get_first_GO_in_line(L);
GO_ind = min(findstr(' GO',L));  
ID = str2num(L(GO_ind+4:GO_ind+10));


return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function LeadS = Nspaces(L)
LeadS = 0;
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