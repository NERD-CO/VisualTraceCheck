function [eye_isopen_vec, file_num_vec, times_sec_vec] = get_eye_time_fname(day_name,avifilename,PLOT,DO_DGTS_TRAIN)
%
% function [file_num_vec time_vec eye_isopen_vec] = get_eye_time_fname(day_name,avifilename,PLOT)
%
% the function gives the file number, time (in seconds), and eye state at
% each field (half frame) of the movie input. The code files are supposed
% to be in a directory: ....\"data"\"programs" and the movies in:
% ....\"data"\"day name"\avifile.avi
%
% The inputs are:
% day_name - the day in which the movie was taken, as it appears in the
%            directory name. no '\' neede.
% avifilename - the name of the avi file. can be given with or without the
%               extension, (assuming the extension is .avi)
% PLOT - a possible boolean input, with a default of being false. if true,
%        the process is presented to the user (slower, and not neede
%        usually)
%
% The outputs are 3 vectors, 3x2n (n is the number of frames in the input
% file):
% file_num_vec - the number (2 digits, i.e. 1 to 99)  of the file as it
%                apears on frame. lack of file on the frame is marked by
%                NaN.
% times_sec_vec - the time as it appears on the buttom left. every second
%                 field is calculated by average of the 2 fields before and
%                 after.
% eye_isopen_vec - a boolean vector, where true means an opened eye, and
%                  false - a closed one.
%
% The outputs are also being saved to a file whose name is the same as the
% avi file, but with the extension .mat, and in the directory
% ....\"data"\results\"avifilename".mat
% results is the only compulsory name here (if such directory doesn't
% exist, it will be created) whereas all others (denoted with " " ) can be
% any meaningful name
% % % % % % % % % % % % % % % % % % % % % % % %

close all

%defaults for testing
if ~exist('PLOT','var') || isempty(PLOT)
    PLOT=false;
end

if ~exist('day_name','var') || isempty(day_name)
    %     day_name='170906(1)';
    day_name='test';
end

if ~exist('avifilename','var') || isempty(avifilename)
%         avifilename  =  'test1';
%     avifilename  = '170906(1)';
    %     avifilename  =  'test1.avi';
    avifilename  = 'demo';%.avi
end

if ~exist('DO_DGTS_TRAIN','var') || isempty(DO_DGTS_TRAIN)
    DO_DGTS_TRAIN=false;
end



[pathstr, fname, ext, versn] = fileparts(avifilename);
ext='.avi'; %enforce avi extension - regardelss of input extension
FullFileName = (['../' day_name '/' fname ext]);

MIN_EYE_SIZE = 400;
PIC = 12; % "random"  picture for marking eye location

if ~exist (FullFileName,'file')
    error(['The file ' FullFileName ' does not exist.']);
end

try %(1) try aviread...
    mov = aviread(FullFileName,PIC);
    disp('aviread is working fine');
catch

    try %(2) ...if this doesn't work, ask user to download missing codec
        what2do=menu('You may have a problem with aviread, What to do?',...
            'download missing codec',...
            'Leave it and use the mmread slow package');
        
        switch what2do
            
            case 1
                web http://movavi.com/codec/mp43.html -browser
                figure(1);
                title('Press any key to continue');
                pause;
                figure(1);close;
                mov=aviread(FullFileName,PIC);
                
            case 2
                disp('Using mmread. It might be slow...')
                mov=aviread(FullFileName,PIC); %this line is no supposed to work, just throw the code to the catch condition
                
        end %switch
        
    catch%if nothing else works, use my_aviread
        disp('failed using aviread. Satisfies with mmread toolbox');
        mov=my_aviread(FullFileName,PIC);
        
    end %try(2)

end %try(1)


figure, imshow(mov.cdata(:,:,1));
% get eye position
txt = 'MARK UPPER LEFT CORNER';
title(txt, 'FontSize', 14);
[ul_x ul_y]= ginput(1);
%  matlab requires rounding
ul_x  = round(ul_x);
ul_y  = round(ul_y);
txt = 'MARK LOWER RIGHT CORNER';
title(txt, 'FontSize', 14);

[lr_x lr_y]= ginput(1);
lr_x  = round(lr_x);
lr_y  = round(lr_y);

lr_y=lr_y-mod(lr_y,2); %force an even number of rows to prevent bias of the de-interlace process


title('Eye Location');
%draw a box around the eye
draw_square(ul_x, ul_y,lr_x,lr_y) ;
%ul_x = 167; ul_y = 47; lr_x = 244; lr_y = 81
column = ul_x:lr_x;
row = ul_y:lr_y;
if(length(column)*length(row) < MIN_EYE_SIZE)
    beep
    disp('eye too small!');
    disp(['I' ''''  'll give it a shot, but don' '''' 't say I didn' '''' 't tell you...']);
end

if DO_DGTS_TRAIN
    learn_digits(FullFileName);
end

[dark_threshold, dark_num] = train_eye_state_classifier(FullFileName,column,row);

if DO_DGTS_TRAIN
    learn_filename_digits(FullFileName);
end

[file_num_vec, times_sec_vec, eye_isopen_vec] = eye_time_file_class_pics(FullFileName,dark_threshold,dark_num,column,row,PLOT,DO_DGTS_TRAIN);

resultsdir='..\results';
if ~exist(resultsdir, 'dir')
    mkdir (resultsdir);
    disp (['the directory ' resultsdir ' was created'])
end

save ([resultsdir '\' fname '.mat'],'file_num_vec', 'times_sec_vec', 'eye_isopen_vec');

