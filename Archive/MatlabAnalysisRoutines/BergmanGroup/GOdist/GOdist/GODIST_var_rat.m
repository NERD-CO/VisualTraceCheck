function P = GODIST_var_rat(R1,R2);

N1 = length(R1);
N2 = length(R2);

% VARIANCE RATIO TEST
VAR1 = var(R1);        VAR2 = var(R2);
V1 = max(N2,N1) - 1;        V2 = min(N2,N1) - 1;            
VARX = max(VAR1,VAR2)/min(VAR1,VAR2); % Variance ratio (larger of the two options)
if VAR1 > VAR2
    V1 = N1-1;            V2 = N2 -1;
else
    V1 = N2-1;            V2 = N1-1;
end            
P = (1-fcdf(VARX,V1,V2))*2; % Divide by two since test is actually two tailed (Biometrics)
