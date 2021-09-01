% Read affymetrix file paramaters.
% For technical reasons I cannot read long text columns and these were
% therefore written to txt files and are read form there.

%datafilename    = ['C:\usr\lilach\work\Yoram\input\affymetrix_Math1_rehearsals\SupportingInput\H30-H35 ben ariepivotcom.xls'];
%MGIfname        = ['C:\usr\lilach\work\Yoram\input\affymetrix_Math1_rehearsals\SupportingInput\all_mgi_ids.txt'];
%THOSE ARE AFFYMETRIX GENE IDs
GENE_IDfname    = ['C:\usr\lilach\work\Yoram\input\affymetrix_Math1#2\GodistInput\withoutcontrols\Math1#2_ID.txt'];
%TITLESfname     = ['D:\newchips\all_titles.txt'];
%THOSE ARE THE GENE IDs
UNIGENESfname   = ['C:\usr\lilach\work\Yoram\input\affymetrix_Math1#2\GodistInput\withoutcontrols\Math1#2_UG.txt'];
%SYMBOLSfname    = ['D:\newchips\all_symbols.txt'];
%LOCUS_LINKfname = ['D:\newchips\all_locus_link.txt'];

%[data text] = xlsread(datafilename);
%paramnames = text(1,:); % Leave only the header row

%READ THE BIG FILE

% Go over each parameter and return its value
%for i = 1:length(paramnames)
    %if there is column header
   % if ~isnan(data(1,i))
        %insert to row i at params the ith column from the input file
      %  params{i}       = data(:,i);
        %there is no column header
   % else
        %insert the row without the column
      %  params{i}       = text(2:end,i);
    %end
%end

%i = i+1;
%params{i} = readtext(MGIfname);
%paramnames{i} = 'MGI';

%i = i+1;
i=1;
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

%i = i+1;
%params{i} = readtext(TITLESfname);
%paramnames{i} = 'TITLES';

i = i+1;
params{i} = readtext(UNIGENESfname);
paramnames{i} = 'UNIGENES';
UG = params{i}; % We need this for the code conversion

i = i+1;
paramnames{i} = 'UNIGENE_NUM';

for k = 1:length(UG)
  tline = UG{k};
    pi = findstr('.',tline);
   if ~isempty(pi)
        UG_N(k) = str2num(UG{k}(pi+1:end));
    else
        UG_N(k) = 0;
   end
end
params{i} = UG_N;

%i = i+1;
%params{i} = readtext(SYMBOLSfname);
%paramnames{i} = 'SYMBOLS';

%i = i+1;
%params{i} = readtext(LOCUS_LINKfname);
%paramnames{i} = 'LOCUS_LINK';


cd 'C:\usr\lilach\work\Yoram\input\affymetrix_Math1#2\GodistInput\withoutcontrols\'
save newchipdata params paramnames
clear
















