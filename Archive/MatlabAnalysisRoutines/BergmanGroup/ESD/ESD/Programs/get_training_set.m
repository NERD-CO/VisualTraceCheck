function [eye_vec, classifier] = get_training_set(fileName,TRAIN_SIZE,column,row)
% Get users classifiction for images

% get random indices
info = aviinfo(fileName);
rand_vec = randperm(info.NumFrames);

if info.NumFrames < TRAIN_SIZE
    TRAIN_SIZE=info.NumFrames;
end

rand_inx = rand_vec(1:TRAIN_SIZE);
mov = my_aviread(fileName, rand_inx);
eye_vec = [];
classifier = [];
figure;
% for i=1:length(mov)
i=1;

while i<=length(mov)
    field = deinterlace_window(mov(i).cdata,row,column);
    curr_mat=field{1};
    curr_vec = reshape(curr_mat, 1, length(column)*length(row));
    imshow(curr_mat, 'InitialMagnification', 100);
    title('Press o - open eye; c - closed eye; i - ignore; s - stop training');

    button='';
    while isempty(button) %ENTER pressing causes x,y,but=[]
        [x y button ] = ginput(1);
    end

    switch button
        case 'c'
            classifier(end+1) = false;
            eye_vec(end+1,:) =  curr_vec;

        case 'o'
            classifier(end+1) = true;
            eye_vec(end+1,:) =  curr_vec;

        case 's'
            if ~isempty(find(classifier == false ,1)) && ~isempty(find(classifier == true ,1)) %break only if both types (closed and opened) are marked
                break
            else
                clf
                title('You must mark both closed and opened eyes!','FontSize', 14);
                beep
                i=i-1;
                pause
            end

        case 'i'
            %don't add anything to the vector

        otherwise
            clf
            title('Wrong button pressed!, press any key to continue','FontSize', 14);
            beep
            i=i-1;
            pause
    end %switch button
    i=i+1;
end

if isempty(find(classifier == false,1)) || isempty(find(classifier == true,1)) %verify that both types (closed and opened) are marked
    error('You must mark both closed and opened eyes!');
end

% eye_vec = (sort(eye_vec'))';
eye_vec = (sort(eye_vec,2));