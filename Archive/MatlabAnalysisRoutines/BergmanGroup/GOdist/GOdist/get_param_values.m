function A = get_param_values(thisparamname,paramnames,params)
% Get a specific parameter from list
I = strmatch(thisparamname,paramnames,'exact');
A = params{I};

