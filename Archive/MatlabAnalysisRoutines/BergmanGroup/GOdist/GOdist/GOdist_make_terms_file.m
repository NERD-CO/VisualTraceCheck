function GOdist_make_term_files(infile,outfile,ontology,wbH);

% Make files including the list of terms and their names, used by the
% various GO analysis functions

switch ontology
    case 'cc'       
        [ALL_TERMS,tmp,ALL_NAMES,tmp] = GOdist_get_parent_GO(infile,5575,'cc',1,wbH);
        save(outfile,'ALL_NAMES','ALL_TERMS');
    case 'mf'        
        [ALL_TERMS,tmp,ALL_NAMES,tmp] = GOdist_get_parent_GO(infile,3674,'mf',1,wbH);
        save(outfile,'ALL_NAMES','ALL_TERMS');
    case 'bp'        
        [ALL_TERMS,tmp,ALL_NAMES,tmp] = GOdist_get_parent_GO(infile,8150,'bp',1,wbH);
        save(outfile,'ALL_NAMES','ALL_TERMS');
end