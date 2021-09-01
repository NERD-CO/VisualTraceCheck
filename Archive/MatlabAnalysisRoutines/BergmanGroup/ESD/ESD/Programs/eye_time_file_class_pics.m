function [file_num_vec, times_sec_vec, eye_isopen_vec]  = ...
    eye_time_file_class_pics(FullFileName, dark_threshold, dark_num, column, row, PLOT,DO_DGTS_TRAIN)
%
% [file_num_vec times_sec_vec eye_isopen_vec]  =
% eye_time_file_class_pics(FullFileName, dark_threshold, dark_num, column, row, PLOT,DO_DGTS_TRAIN) 
% classify pictures

[pathstr, fname, ext, versn] = fileparts(FullFileName);
DGTS_DATA_LOCAL_FILE=[pathstr '/dgts_data.mat'];

if DO_DGTS_TRAIN
    load (DGTS_DATA_LOCAL_FILE);
elseif exist(DGTS_DATA_LOCAL_FILE,'file')
    load (DGTS_DATA_LOCAL_FILE);
else
    load('dgts_data');
end

load('fname_dgts');
numloc=digits3.location;
vec_leng = (numloc(2)-numloc(1)+1) * 19 ;

blackness_edge=150;

info = aviinfo(FullFileName);
NumFrames=info.NumFrames;

eye_isopen_vec = true(NumFrames*2,1);
times_vec = zeros(NumFrames*2,9);
fname_vec = zeros(NumFrames*2,2);

blocsize=50;
blocnum=ceil(NumFrames/blocsize); % ceil is used to get also the last, shorter, bloc

i_field_eye=1;
i_field_time=1;
i_field_fname=1;

tic;
for bloc=1:blocnum
    if bloc<=floor(NumFrames/blocsize) %size of exact blocs 
        blocvec = (bloc-1)*blocsize+1:bloc*blocsize;
    else %last bloc, shorter - if exists
        blocvec = (bloc-1)*blocsize+1:NumFrames;
        blocsize = length(blocvec); %for the "for i=1:blocsize" loop to run propperly with the last shorter bloc
    end %if bloc<=floor(NumFrames/blocsize)
        
    mov=my_aviread(FullFileName,blocvec);
    
    for i=1:blocsize
        img = mov(i).cdata(:,:,1);

        % EYE STATUS (isopen_eye_vec)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        eye_imag_mat = deinterlace_window(img,row,column);
        for field=1:2
            %         eye_imag_mat = double(img(row,column));
            eye_image_reshape_vec = reshape(eye_imag_mat{field}, 1, length(column)*length(row));
            if(PLOT)
                figure(3);
                subplot(2,1,1);imshow(eye_imag_mat{field},[0 256]);
            end %if(PLOT)

            dark_points = length(find(eye_image_reshape_vec < dark_threshold));
            dark_mean = mean(eye_image_reshape_vec);
            
            class = (dark_points >= dark_num);
            
            eye_isopen_vec  (i_field_eye) = class;
            i_field_eye=i_field_eye+1;

            if(PLOT)
                
                title(['class: ' num2str(class) ' mean: '  num2str(dark_mean) ' dark points: ' num2str(dark_points) ]);
                subplot(2,1,2); hist(double(eye_image_reshape_vec),40);
                pause
                
            end %if(PLOT)
            
        end %for fields=1:2
        
        % TIME
        %%%%%%%
        for k=1:9
            dig_time_im=mov(i).cdata(digits.location{k}(1):digits.location{k}(1)+10,...
                digits.location{k}(2):digits.location{k}(2)+6,1); %Takes the kth digit
            dig_time_im=double(dig_time_im);
            
            %             if DO_DGTS_TRAIN %if the user is asked to mark the digits, it might be better to use the non-binary version
            dig_time_reshape_vec=reshape(dig_time_im,7*11,1);
            %             else
            %                 dig_time_im_bin=zeros(size(dig_time_im));
            %                 dig_time_im_bin(dig_time_im>blackness_edge)=255;
            %                 dig_time_reshape_vec=reshape(dig_time_im_bin,7*11,1);
            %             end
            
            dig_time_mat=[dig_time_reshape_vec, dig_time_reshape_vec, dig_time_reshape_vec, dig_time_reshape_vec, dig_time_reshape_vec, dig_time_reshape_vec, dig_time_reshape_vec, dig_time_reshape_vec, dig_time_reshape_vec, dig_time_reshape_vec];
            time_l2norm_vec = sum((digits.style-dig_time_mat).^2);
            [minval , time_digit]=min(time_l2norm_vec);
            times_vec(i_field_time,k)=time_digit-1;
                
        end %for k=1:9

        if PLOT
            imshow(mov(i).cdata(:,:,1));
            title(num2str(times_vec(i_field_time,end:-1:1)));
            pause
        end
        i_field_time=i_field_time+2;
        
        %FILENAME
        %%%%%%%%%
        deint_fname=deinterlace_window(mov(i).cdata,numloc(1):numloc(2),numloc(3):numloc(4));
        for field=1:2
            
            for k=1:2
                dig_fname_im=deint_fname{field}(:,[134:152]-k*19,1); %Takes the kth digit
                dig_fname_im=double(dig_fname_im);
                dig_fname_vec=reshape(dig_fname_im,vec_leng,1);
                fname_dig_mat=[dig_fname_vec, dig_fname_vec, dig_fname_vec, dig_fname_vec, dig_fname_vec, dig_fname_vec, dig_fname_vec, dig_fname_vec, dig_fname_vec, dig_fname_vec, dig_fname_vec];
                fname_l2norm_vec = sum((digits3.style-fname_dig_mat).^2);
                [stam fname_dig_found]=min(fname_l2norm_vec);

                if fname_dig_found==11
                    fname_vec(i_field_fname,k)=NaN;
                else
                    fname_vec(i_field_fname,k)=fname_dig_found-1;
                end

            end %for k=1:2

        end %for field=1:2

        if PLOT
            imshow(mov(i).cdata(:,:,1));
            title(num2str(fname_vec(i_field_fname,:)));
            pause
        end

        i_field_fname =i_field_fname+1;

    end %for i=1:blocsize
    
    if mod(bloc,5)==0
        seconds=toc;
        partpassed=bloc*blocsize/NumFrames;
        timepass=datestr(seconds/24/60/60,'HH:MM:SS');
        timerem=datestr(seconds/partpassed/24/60/60 - seconds/24/60/60,'HH:MM:SS');
        disp(['Finished ' num2str(bloc*blocsize) ' frames out of ' num2str(NumFrames) ' which makes '...
            num2str(100*partpassed) '%. Time passed:' timepass ' ; Estimated time left:' timerem]);
        
    end
    
end %for bloc=1:blocnum

% if NumFrames*2~=field_total_index-1
%     disp (['fields num = ' num2str(NumFrames*2) ' but ' num2str(field_total_index-1) 'entries exist in the output']); 
% end

time_vec_weights = [10*60^2 60^2 10*60 60 10 1 1e-1 1e-2 1e-3]; %converts time vector [H H : M M : S S : Dsec Csec Msec] to seconds
time_vec_weights = time_vec_weights(end:-1:1);
times_sec_vec = times_vec*time_vec_weights';
times_sec_vec(2:2:end-2) = 0.5 * ( times_sec_vec(1:2:end-3) + times_sec_vec(3:2:end-1) );
times_sec_vec(end) = times_sec_vec(end-1) + mean(times_sec_vec(2:end-1)-times_sec_vec(1:end-2)); %to find the last one, add the mean difference to the one before

fname_vec_weights = 10.^[0 1];
file_num_vec = fname_vec * fname_vec_weights';
% disp(['Blocsize=' num2str(blocsize)])
