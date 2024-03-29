function GOdist_select_transcripts(infile,outfile,selection_method,wbH);
% generate output data with with which run_both_methods can be called

% selection_method can be;
% 'min_score'
% 'max_score'
% 'min_data'
% 'max_data'
% 'mean'
% 'median'
% The calling function must make sure that the appropriate selection method is selected

% File containing the data structure
load(infile);

% Get data from the file
data = DATA{1};
ID_NUM = DATA{2};
UG_NUM = DATA{3};
% If we have score data then read it
if length(DATA) == 4
    scores = DATA{4};
    USE_SCORE = 1;
else
    USE_SCORE = 0;
end


if ~USE_SCORE & (strcmp(selection_method,'min_score') |  strcmp(selection_method,'max_score'))
        eh = errordlg(['''' selection_method '''' ' selection rule cannot be applied since score data is missing'],'GOdist error');
    return;
end

% Run over all UniGenes and select the values to take
gci = 1; % gene counter index
%Lilach: B - the unique values, in ascending order, I - the indexes of the
%unique values (each unique value is the greatest subscript from UG_NUM with that value), J - indexes such that UG_NUM = B(n). 
[B,I,J] = unique(UG_NUM); 
N = length(B);
for i = 1:N
    if B(i) % If it has a unigene code (because a gene gets a 0 in read_pivot_table_data if there is no code)
        % Progress bar
        if ~rem(i,50)
            waitbar(i/N,wbH,['Applying transcript selection rule']);
        end
        % Make sure we do not take signals with the same 
        these = find(UG_NUM == B(i));
        these_data   = data(these);
        these_ID_NUM  = ID_NUM(these);
        
        %lilach
        %these_UG_multiple =  UG_NUM(these);
        %these_UG = unique(these_UG_multiple);
        
        if USE_SCORE
            these_scores = scores(these);
        end
            
        if length(these) > 1
            switch selection_method
                case 'min_score'
                    [tmp take]    = min(these_scores);
                    selected_data(gci) = these_data(take);
                    selected_ID(gci)   = these_ID_NUM(take);
                     
                    %lilach
                   %selected_UG(gci) = these_UG(take);
                case 'max_score'
                    [tmp take]    = max(these_scores);
                    selected_data(gci) = these_data(take);
                    selected_ID(gci)   = these_ID_NUM(take);
                    
                    %lilach
                    %selected_UG(gci) = these_UG(take);
                case 'min_data'
                    [tmp take]    = min(abs(these_data));
                    selected_data(gci) = these_data(take);
                    selected_ID(gci)   = these_ID_NUM(take);
                    
                    %lilach
                  % selected_UG(gci) = these_UG(take);
                case 'max_data'
                    [tmp take]    = max(abs(these_data));
                    selected_data(gci) = these_data(take);
                    selected_ID(gci)   = these_ID_NUM(take);
                    
                    %lilach
                    %selected_UG(gci) = these_UG(take);
                case 'mean'
                    selected_data(gci) = mean(these_data);
                    %Lilach: fix bug
                    %instead 
                    %selected_ID(gci)   = these_ID_NUM(these(1)) which is
                    %the index f the first element, take the first element
                    selected_ID(gci)   = these_ID_NUM(1); % For Ontologies, it should not matter which one we take
                    
                    %lilach
                    %selected_UG(gci) = these_UG(take);
                case 'median'
                    selected_data(gci) = median(these_data);
                        %Lilach: fix bug
                    selected_ID(gci)   = these_ID_NUM(1);
                    
                    %lilach
                   % selected_UG(gci) = these_UG(take);
            end                        
             gci = gci+1;
        else
             selected_ID(gci)          = ID_NUM(these);
             selected_data(gci)        = data(these);
             
             %lilach
                   % selected_UG(gci) = these_UG(take);
                    
             gci = gci+1;
        end
    end
end


save(outfile,'selected_ID','selected_data');

%lilach -

%save(outfile,'selected_ID','selected_UG',selected_data');


return

