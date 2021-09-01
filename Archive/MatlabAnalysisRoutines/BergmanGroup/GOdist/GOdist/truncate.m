function S = truncate(S);
% Truncate high and low values from expression signal

% Find the largest finite value
FMAX = max(S(find(isfinite(S))));
% and replace all inf values with it
S(find(S == inf)) = FMAX;
% find all zeros
FMIN = min(S(find((S>0))));
S(find(S==0)) = FMIN;
