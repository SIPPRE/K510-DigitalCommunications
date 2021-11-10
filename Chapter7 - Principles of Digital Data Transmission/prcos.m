% (prcos.m)
% Usage y=prcos(rollfac,length,T)
% rollfac = 0 to 1 is the rolloff factor
% length is the onesided pulse length in the number of T
% length=2T+1
% T is the oversampling rate
function y=prcos(rollfac,length,T)
y=rcosfir(rollfac,length,T,1,'normal');
end