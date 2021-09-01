function [S,D] = get_data_short(T,paramnames,params);

Sname = [T '_Signal'];
Dname = [T '_Detection'];

S = get_param_values(Sname,paramnames,params);
D = get_param_values(Dname,paramnames,params);
