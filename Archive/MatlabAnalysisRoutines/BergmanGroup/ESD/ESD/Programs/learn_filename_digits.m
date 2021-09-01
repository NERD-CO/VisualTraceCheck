function learn_filename_digits(FullFileName)

load ('fname_dgts');
numloc=digits3.location;
vec_leng = (numloc(2)-numloc(1)+1) * 19 ;
L_arrow=28;
R_arrow=29;
info=aviinfo(FullFileName);
files_num = floor(info.NumFrames/(25*60*3));
inputs = min(files_num,30); %gets up to 30 different file names, 
PICS = (0:inputs)*25*60*3+1;

mov = my_aviread(FullFileName,PICS);
digit_style=zeros(vec_leng,11);
digit_s_count=zeros(11,1);
i=1;
do_stop=false;
colormap gray
while i<=length(mov) && ~do_stop
    deint_pic=deinterlace_window(mov(i).cdata,numloc(1):numloc(2),numloc(3):numloc(4));
    %     randdig=round(rand(1)*5+1);
    k=1;
    while k<=2 && ~do_stop
        subplot(1,2,1)
        image(deint_pic{1});
        title('Insert digit; "+" for none; "s" to stop; "i" to ignore')

        axis equal
        axis tight
        
        field=1;
        while field<=2 && ~do_stop

            dig_im=deint_pic{field}(:,(134:152)-k*19,1); %Takes the kth digit
            subplot(1,2,2)
            image(dig_im);
            dig_im=double(dig_im);

            button=[];
            while isempty(button)
                [x,y,button]=ginput(1);
            end

            if (button >= '0' && button <= '9')

                digit_style(:,button-47) = digit_style(:,button-47) + reshape(dig_im,vec_leng,1);
                digit_s_count(button-47) = digit_s_count(button-47) + 1;

            elseif  button == '+'
                digit_style(:,11) = digit_style(:,11) + reshape(dig_im,vec_leng,1);
                digit_s_count(11) = digit_s_count(11) + 1;

            elseif button=='i' || button=='I'
                %just go to the next field

            elseif button=='s' || button=='S'
                if sum(digit_s_count~=0)==length(digit_s_count)
                    do_stop=true;
                else
                    yn=menu(['Digits ' num2str(find(digit_s_count'==0)-1) ' (10 denotes "space") were not marked. stop anyway?'],'Yes, stop','No, keep marking');
                    switch yn
                        case 1
                            do_stop=true;
                        case 2
                            field=field-1;
                    end % switch yn
                end %if sum(digit_s_count~=0)==length(digit_s_count)
                
            else
                beep
                disp('Wrong Button');
            end % if button >= '0' && button <= '9'

            field=field+1;

        end %while field<=2 && ~do_stop
        k=k+1;
    end %while k<=2
    i=i+1;
end %while i<length(mov) && ~do_stop
clf
for i=1:11
    if sum(digit_style(:,i))==0 %if the digit wasn't marked, use the old version. Specially important for the lack of digit that is unlikely to appear
        digit_style(:,i)=digits3.style(:,i);
    else
    digit_style(:,i)=digit_style(:,i)./digit_s_count(i);
    end
    
    subplot(3,4,i)
    image(reshape(digit_style(:,i),(numloc(2)-numloc(1)+1),19));
end %for i=1:11

yn=menu('Are you satified with the digits?','Yes, go ahead and classify','No, but I wont another shot','Not at all, stop the code now!');

switch yn
    case 1
        digits3.style=digit_style;
        digits3.location=numloc;
        save ('fname_dgts','digits3');
    case 2
        learn_filename_digits(FullFileName); % a recursice call
    case 3
        error('OK, OK, the code is stopped')
end