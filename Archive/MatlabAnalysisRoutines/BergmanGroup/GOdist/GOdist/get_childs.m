function [childs] = get_childs(TERM,P);

% Get a list of all children term of given parent matrix


[I J] = find(P(:,2:end) == TERM);
UI = unique(I);
childs = sort(P(UI,1));

return

