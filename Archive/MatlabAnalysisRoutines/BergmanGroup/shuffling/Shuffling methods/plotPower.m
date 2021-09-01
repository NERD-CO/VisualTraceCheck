% Writen by: Michal Rivlin.
% Last updated: 12.4.2005

% The function plots the original PSD/CSD (black), and the PSD/CSD of the shuffled train (red).
% a,b,c are integers for plotting the results in the given subplot.
function plotPower(freq,pow,freq_rand,pow_rand,a,b,c)

global P_VAL CONF_PERCENT

sbp=subplot(a,b,c);
plot(freq,log10(pow),'k');
hold on;
plot(freq_rand,log10(pow_rand),'r');
xlabel('Frequency (Hz)','FontSize',8);
ylabel('Spectrum (logarithmic scale)','FontSize',8);
set(sbp,'FontSize',8);

return