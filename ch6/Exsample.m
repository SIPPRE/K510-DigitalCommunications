% (Exsample.m)
% Example of sampling, quantization, and zero-order hold
close all; clear all; clc;
td=0.002; % original sampling rate 500 Hz
t=0:td:1;
xsig=sin(2*pi*t)-sin(6*pi*t); % 1Hz+3Hz sinusoids
Lsig=length(xsig);

ts=0.02; % new sampling rate = 50Hz
Nfactor=ts/td;
% send the signal hrough a 16-level uniform quantizer
[s_out,sq_out,sqh_out,Delta,SQNR]=sampandquant(xsig,16,td,ts);
% receive 3 signals:
% 1. sampled signal s_out
% 2. sampled and quantized signal sq_out
% 3. sampled, quantized, and zero-order hold signal sqh_out
% calculate the Fourier transforms
Lfft=2^ceil(log2(Lsig)+1);
Fmax=1/(2*td);
Faxis=linspace(-Fmax,Fmax,Lfft);
Xsig=fftshift(fft(xsig,Lfft));
S_out=fftshift(fft(s_out,Lfft));
% Examples of sampling and reconstruction using
% (a) ideal impluse train through LPF
% (b) flat top pulse reconstruction through LPF
%  plot the roginal signal and the sample signals in time and frequency
%  domain.
figure(1);
subplot(311); sfigla=plot(t,xsig,'k');
hold on; sfig1b=plot(t,s_out(1:Lsig),'b');hold off;
set(sfigla,'Linewidth',2); set(sfig1b,'Linewidth',2.);
xlabel('time (sec)');
title('Signal {\it g} (\it t) and its uniform samples');
subplot(312);sfig1c=plot(Faxis,abs(Xsig));
xlabel(' frequency (Hz)');
axis([-150 150 0 300]);
set(sfig1c,'Linewidth',1); title('Spectrum of {\it g}({\it t})');
subplot(313); sfig1d=plot(Faxis,abs(S_out));
xlabel('frequency (Hz)');
axis([-150 150 0 300/Nfactor]);
set(sfig1c,'Linewidth',1); title('Spectrum of {\it g}_T({\it t})');

% calculate the reconstructed signal from ideal sampling and ideal LPF
% Maximum LPF bandwidth equals to BW=floor((Lfft/Nfactor)/2);
BW=10; % Bandwidth is no larger than 10Hz
H_lpf=zeros(1,Lfft); H_lpf(Lfft/2-BW:Lfft/2+BW-1)=1; %ideal LPF
S_recv=Nfactor*S_out.*H_lpf; % ideal filtering
s_recv=real(ifft(fftshift(S_recv)));% reconstructed f-domain
s_recv=s_recv(1:Lsig); % reconstructed t-domian
% plot the ideally reconstructed signal in time and frequency domain
figure(2)
subplot(211); sfig2a=plot(Faxis,abs(S_recv));
xlabel('frequency (Hz)');
axis([-150 150 0 300]);
title('Spectrum of ideal filtering (reconstruction)');
subplot(212); sfig2b=plot(t,xsig,'k-.',t,s_recv(1:Lsig),'b');
legend('Original signal','Reconstructed signal');
xlabel('time (sec)');
title('Original signal versus ideally reconstructed signal');
set(sfig2b,'Linewidth',2);
% noe-ideal reconstruction
ZOH=ones(1,Nfactor);
s_ni=kron(downsample(s_out,Nfactor),ZOH);
S_ni=fftshift(fft(s_ni,Lfft));
S_recv2=S_ni.*H_lpf;  % ideal filtering
s_recv2=real(ifft(fftshift(S_recv2))); % reconstructed f-domain
s_recv2=s_recv2(1:Lsig);               % reconstructed t-domain

% plot the ideally reconstructed signal in time and frequency domain
figure(3)
subplot(211); sfig3a=plot(t,xsig,'b',t,s_ni(1:Lsig),'b');
xlabel('time (sec)');
title('original signal versus flat-top reconstruction');
subplot(212);sfig3b=plot(t,xsig,'b',t,s_recv2(1:Lsig),'b--');
legend('Original signal','LPF reconstruction');
xlabel('time(sec)');
set(sfig3a,'Linewidth',2); set(sfig3b,'Linewidth',2);
title('original and flat-top recosntruction after LPF');

