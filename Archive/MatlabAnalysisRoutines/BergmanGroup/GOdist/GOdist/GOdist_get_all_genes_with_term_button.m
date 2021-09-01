function  [] = GOdist_get_all_genes_with_term_button(expname,outfile,datadir,ontology,GOterm);

[params paramnames]=create_parameters(datadir,expname);

[GENE_ID unigene log_ratios]= GOdist_get_all_genes_with_term(expname,datadir,params,paramnames,GOterm,ontology);

%name = int2str(GOterm);
%outfile = [datadir filesep expname '_' ontology '_' name '_genes_list.xls'];

fid = fopen(outfile,'w');
fprintf(fid,'%s\t%s\t%s\t\n','prob','unigene','log2 ratio');        
for i = 1:size(GENE_ID,2)
   % fprintf(fid,'%2.3f\t%2.3f\t \n',GENE_ID{i},log2_EXP_VALUES{i});
   % fprintf(fid,'%s\t%2.0f\t%2.5f\t%2.5f\t%2.5f\t%2.5f\t%2.0f\t%2.0f\t\n',
   % name,term,Pks_larger,incP,Pks_smaller,decP,CS,KSstat);        
   %GENE_ID is a cell of strings, while log_ratios is a double array
  
   fprintf(fid,'%s\t%s\t%0.4f\n',GENE_ID{i},unigene{i},log_ratios(i));
end
fclose(fid);

msgbox('Done!','GOdist');