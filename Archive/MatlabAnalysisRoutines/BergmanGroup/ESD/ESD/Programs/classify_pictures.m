function classifier =  classify_pictures(fileName, dark_threshold, dark_num, column, row, PLOT)
% function classifier =  classify_pictures(fileName, dark_threshold, dark_num, column, row)
% classify pictures
info = aviinfo(fileName);
NumFrames=info.NumFrames;
% classify pictures trial: on a random set
% NUM_PICTURES = 50;
% 
% rand_val = rand(1,NUM_PICTURES);
% inx = ceil(rand_val * NumFrames);
% mov=my_aviread(fileName,inx);

% % classify pictures: the real thing (heavy...)
classifier =zeros(1,NumFrames*2);

blocsize=25;
blocnum=ceil(NumFrames/blocsize); % ceil is used to get also the last, shorter, bloc
field_total_index=1;
for bloc=1:blocnum
    if bloc<=floor(NumFrames/blocsize) %size of exact blocs 
        blocvec = (bloc-1)*blocsize+1:bloc*blocsize;
    else %last bloc, shorter - if exists
        blocvec = (bloc-1)*blocsize+1:NumFrames;
        blocsize = length(blocvec); %for the "for i=1:blocsize" loop to run propperly with the last shorter bloc
    end
        
    mov=my_aviread(fileName,blocvec);
    
    for i=1:blocsize
        img = mov(i).cdata(:,:,1);
        curr_mat = deinterlace_window(img,row,column);
        for field=1:2
            %         curr_mat = double(img(row,column));
            curr_vec = reshape(curr_mat{field}, 1, length(column)*length(row));
            if(PLOT)
                figure(3);
                subplot(2,1,1);imshow(curr_mat{field},[0 256]);
            end %if(PLOT)

            dark_points = length(find(curr_vec < dark_threshold));
            dark_mean = mean(curr_vec);
            if(dark_points < dark_num)
                class = 'c';
            else
                class = 'o';
            end
            classifier(field_total_index) = class;
            field_total_index=field_total_index+1;

            if(PLOT)
                
                title(['class: ' class ' mean: '  num2str(dark_mean) ' dark points: ' num2str(dark_points) ]);
                subplot(2,1,2); hist(double(curr_vec),40);
                pause
                
            end

        end %for fields=1:2
        
    end %for i=1:NUM_PICTURES
    
end %for bloc=1:blocnum

