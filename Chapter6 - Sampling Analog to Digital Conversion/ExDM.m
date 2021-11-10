% (ExDM.m)
% Example of sampling, quantization, and zero-order hold
clear all ;close all; clc;
td=0.002; % original sampling rate 500 Hz
t=0:td:1.0; %time interval of 1 second
xsig=sin(2*pi*t)-sin(6*pi*t); % 1Hz+3Hz sinusoids
Lsig=length(xsig); 
ts=0.02; % new sampling rate = 50 Hz
Nfact=ts/td;
% send the signal through a 16-level uniform quantizer
Delta1=0.2; % First select a small Delta=0.2 in DM
s_DMout1=deltamod(xsig,Delta1,td,ts);
% obtained the DM signal
% plot the original signal and the DM signal in time domain
figure(1);
subplot(311);sfig1=plot(t,xsig,'k',t,s_DMout1(1:Lsig),'b');
set(sfig1,'Linewidth',2);
title('Signal {\it g}({\it t}) and DM signal');
xlabel('time (sec.)');axis([0 1 -2.2 2.2]);
%
% Apply DM again by doubling the Delta
Delta2=2*Delta1;
s_DMout2=deltamod(xsig,Delta2,td,ts);
% obtained the DM signal
% plot the original signal and the DM signal in time domain
subplot(312);sfig2=plot(t,xsig,'k',t,s_DMout2(1:Lsig),'b');
set(sfig2,'Linewidth',2);
title('Signal {\it g}({\it t}) and DM signal with Doubled stepsize');
xlabel('time (sec.)');axis([0 1 -2.2 2.2]);
%
Delta3=2*Delta2; % Double the DM Selta again
s_DMout3=deltamod(xsig,Delta3,td,ts);
% plot the original signal and the DM signal in time domain
subplot(313);sfig3=plot(t,xsig,'k',t,s_DMout3(1:Lsig),'b');
set(sfig3,'Linewidth',2);
title('Signal {\it g}({\it t}) and DM signal with quadrupled stepsize');
xlabel('time (sec.)');axis([0 1 -2.2 2.2]);






