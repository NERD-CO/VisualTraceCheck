function field=deinterlace_window(org_pic,row,column)
% function field=deinterlace_window(org_pic,col,row)
% de-interlaces a window within a picture to its 2 fields, in the correct
% order.
% org_piv is an MxN matrix - usually the 1st of therr color matrices
% (:,:,1) form an imported picture
% col is a vector from 1st to last line of the window
% row is the same for



% Correcto order determination, based on the 1st "row"
first_field = mod(row(1)  ,2) + 1;
last_field  = mod(row(1)+1,2) + 1;

fulcol=[row(1)-1 row row(end)+1]; %2 extra "row"'s to de-interlace properly 1st & last line as well
curr_mat_interlaced = org_pic(fulcol,column); 

field{1}=zeros(size(curr_mat_interlaced));
field{2}=field{1};



field{first_field}(1:2:end,:) = curr_mat_interlaced(1:2:end,:);
field{first_field}(2:2:end-1,:) = .5*(field{first_field}(1:2:end-2,:)+field{first_field}(3:2:end,:));


field{last_field}(2:2:end,:) = curr_mat_interlaced(2:2:end,:);
field{last_field}(3:2:end-1,:) = .5*(field{last_field}(2:2:end-2,:)+field{last_field}(4:2:end,:));


for i=1:2
    field{i}=uint8(field{i}(2:end-1,:)); 
end
%     
% curr_mat(1:2:end,:) = curr_mat_interlaced(1:2:end,:);
% curr_mat(2:2:end-1,:) = .5*(curr_mat(1:2:end-3,:)+curr_mat(3:2:end-1,:));
% curr_mat=curr_mat(1:end-1,1:end);
% curr_mat=uint8(curr_mat);
