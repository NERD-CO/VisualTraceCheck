function relinds = get_term_inds(term,P,AI,gene_ids);
% Get indices of all genes containing this term or its children

% Get the list of all child terms (including term) from the C (children) matrix
[child_nums] = get_childs(term,P);
child_nums = union(child_nums,term);

% Find all the genes which contain this term or any of its child terms
relinds = [];
for i = 1:length(child_nums)
    tmpind = find(AI(:,2) == child_nums(i));
    relinds = [relinds ; tmpind];
end
rel_genes = AI(relinds,1); % The ID of these genes
rel_genes = unique(rel_genes);

% Get the positions of these genes in the ID list
relinds = [];
for i = 1:length(rel_genes)
    tmpind = find(gene_ids == rel_genes(i));
    if ~isempty(tmpind)
        relinds = [relinds  tmpind];
    end
end