% (psine.m)
% generating a sinusoid pulse of width T
function pout=psine(T)
pout=sin(pi*(0:T-1)/T);
end