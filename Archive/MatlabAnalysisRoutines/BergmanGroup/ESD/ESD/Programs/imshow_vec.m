
function imshow_vec(vec, row, col)
mat = reshape(vec, row, col);
imshow(mat, [min(vec), max(vec)]);
