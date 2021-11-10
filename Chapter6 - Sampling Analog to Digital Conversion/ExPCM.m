% (ExPCM.m)
% Example of sampling, quantization, and zero-order hold
clear all; close all; clc;
td=0.002; %original sampling rate 500 Hz
t=0:td:1.; % time interval of 1 second
xsig=sin(2*pi*t)-sin(6*pi*t); % 1Hz+3Hz sinusoids
Lsig=length(xsig); 
Lfft=2^ceil(log2(Lsig)+1);
Xsig=fftshift(fft(xsig,Lfft));
Fmax=1/(2*td);
Faxis=linspace(-Fmax,Fmax,Lfft);
ts=0.02; % new sampling rate = 50 Hz
Nfact=ts/td;
% send the signal through a 16-level uniform quantizer
[s_out,sq_out,sqh_out1,Delta,SQNR]=sampandquant(xsig,16,td,ts);
% obtained the PCM signal which is
%    - sampled, quantized, and zero-order hold signal sqh_out
% plot the orignal signal and the PCM signal in time domain 
figure(1);
subplot(211);sfig1=plot(t,xsig,'k',t,sqh_out1(1:Lsig),'b');
set(sfig1,'Linewidth',2);
title('Signal {\it g}({\it t}) and its 16 level PCM signal');
xlabel('time (sec.)');
% send the signal throuhg a 4-level uniform quantizer
[s_out,sq_out,sqh_out2,Delta,SQNR]=sampandquant(xsig,4,td,ts);
% obtained the PCM signal which is
%    - sampled, quantized, and zero-order hold signal sqh_out
% plot the orignal signal and the PCM signal in time domain 
subplot(212);sfig2=plot(t,xsig,'k',t,sqh_out2(1:Lsig),'b');
set(sfig2,'Linewidth',2);
title('Signal {\it g}({\it t}) and its 4 level PCM signal');
xlabel('time (sec.)');

Lfft=2^ceil(log2(Lsig)+1);
Fmax=1/(2*td);
Faxis=linspace(-Fmax,Fmax,Lfft);
SQH1=fftshift(fft(sqh_out1,Lfft));
SQH2=fftshift(fft(sqh_out2,Lfft));
% Now use LPF to filter the two PCM signals
BW=10; %Bandwidth is no larger than 10Hz
H_lpf=zeros(1,Lfft);H_lpf(Lfft/2-BW:Lfft/2+BW-1)=1; %ideal LPF
S1_recv=SQH1.*H_lpf; % ideal filtering
s_recv1=real(ifft(fftshift(S1_recv))); % reconstructed f-domain
s_recv1=s_recv1(1:Lsig);                % reconstructed t-domain
S2_recv=SQH2.*H_lpf; % ideal filtering
s_recv2=real(ifft(fftshift(S2_recv))); % reconstructed f-domain
s_recv2=s_recv2(1:Lsig);                % reconstructed t-domain
% Plot the filtered signals against the original signal
figure(2);
subplot(211); sfig3=plot(t,xsig,'b-',t,s_recv1,'b-.');
legend('original','recovered');
set(sfig3,'Linewidth',2);
title('Signal {\it g} ({\itt}) and filtered 16-level PCM signal');
xlabel('time (sec.)');
subplot(212); sfig4=plot(t,xsig,'b-',t,s_recv2,'b-.');
legend('original','recovered');
set(sfig4,'Linewidth',2);
title('Signal {\it g} ({\it t}) and filtered 4-level PCM signal');
xlabel('time (sec.)');

