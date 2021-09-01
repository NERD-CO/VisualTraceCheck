function [num_sig] = GOdist_run_both_methods_for_thresh(datadir,expname,infile,ontology,thresh_value);

%to run from: run_go_threshold 

% Same as test_GO_dist but only the number of the term is reported. Also,
% all terms are written into the file, if there is nothing to say about
% them, they get a -1 -1 value as the p-values.
D = load(infile);
data = D.selected_data;
gene_ids = D.selected_ID;

N = length(data);

increased = (data > thresh_value);
decreased = (data < -thresh_value);

TOTinc = sum(increased);
disp('tot increased');
disp(TOTinc);
TOTdec = sum(decreased);
disp('tot decreased');
disp(TOTdec);
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



% A list of all incdices
FULLINDS = 1:length(data);     % Simply a list of all the indices which we need later for the exclusive test

NT = length(ALL_TERMS);
disp('Num terms:')
disp(NT);
%p_vals_var index
i=1;

 %lilach
        %write_to_matlab_file(expname,datadir,Pks_larger,incP,Pks_smaller,decP,CS);



        %P_values_ks = zeros(NT*2,1);
 %P_values_fishex = zeros(NT*2,1);
 
  num_sig=zeros(1,2);
 %loop on all terms
for j = 1:NT
     
    % The term we are now testing
    term = ALL_TERMS(j);
    name = ALL_NAMES{j};
    
    % Get relevant indices
    relinds = get_term_inds(term,P,AI,gene_ids);
    CS = length(relinds);    
    
    if CS  == 1     
        
        INC = sum(increased(relinds));
        DEC = sum(decreased(relinds));
        
       
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
        
    elseif CS > 1 % So that both methods can be used
        
        %Fishex test
        INC = sum(increased(relinds));
        DEC = sum(decreased(relinds));
        
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
       
       %we don't care what is the changes, only the p-val
       
       if (Pks_larger<=0.05)
          num_sig(1,1)=num_sig(1,1)+1;
       end
      if (Pks_smaller<=0.05)
         num_sig(1,1)=num_sig(1,1)+1;
       end
      if (incP<=0.05)
          num_sig(1,2)=num_sig(1,2)+1;
       end
       if (decP<=0.05)
         num_sig(1,2)=num_sig(1,2)+1;
       end
        
    else % If we have no relevant indices then do not write into file
    end
    
end
%convert to percentages
disp('KS N:');
disp (num_sig(1,1));
num_sig(1,1) = (num_sig(1,1)*100)/NT;
disp('KS %:');
disp (num_sig(1,1));
disp('Fishex N:');
disp (num_sig(1,2));
num_sig(1,2) = (num_sig(1,2)*100)/NT;
disp('Fishex %:');
disp(num_sig(1,2));
disp('------------------------');
return
end


