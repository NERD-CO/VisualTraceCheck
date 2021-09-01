%note - for Out and soma2lim: (anything >/< NaN) = 0
states=ones(length(depth),1); %initially all tags are before STN
states(depth<=In(elec))=3; %all tags past In are in the STN (with no oscillations) 
states(depth<=In(elec) & depth>soma2lim(elec))=2; %all tags within the STN before  soma2lim  are oscillatory
states(depth<=Out(elec))=4; %all states past the Out mark are out
