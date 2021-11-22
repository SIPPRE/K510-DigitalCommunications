function eyesuccess=eyeplot(onedsignal,Npeye,NsampT,Toffset)
% This function plots the eye diagram of the input signal string
% Use flag=eyeplot(onedsignal,Npeye,NsampT,Toffset)
%
% onedsignal = input signal string for eye diagram plot
% NsampT = number of samples in each baud period Tperiod
% Toffset = eye diagram offset in fraction of symbol period
% Npeye = number of horizontal T periods for the eye diagram


Noff= floor(Toffset*NsampT);
% offset in samples
Leye= ((1:Npeye*NsampT)/NsampT);
% x-axis
Lperiod=floor((length(onedsignal)-Noff)/(Npeye*NsampT));
Lrange = Noff+1:Noff+Lperiod*Npeye*NsampT;
mdsignal=reshape(onedsignal(Lrange),[Npeye*NsampT Lperiod]);
plot(Leye,mdsignal,'k');
eyesuccess=1;
return
end