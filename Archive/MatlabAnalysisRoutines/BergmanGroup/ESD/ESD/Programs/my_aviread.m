function mov=my_aviread(varargin)

try
    mov=aviread(varargin{:});
catch
    disp(['Note, there was an error reading the file ' varargin{1} ' using the function aviread. Trying mmread tool']);
    beep;
    DIR='./mmread';
    if exist (DIR,'dir')
        addpath(DIR);
    end

    disableVideo=false;
    disableAudio=true;
    video = mmread(varargin{:}, [], disableVideo, disableAudio);
    mov=video.frames;
end
