function  [] = GOdist_create_hist(expname,data_dir,ontology,GOterm,log_value);

[params paramnames]=create_parameters(data_dir,expname);
%we do not use GENE_ID here, but other functions that call
%get_all_genes_with_term, do
[GENE_ID rel_ung log_ratios ]= GOdist_get_all_genes_with_term(expname,data_dir,params,paramnames,GOterm,ontology);

log_base = 2;
if (log_value==10) 
    log_base = 10;
    log_ratios = log_ratios/log2(10);
end

delta =100; 
size = length(log_ratios);

[Na,Xa]=hist(log_ratios,delta);
size = length(log_ratios);
one_per = size/100;

%if (Y_indicator=='percent') 
  %  Na = 100*Na/size; 
   % y_name = 'percent of transcripts';
%else 
  %  Na=Na/delta;
   % y_name = 'N';
%end
 
Na=Na/delta;
y_name = 'N';


switch(ontology) 
    case 'bp'
        terms_fname = [data_dir filesep 'GO_bp_terms.mat'];
    case 'mf' 
        terms_fname = [data_dir filesep 'GO_mf_terms.mat'];
    case 'cc'
        terms_fname = [data_dir filesep 'GO_cc_terms.mat'];
end; 
load(terms_fname); % A file of all terms and names
term_index = find(ALL_TERMS==GOterm);
term_name  = [num2str(GOterm) '  ' ALL_NAMES{term_index}];
slashes = findstr('\',term_name); % the legend cannot deal with these slashes without a warning
term_name(slashes) = '-';
%term_name = ALL_NAMES{term_index};

%termlegend = GOterm+'-'+ term_name;

figure;
S1 = bar(Xa,Na);
%set(S1,'color','b');

xlabel(['log' num2str(log_base) ' fold ratio'] );
ylabel(y_name);
%title(['effect of experiment (log' num2str(log_base) ' of expression ratio)'] );
title('effect of experiment');
legend(term_name);

