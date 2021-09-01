function[params paramnames] = create_parameters(datadir,expname)
% Read affymetrix file paramaters.
% For technical reasons I cannot read long text columns and these were
% therefore written to txt files and are read form there.
datafilename = [datadir filesep expname '_data.xls'];  
GENE_IDfname  =  [datadir filesep expname '_ID.txt'];
%TITLESfname            = ['D:\newchips\all_titles.txt'];
UGfile = [datadir filesep expname '_UG.txt'];

[data ] = xlsread(datafilename);

i=1;
params{i}=data;
paramnames{i}='data';

i = i+1;
params{i} = readtext(GENE_IDfname);
GENE_ID_STR = params{i};
paramnames{i} = 'GENE_ID';

 i = i+1;
 for k = 1:length(GENE_ID_STR)
     USind = min(findstr('_', GENE_ID_STR{k}));
     AFFY_NUM(k)   = str2num(GENE_ID_STR{k}(1:USind-1));
 end
 params{i} = AFFY_NUM;
 paramnames{i} = 'AFFY_NUM';

% i = i+1;
% params{i} = readtext(TITLESfname);
% paramnames{i} = 'TITLES';

 i = i+1;
params{i} = readtext(UGfile);
paramnames{i} = 'UNIGENES';
UG = params{i}; % We need this for the code conversion



















