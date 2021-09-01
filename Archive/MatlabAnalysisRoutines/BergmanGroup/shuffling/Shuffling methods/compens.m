% Writen by: Michal Rivlin.
% Last updated: 12.4.2005

% The compansation: given pow (original PSD/CSD) and pow_rand (mean shuffled
% PSD/CSD) the compensation comp=(pow./pow_rand) is calculated and plotted 
% as well as the confidence line which is based on last CONF_PERCENT% of the frequencies.
% a,b,c determines the subplot in the already exist figure.
function [comp, conf] = compens(freq,pow,freq_rand,pow_rand,a,b,c);

global P_VAL CONF_PERCENT

sbp=subplot(a,b,c);
pow=pow(:);
pow_rand=pow_rand(:);
comp = pow./pow_rand;
plot(freq,comp,'k');
hold on;
ln=length(comp);
conf_comp=comp(ln-round(ln/CONF_PERCENT):ln);
p=P_VAL/ln;
conf=norminv(1-p)*std(conf_comp) + 1;
plot(freq,conf,'r');
xlabel('Frequency (Hz)','FontSize',8);
ylabel('Compensation','FontSize',8);
set(sbp,'FontSize',8);

return