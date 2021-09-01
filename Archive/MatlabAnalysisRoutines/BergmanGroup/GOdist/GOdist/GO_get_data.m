function [P1,P2] = GO_get_data(CM,CSTD,CS,C2M,C2STD,C2S,N_ITE,CH_Thresh,N);
% This one uses simulalted data and is therefore quite simple
% The assumption here is that categories are independent

% P1 is the result using the KS test, P2 is using the fisher test
% mean std and size of taregt population
%CM,
%CSTD,
%CS,
% mean std and size of second "hiddeb"population
%C2M
%,C2STD
%,C2S
% Number of iterations: ,N_ITE,
% Threshold for calling a changce CH_Thresh
% total number of probes ,N

% The questions are:
% How is the P value of each method dependent on the:
% mean change in log value
% size of the relevant population (maximum number of terms) and number of
% terms that changed (and this is a function of the number of threshold and the number of other categories that changed)

% N_ITE = 100; % Number of iterations
% 
BM = 0; % mean of baseline population
% CM = 1; % This is category mean
% CSTD = 0.5;
% CS = 100; % This is the category size (i.e. number of genes with this term)
% 
% % The second category which may ifterfere with the first
% C2M = 0;
% C2S = 500;
% 
% %CH_Thresh = 1.6449; % Threshold for calling a change
% CH_Thresh = 2; % Threshold for calling a change
% 
% N = 10000;
%created in llach_get_all_genes_with_term
load  'D:\usr\lilach\work\Yoram\input\affymetrix_Math1#2\hist\GO_p-values_thresh.mat'  
   
 termdata = log2_EXP_VALUES_term1;
  CS = length(termdata);  


for k = 1:N_ITE
    
    
    data = normrnd(0,1,1,N); 
    %data(1:CS) = normrnd(CM,CSTD,1,CS); 
   data(1:CS)=termdata;
    % This is the other population
   data(end-C2S+1:end) = normrnd(C2M,C2STD,1,C2S);
    
    TC = length(find(data > CH_Thresh)); % Total number of changed genes
    CC(k) =  length(find(data(1:CS) > CH_Thresh)); % CC is the number changed within the category
    
    R2 = data(1:CS);
    R1 = data(CS+1:end);
    [H P1(k)] = kstest2(R2,R1,0.05,-1);
    if CC > 0         
        P2(k) = 1- hygecdf(CC(k),N,TC,CS); %P = HYGECDF(X,M,K,N)    
%         P2tag(k) = 1- hygecdf(CC(k),N,TC,CS); %P = HYGECDF(X,M,K,N)   
%         if (P2(k) == P2tag(k))
%             disp(['yes they are eqaul'])
%         else
%             disp(['wrong here !!!!'])
%         end
    else
        P2(k) = 1;       %     P3(k) = 1;
    end
end

% NP1   = find(P1 <=0.05);
% NP2   = find(P2 <= 0.05);
% NP12 = find(P1 <=0.05 & P2 <= 0.05);
return




