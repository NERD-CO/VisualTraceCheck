function [NAMES TERMS p_values_var]= GOdist_run_both_methods(infile,outfile,expname,datadir,ontology,thresh_method,thresh_value,wbH,p_value);
% Same as test_GO_dist but only the number of the term is reported. Also,
% all terms are written into the file, if there is nothing to say about
% them, they get a -1 -1 value as the p-values.
% 21/5/04
%lilach
%outfile1 = [datadir filesep expname '_' ontology '_NAMES.mat'];
%outfile2 = [datadir filesep expname '_' ontology '_TERMS.mat'];
%outfile3 = [datadir filesep expname '_' ontology '_Pks_smaller.mat'];
%outfile4 = [datadir filesep expname '_' ontology '_Pks_larger.mat'];
%outfile5 = [datadir filesep expname '_' ontology '_incP.mat'];
%outfile6 = [datadir filesep expname '_' ontology '_decP.mat'];
%outfile7 = [datadir filesep expname '_' ontology '_CS.mat'];
%outfile8 = [datadir filesep expname '_' ontology '_KSstat.mat'];

D = load(infile);
data = D.selected_data;
gene_ids = D.selected_ID;

N = length(data);

switch thresh_method
    case 'fixed'
        increased = (data > thresh_value);
        decreased = (data < -thresh_value);
    case 'percent'
        sortincreased = sort(data);
        sortdecreased = fliplr(sortincreased);
        CH_num = N * (100 - thresh_value)/100;
        inds = 1:N;
        CH_ind = min(find(inds > CH_num));
        increased = (data > sortincreased(CH_ind));
        decreased = (data < sortdecreased(CH_ind));
        % Error chcking
        100*sum(increased)/N
        100*sum(decreased)/N
end

TOTinc = sum(increased);
TOTdec = sum(decreased);

%lilach (15/03/05)
%TOTExpectedToChangeInArray = 
%PercentExpectedToChangeInArray= 
%end


switch ontology
    case 'cc'
        TOP_TERM = 5575;         
        GO_MTX_fname = [datadir filesep 'GO_CC_child_parent_mtx.mat'];
        GO_annotation_fname = [datadir filesep expname '_annot_cc.mat'];
        terms_fname = [datadir filesep 'GO_cc_terms.mat'];
    case 'mf'
        TOP_TERM = 3674; 
        GO_MTX_fname = [datadir filesep 'GO_MF_child_parent_mtx.mat'];
        GO_annotation_fname = [datadir filesep expname '_annot_mf.mat'];
        terms_fname = [datadir filesep 'GO_mf_terms.mat'];        
    case 'bp'
        TOP_TERM = 8150; 
        GO_MTX_fname = [datadir filesep 'GO_BP_child_parent_mtx.mat'];
        GO_annotation_fname = [datadir filesep expname '_annot_bp.mat'];
        terms_fname = [datadir filesep 'GO_bp_terms.mat'];
end

% LOAD DATA FILES
load(GO_MTX_fname)  % This file contains the variables created by [C,P,IP] = make_relative_list_matx_ver(ontology);
load(GO_annotation_fname); % This file contains the variables generated by  [AI,EC] = parse_annotation_file(ontology);
load(terms_fname); % A file of all terms and names

% Get the list of all terms and all names
%[ALL_TERMS,tmp,ALL_NAMES,tmp] = get_parent_GO(TOP_TERM,ontology,1);
TT = find(ALL_TERMS ==TOP_TERM);
ALL_TERMS(TT) = [];
ALL_NAMES(TT) = [];


fid = fopen(outfile,'w');
% The top row for the file
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n','GO NAME','GO ID','KS-P (high)','Fishex (INC)','KS-P (low)','FISHEX (DEC)','N','KS accur','% ChangedGenes','# changed genes');        

% A list of all incdices
FULLINDS = 1:length(data);     % Simply a list of all the indices which we need later for the exclusive test

NT = length(ALL_TERMS);

%p_vals_var index
i=1;

 %lilach
        %write_to_matlab_file(expname,datadir,Pks_larger,incP,Pks_smaller,decP,CS);
        
 outfile2 = [datadir filesep 'GO_p-values_thresh.mat'];

 P_values = zeros(NT,2);
 %loop on all terms
for j = 1:NT

    if ~rem(j,50)
      waitbar(j/NT,wbH,['Comparing GO terms']);
    end
     
    % The term we are now testing
    term = ALL_TERMS(j);
    name = ALL_NAMES{j};
    
    % Get relevant indices
    relinds = get_term_inds(term,P,AI,gene_ids);
    CS = length(relinds);    
    
    if CS  == 1         
        INC = sum(increased(relinds));
        DEC = sum(decreased(relinds));
        
        %lilach (15/03/05)
        TOTChanged=INC+DEC; 
        PercentChangedInTerm=  (TOTChanged/CS)*100;
        
        %lilach 23/03 to see % exptected to change
        TOTArrayChanged = TOTinc + TOTdec;
        percent_changed_in_array = (TOTArrayChanged/N)*100;
        %end 
        
        
        if INC % If we have at least one increased  
            incP = 1- hygecdf(INC,N,TOTinc,CS) +hygepdf(INC,N,TOTinc,CS) ; %P = HYGECDF(X,M,K,N)  
        else
            incP = 1;
        end
        if DEC % If we have at least one decreased  
            decP = 1- hygecdf(DEC,N,TOTdec,CS) + hygepdf(DEC,N,TOTdec,CS); %P = HYGECDF(X,M,K,N)    
        else
            decP = 1;
        end
        
        Pks_larger = 1;
        Pks_smaller = 1;
        KSstat = 0;
        
           if (Pks_larger<= p_value || incP <= p_value || Pks_smaller <= p_value || decP <= p_value ) 
        
                     % Print results to file
                 fprintf(fid,'%s\t%2.0f\t%2.5f\t%2.5f\t%2.5f\t%2.5f\t%2.0f\t%2.0f\t%2.0f\t%2.0f\t\n',name,term,Pks_larger,incP,Pks_smaller,decP,CS,KSstat,PercentChangedInTerm,TOTChanged);        
           end 
        %lilach
        %write_to_matlab_file(name,term,Pks_larger,incP,Pks_smaller,decP,CS,KSstat,j);      
        %NAMES{i} = name;
       %TERMS{i} = term;
       %Pks_smaller_vector(i) = Pks_smaller;
       %Pks_larger_vector(i) = Pks_larger;
       %incP_vector(i) = incP;
       %decP_vector(i) = decP;
       %CS_vector(i) = CS;
       %KSstat_vector(i) = KSstat;
       %i=i+1;
       
    elseif CS > 1 % So that both methods can be used
        
        INC = sum(increased(relinds));
        DEC = sum(decreased(relinds));
        
        %lilach (15/03/05)
        TOTChanged=INC+DEC; 
        PercentChangedInTerm=  (TOTChanged/CS)*100;
        %end 
        
        if INC % If we have at least one increased  
            incP = 1- hygecdf(INC,N,TOTinc,CS) +hygepdf(INC,N,TOTinc,CS) ; %P = H`YGECDF(X,M,K,N)  
        else
            incP = 1;
        end
        if DEC % If we have at least one decreased  
            decP = 1- hygecdf(DEC,N,TOTdec,CS) + hygepdf(DEC,N,TOTdec,CS); %P = HYGECDF(X,M,K,N)    
        else
            decP = 1;
        end
        
        % For the KS test        
        otherinds = setdiff(FULLINDS,relinds);
        R1 = data(otherinds);       
        R2 = data(relinds);        
        N2 = length(R2);
        N1 = length(R1);
        KSstat = (N1*N2)/(N1+N2);
       
        [Pks_smaller Pks_larger] = ybs_kstest2(R1,R2);  % KS test, for both tails simultaneously                        
        
        %lilach: add if/else 
        if (Pks_larger<= p_value || incP <= p_value || Pks_smaller <= p_value || decP <= p_value ) 
        % Print results to file
                fprintf(fid,'%s\t%2.0f\t%2.5f\t%2.5f\t%2.5f\t%2.5f\t%2.0f\t%2.0f\t%2.0f\t%2.0f\t\n',name,term,Pks_larger,incP,Pks_smaller,decP,CS,KSstat,PercentChangedInTerm,TOTChanged);        
        end; 
        
        
        %lilach
        %write_to_matlab_file(expname,datadir,Pks_larger,incP,Pks_smaller,decP,CS);
       
       % row = [Pks_larger incP Pks_smaller decP CS KSstat]
       
       
       % NAMES{i} = name;
       %TERMS{i} = term;
       %we don't care what is the changes, only the p-va
       
       
       %incP_vector(i) = incP;
       %decP_vector(i) = decP;
       %CS_vector(i) = CS;
       %KSstat_vector(i) = KSstat;
       
        %p_values_var{i} = row;
        %i=i+1;
        %save data for get significant terms (according to P-val)
        
    else % If we have no relevant indices then do not write into file
    end
    
end

fclose(fid);



%lilach
%save(outfile1,'NAMES');
%save (outfile2,'TERMS');
%save (outfile3,'Pks_smaller_vector');
%save(outfile4,'Pks_larger_vector');
%save(outfile5,'incP_vector');
%save(outfile6,'decP_vector');
%save(outfile7,'CS_vector');
%save(outfile8,'KSstat_vector');

msgbox('Done!','GOdist');


return
end

%lilach
%function write_to_matlab_file(name,term,Pks_larger,incP,Pks_smaller,decP,CS,KSstat,j) 
   
   %row = [Pks_larger incP Pks_smaller decP CS KSstat]
   
  % NAMES{j} = name;
   %TERMS{j} = term;
   %p_values_var{j} = row;

%end


