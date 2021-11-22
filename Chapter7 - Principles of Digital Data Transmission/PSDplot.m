% (PSDplot.m)
% This example generates and plots power spectra of baseband
% data modulations.
%
clear;clf;
Nd=20000; % Number of bits in PAM
data = sign(randn(1,Nd)); % Generate Nd random bits
Tau=16; % Define the symbol period in samples
T=1.e-3; % symbol period in real time (second)
Tped=0.001; % true symbol period Tped in second
dataup=upsample(data, Tau); % Generate impulse train
yrz=conv(dataup,prz(Tau)); % Return to zero polar signal
yrz=yrz(1:end-Tau+1);
ynrz=conv(dataup,pnrz(Tau)); % Non-return to zero polar
ynrz=ynrz(1:end-Tau+1);
ysine=conv(dataup,psine(Tau)); % half sinusoid polar
ysine=ysine(1:end-Tau+1);

Td=4; % truncating raised cosine to 4 periods
yrcos=conv(dataup,prcos(0.5,Td,Tau)); % rolloff factor = 0.5
yrcos=yrcos(Td*Tau-Tau/2:end-2*Td*Tau+1); % generating RC pulse train

fovsamp=Tau; % range of frequency in units of 1/T
Nfft=1024;

% uncomment for octave
[PSD1,frq]=pwelch(yrcos,[],[],Nfft,fovsamp, 'twosided');
[PSD2,frq]=pwelch(yrz,[],[],Nfft,fovsamp, 'twosided');
[PSD3,frq]=pwelch(ynrz,[],[],Nfft,fovsamp, 'twosided');

%uncomment for MATLAB
%[PSD1,frq]=pwelch(yrcos,[],[],Nfft,'twosided',fovsamp);
%[PSD2,frq]=pwelch(yrz,[],[],Nfft,'twosided',fovsamp);
%PSD3,frq]=pwelch(ynrz,[],[],Nfft,'twosided',fovsamp);

freqscale=(frq-fovsamp/2);
%
Cor1=xcorr(yrcos,yrcos,50)/(Nd*Tau); %Autocorrelation estimate for rcos
Cor2=xcorr(yrz,yrz,50)/(Nd*Tau); %Autocorrelation estimate for RZ
Cor3=xcorr(ynrz,ynrz,50)/(Nd*Tau); %Autocorrelation estimate for NRZ
%
figure(1);subplot(121);
semilogy([1:Nfft]*(Tau/Nfft)-Tau/2,abs(fftshift(fft(Cor1,Nfft)/16)));
title('(a) Power spectrum via autocorrelation')
axis([-Tau/2 Tau/2 1.e-6 1.e1]);xlabel('frequency in 1/T Hz')
subplot(122)
semilogy(freqscale,fftshift(PSD1));
title('(b) Power spectrum via pwelch')
axis([-Tau/2 Tau/2 1.e-6 1.e1]);xlabel('frequency in 1/T Hz')
figure(2);subplot(121);
semilogy([1:Nfft]*(Tau/Nfft)-Tau/2,abs(fftshift(fft(Cor2,Nfft)/16)));
title('(a) Power spectrum via autocorrelation')
axis([-Tau/2 Tau/2 1.e-5 1.e1]);xlabel('frequency in 1/T Hz')
subplot(122);
semilogy(freqscale,fftshift(PSD2));
title('(b) Power spectrum via pwelch')
axis([-Tau/2 Tau/2 1.e-5 1.e1]);xlabel('frequency in 1/T Hz')
figure(3);subplot(121)
semilogy([1:Nfft]*(Tau/Nfft)-Tau/2,abs(fftshift(fft(Cor3,Nfft)/16)));
title('(a) Power spectrum via autocorrelation')
axis([-Tau/2 Tau/2 1.e-5 1.e1]);xlabel('frequency in 1/T Hz')
subplot(122);
semilogy(freqscale,fftshift(PSD3));
title('(b) Power spectrum via pwelch')
axis([-Tau/2 Tau/2 1.e-5 1.e1]);xlabel('frequency in 1/T Hz')