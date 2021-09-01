function learn_digits(FullFileName)
UP=[56 30];
DOWN=[50 31];
LEFT=[52 28];
RIGHT=[54 29];

load dgts_data;

% for i=1:3
%     digits.location{i}=[464, 173-(i-1)*6];
% end
% digits.location{4}=[464,  152];
% digits.location{5}=[464, 152-6];
% digits.location{6}=[464, 137];
% digits.location{7}=[464, 137-6];
% digits.location{8}=[464, 122];
% digits.location{9}=[464, 116];


% directory = ['D:\Rea' '''' 's_Documents\Mati_data\ProbleMati\'];
% fileName  = '080806(1).avi';
% % directory = '../../movies/';
% % fileName  =  'test1_short.avi';
%
% FullFileName = ([directory fileName]);

PICS=[1:1/5:90/5]*25;
% PICS=[1:90]*25;

mov = my_aviread(FullFileName,PICS);
digit_style=zeros(7*11,10);
digit_s_count=zeros(10,1);
i=1;
do_stop=false;
k=4;
colormap
while i<length(PICS) && ~do_stop

    dig_im=mov(i).cdata(digits.location{k}(1):digits.location{k}(1)+10,...
        digits.location{k}(2):digits.location{k}(2)+6,1); %Takes the 4th digit, ie seconds.
    subplot(1,2,1)
    imshow(dig_im)
    
    total_im=mov(i).cdata(digits.location{9}(1):digits.location{1}(1)+10,...
        digits.location{9}(2):digits.location{1}(2)+6,1);
    subplot(1,2,2)
    
    imshow(total_im)

    %binarization
    dig_im=double(dig_im);
    %     dig_im(dig_im>150)=255;
    %     dig_im(dig_im<=150)=0;
    %     image(dig_im);
    title('Which digit?')

    [x,y,button]=ginput(1);

    if isempty(button)
        beep
        disp('Wrong Button');

    elseif button >= '0' && button <= '9'
        digit_style(:,button-47) = digit_style(:,button-47) + reshape(dig_im,7*11,1);
        digit_s_count(button-47) = digit_s_count(button-47) + 1;
        i=i+1;

    elseif button==' ' || button=='i'
        i=i+1;

    elseif button=='s' || button=='S'
        if all(digit_s_count)
            do_stop=true;
        else
            disp('not all digits marked')
        end

    elseif any(button==[UP DOWN RIGHT LEFT])
        if any(button==UP)
            addvec = [-1 0];
        elseif any(button==DOWN)
            addvec = [+1 0];
        elseif any(button==LEFT)
            addvec = [0 -1];
        elseif any(button==RIGHT)
            addvec = [0 +1];
        end
            
        for l=1:9
            digits.location{l} = digits.location{l}+addvec;
        end
        pause(0)
        
    else
        beep
        disp('Wrong Button');
    end %if button >= '0' && button <= '9'

end %while i<length(PICS) && ~do_stop


for i=1:10
    digit_style(:,i)=digit_style(:,i)./digit_s_count(i);
end

digits.style=digit_style;

[pathstr, fname, ext, versn] = fileparts(FullFileName);

save ([pathstr '/dgts_data.mat'],'digits');