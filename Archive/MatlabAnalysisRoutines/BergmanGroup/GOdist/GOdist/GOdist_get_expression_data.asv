function GOdist_get_expression_data(expname,datadir,outfile,wbH);
% Run the basic data for GOdist and save the data in a structure which includes including:
% DATA{1}: A vector of expression scores
% DATA{2}: A vector of gene IDs
% DATA{3}: A vector of Unigenes
% DATA{4}: A vector of scores (optional)
%
% 16/8/04 Enabaled dealing with files containing gene IDs of non affymterix files (though these are ignored)

% datafilename    = ['D:\newchips\HS3_to_18_M430A2_pivot_nodesc'];
import java.io.*;

%log(2) data
data_file  = [datadir filesep expname '_data.xls'];    % expression data - XLS file
score_file = [datadir filesep expname '_scores.xls'];  % score data (optional) - XLS file
ID_file    = [datadir filesep expname '_ID.txt'];        % Affymterix IDs - Text file
UG_file    = [datadir filesep expname '_UG.txt'];        % UniGene codes  - Text file

outfile    = [datadir filesep expname '_array_data.mat'];     % File with all information

% These are the templates for these files
% data_file    = ['D:\newchips\HS3_to_18_M430A2_pivot_nodesc']; % File with expression data
% score_file    = ['D:\newchips\HS3_to_18_M430A2_pivot_nodesc']; % File with expression data
% ID_file    = ['D:\newchips\all_gene_ids.txt']; % File with Affymetrix IDs
% UG_file   = ['D:\newchips\all_unigenes.txt']; % File with unigene codes

% Expression data
% Progress bar
waitbar(0,wbH,['Reading data file']);

[data text] = xlsread(data_file);

%[type, sheets] = xlsfinfo(data_file);
%exist_scores =0;
%for (i=1: length(sheets))       
  %  sheet_name = sheets{i};
  %  switch sheet_name
   % case 'data'
     %   waitbar(0,wbH,['Reading data']);
       %   [data text] = xlsread(data_file,'data');
    %case 'scores'
      %  waitbar(0,wbH,['Reading scores']);
        %   [scores text] = xlsread(data_file,'scores'); 
           %exist_scores =1;
       % case 'ID' 
         %  waitbar(0,wbH,['Reading transcript IDs']);
          % ID_STR = xlsread(data_file,'ID');
           %case 'UG' 
           %waitbar(0,wbH,['Reading transcript UGs']);
           %UG_STR = xlsread(data_file,'UG');
           %otherwise
            %beep;
            %wd = warndlg('not a valid sheet name','GOdist','modal')
            %uiwait(wd);
   % end;
%end;

% Scores 
if exist(score_file) == 2
    waitbar(0,wbH,['Reading transcript score file']);
    [scores text] = xlsread(score_file);
    exist_scores =1;
end    
% ID data
waitbar(0,wbH,['Reading transcript ID file']);
ID_STR = readtext(ID_file);
% UG data
waitbar(0,wbH,['Reading transcript UniGene file']);
UG_STR = readtext(UG_file);

% Convert ID string to a number
N = length(ID_STR);
for k = 1:N
    if ~rem(k,50)
      waitbar(0.5*k/N,wbH,['Converting ID information']);
    end
    USind = min(findstr('_', ID_STR{k}));
    this_id   = str2num(ID_STR{k}(1:USind-1));
    if ~isempty(this_id)
        ID_NUM(k)   =   this_id;
    else
        ID_NUM(k)   =   0;
    end
end
ID_NUM = ID_NUM';

% Convert UniGene data to number
for k = 1:length(UG_STR)
    if ~rem(k,50)
        waitbar(0.5 + (0.5*k/N),wbH,['Converting UniGene information']);
    end
    tline = UG_STR{k};
    pi = findstr('.',tline);
    if ~isempty(pi)
        this_UG = str2num(UG_STR{k}(pi+1:end));
        if ~isempty(this_UG)
            UG_NUM(k) = this_UG;
        else
            UG_NUM(k) = 0;
        end
    else
        UG_NUM(k) = 0;
    end
end
UG_NUM = UG_NUM';


% Group all information into a single variable
DATA{1} = data;
DATA{2} = ID_NUM;
DATA{3} = UG_NUM;
if exist_scores== 1
    DATA{4} = scores;
end

% Get the number of elements in each data file, and inform the user if they are not equal
if exist_scores ==1
    L = [length(DATA{1}) ,length(DATA{2}) , length(DATA{3}) , length(DATA{4})];
else
    L = [length(DATA{1}) ,length(DATA{2}) , length(DATA{3}) ];
end; 
if ~(length(unique(L)) == 1)
    beep
    wd = warndlg('Not all data files contain the same number of elements','GOdist','modal')
    uiwait(wd);
end

% Discard all entries for which we have no valid Gene ID
N = length(ID_NUM);
GOOD_ONES = (find(ID_NUM));
for i = 1:length(DATA)
    if length(DATA{i}) >= N 
        DATA{i} = DATA{i}(GOOD_ONES);
    end
end


save(outfile,'DATA');

return















