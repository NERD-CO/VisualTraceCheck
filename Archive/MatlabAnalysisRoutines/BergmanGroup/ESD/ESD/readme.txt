Eye state detection (ESD) algorithm is combined in the function get_eye_time_fname. 
For demo set matlab to the directory programs, and type:

eye_isopen_vec = get_eye_time_fname('test','demo');

eye_isopen_vec is a binary output of the state of the eye (1 - open, 2 - closed)


--------------------------------------------------------

The function is used with the following syntex


% function [eye_isopen_vec file_num_vec time_vec] = get_eye_time_fname(day_name,avifilename,PLOT)
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
% PLOT - a possible binary input, with a default of being false. if true,
%        the process is presented to the user (slower, and not neede
%        usually)
%
% The outputs are 3 vectors, 3x2n (n is the number of frames in the input
% file):
% file_num_vec - the number (2 digits, i.e. 1 to 99)  of the file as it
%                appears on frame. lack of file on the frame is marked by
%                NaN.
% times_sec_vec - the time as it appears on the bottom left. every second
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

