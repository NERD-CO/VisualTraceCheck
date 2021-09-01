function [prob, surprise] = poissonBurstSurprise(r,T)

% inputs
% r = instantaneous firing rate for trace
% T = time interval : Ex = 0.1s 

prob = poisscdf(T,r);

surprise = -log(prob);