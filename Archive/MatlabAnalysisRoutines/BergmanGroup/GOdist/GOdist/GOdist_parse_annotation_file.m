function GODIST_parse_annotation_file(ontology,infile,outfile,wbH);

%  Read and arrange the data from an ontology file 
%  This file is to be run whenever there is an ontology update, and then the
%  Results should be saved to an agreed directory. 
%  EC is for evidence codes, the options are:


switch ontology
    case 'cc'
        onto_str = 'Cellular Component';
    case 'mf'
        onto_str = 'Molecular Function';
    case 'bp'
        onto_str = 'Biological Process';
end

waitbar(0,wbH,['Reading ' onto_str ' annotation file']);

% Read the ontology file (which is saved as a tab delimited text file)
[gene_id_str,GO] = textread(infile,'%s %s','delimiter','\t');

% Convert the string IDs to numbers
for i = 1:length(gene_id_str)
    USind = min(findstr('_', gene_id_str{i}));
    this_id = str2num(gene_id_str{i}(1:USind-1));
    if ~isempty(this_id)
        gene_id(i)   = this_id;
    else
        gene_id(i) = 0;
    end
end

% Go over all IDs and find the corresponding ontologies
TC = 1;
N = length(gene_id);
for i = 1:N
    
    % Progress bar
    if ~rem(i,50)
        waitbar(i/N,wbH,['Converting ' onto_str ' annotation file']);
    end
    
    thisline = GO{i};
    if isempty(findstr('---',thisline))       % This is when we have no corresponding GO term
        thisline(findstr('"',thisline)) = []; % For some reason some lines contain quotation marks and these cause reading problems
        SEP = findstr('///',thisline);
        % generate a series of lineparts
        linepart = [];
        if isempty(SEP)
            linepart{1} = thisline;
        else
            linepart{1} = thisline(1:SEP(1)-1);
            for m = 1:(length(SEP)-1)
                linepart{m+1} = thisline((SEP(m)+3):SEP(m+1)-1);
            end
            linepart{length(SEP)+1} = thisline(SEP(end)+3:end);            
        end
        
        for k = 1:length(linepart)
            AI(TC,1) = gene_id(i);
            AI(TC,2)   = sscanf(linepart{k},'%i');  
            % When the block below is commented out, I ignore the evidence codes
            %             smallseps = findstr('//',linepart{k});
            %             % I assume each onbtology term for each gene has only one evidence code
            %             if ~(length(smallseps)==2)
            %                 disp(['error in  ' num2str(gene_id(i))]);
            %             else
            %                 EC_desc{TC}  =  deblank(linepart{k}((smallseps(2)+3):end));              
            %             end
            TC = TC+1;
        end        
    end
end

% Discard the empty lines:
bad_id_inds = find(~AI(:,1)); % All these transcripts which do not have a number followed by _ as their names
AI(bad_id_inds,:) = [];

save(outfile,'AI');

return









