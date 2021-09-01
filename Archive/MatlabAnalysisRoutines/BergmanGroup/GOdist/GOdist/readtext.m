function S = readtext(fname);

%filename = ['D:\newchips\test.txt'];

fid=fopen(fname);
i = 1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    S{i} = tline;
    i = i+1;
end
fclose(fid);
