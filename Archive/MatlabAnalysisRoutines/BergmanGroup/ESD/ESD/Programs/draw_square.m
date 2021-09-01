function draw_square(ul_x, ul_y,lr_x,lr_y) 
%draw a box around the eye
line([ul_x lr_x],[lr_y lr_y],'color', 'g', 'LineWidth',2);
line([ul_x lr_x],[ul_y ul_y],'color', 'g', 'LineWidth',2);
line([ul_x ul_x],[ul_y lr_y],'color', 'g', 'LineWidth',2);
line([lr_x lr_x],[ul_y lr_y],'color', 'g', 'LineWidth',2);