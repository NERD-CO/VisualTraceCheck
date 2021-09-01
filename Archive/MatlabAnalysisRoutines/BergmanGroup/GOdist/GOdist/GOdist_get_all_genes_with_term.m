%function lilach_get_all_genes_with_term(params,paramnames,term,ontology)
%function [GENE_ID rel_UNG log_ratios name] = GOdist_get_all_genes_with_term(expname,data_dir,params,paramnames,term,ontology);
function [GENE_ID  rel_UNG log_ratios] = GOdist_get_all_genes_with_term(expname,data_dir,params,paramnames,term,ontology);

UNIGENES = get_param_values('UNIGENES',paramnames,params);
GENE_ID   = get_param_values('GENE_ID',paramnames,params);
%SYMBOLS   = get_param_values('SYMBOLS',paramnames,params);
AFFY_NUM   = get_param_values('AFFY_NUM',paramnames,params);

log2_EXP_VALUES = get_param_values('data',paramnames,params);

% Now we have to look for all the genes which contain this term or any of
% its child terms
switch ontology
   case 'cc'
       annotfilename = [data_dir filesep expname '_annot_CC.mat'];  
       child_parentfilename=  [data_dir filesep 'GO_CC_child_parent_mtx.mat'];  
       terms_fname = [data_dir filesep 'GO_cc_terms.mat'];  
    case 'bp'
       annotfilename = [data_dir filesep expname '_annot_BP.mat'];  
       child_parentfilename=  [data_dir filesep 'GO_BP_child_parent_mtx.mat']; 
       terms_fname = [data_dir filesep 'GO_bp_terms.mat'];  
    case 'mf'
%        filesep enters '\'
        annotfilename = [data_dir filesep expname '_annot_mf.mat'];  
       %  e =  exist(annotfilename);
        child_parentfilename=  [data_dir filesep 'GO_MF_child_parent_mtx.mat'];  
        terms_fname = [data_dir filesep 'GO_mf_terms.mat'];  
end

%load files
load (annotfilename);
load ( child_parentfilename);
load (terms_fname);

term_index = find(ALL_TERMS == term);
if isempty(term_index)
    errordlg([num2str(term) ' is not a member of the ' ontology ' ontology!'],'GOdist');
    return
end
    
name = ALL_NAMES{term_index};
%AFFY_NUM=cell2mat(AFFY_NUM);
% Get a list of all children
relinds = get_term_inds(term,P,AI,AFFY_NUM);

%if isempty(relinds)
  %  errordlg([num2str(term) ' does not contain any genes ' ,'GOdist');
   % return
%end

rel_UNG = UNIGENES(relinds);
GENE_ID = GENE_ID(relinds);
AFFY_NUM = AFFY_NUM(relinds);
log2_EXP_VALUES_term=log2_EXP_VALUES(relinds);

% Make a sorted list of relevant indices
[rel_UNG SO] = sort(rel_UNG);
relinds = relinds(SO);
GENE_ID = GENE_ID(SO);
AFFY_NUM = AFFY_NUM(SO);
log_ratios = log2_EXP_VALUES_term(SO);


%L = [length(log2_EXP_VALUES_term1) ,length(log2_EXP_VALUES_term2) , length(log2_EXP_VALUES_term3) ];

% Nice idea, but is not conviniently written to file
% % Build a list of GO terms for this gene
% for i = 1:length(AFFY_NUM)
%     thisnum = AFFY_NUM(i);
%     inds = find(AI(:,1) == thisnum);
%     for k = 1:length(inds)
%         thisind = find(ALL_TERMS == AI(inds(k),2));
%         thisterm = ALL_NAMES{thisind};
%         probe_terms{i,k} = thisterm;
%     end
% end

return
