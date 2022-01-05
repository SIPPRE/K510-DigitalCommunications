% Matlab Program <ExQAM16.m>
% This Matlab exercise <ExQAM16.m.m> performs simulation of
% QAM-16 baseband polar transmission in AWGN channel.
% Root-raised cosine pulse of roll-off factor = 0.5 is used
% Matched filter receiver is designed to detect the symbols
% The program estimates the symbol error rate (BER) at different Eb/N
clear;clf;
L=1000000;
% Total data symbols in experiment is 1 million
% To display the pulse shape, we oversample the signal
% by factor of f_ovsamp=8
f_ovsamp=8;
% Oversampling factor vs data rate
delay_rc=4;
% Generating root-raised cosine pulseshape (roll-off factor = 0.5)

%prcos = rcosflt([1], 1, f_ovsamp, 'sqrt', 0.5, delay_rc);
%prcos=prcos(1:end-f_ovsamp+1);

nsamp = 2*f_ovsamp*delay_rc; t_limits=[-nsamp/2,nsamp/2]/f_ovsamp ;  
prcos = rcosfir1(0.5, t_limits,f_ovsamp,1,'sqrt') ; 

prcos=prcos/norm(prcos);pcmatch=prcos(end:-1:1);
% Generating random signal data for polar signaling
s_data=4*round(rand(L,1))+2*round(rand(L,1))-3+j*(4*round(rand(L,1))+2*round(rand(L,1))-3);
% upsample to match the
% ‘oversampling rate'
% which is f_ovsamp/T (T=1 is the symbol duration)
s_up=upsample(s_data,f_ovsamp);
% Identify the decision delays due to pulse shaping
% and matched filters
delayrc=2*delay_rc*f_ovsamp;
% Generate QAM-16 signaling with pulse-shaping
xrcos=conv(s_up,prcos);
% Find the signal length
Lrcos=length(xrcos);
SER=[];
noiseq=randn(Lrcos,1)+j*randn(Lrcos,1);
Es=10;
% symbol energy
% Generating the channel noise (AWGN)
for i=1:9,
Eb2N(i)=i*2;
%(Eb/N in dB)
Eb2N_num=10^(Eb2N(i)/10);
% Eb/N in numeral
Var_n=Es/(2*Eb2N_num);
%1/SNR is the noise variance
signois=sqrt(Var_n/2);
% standard deviation
awgnois=signois*noiseq;
% AWGN
% Add noise to signals at the channel output
yrcos=xrcos+awgnois;
% Apply matched filters first
z1=conv(yrcos,pcmatch);clear awgnois, yrcos;
% Sampling the received signal and acquire samples
z1=z1(delayrc+1:f_ovsamp:end);
% Decision based on the sign of the samples
dec1=sign(real(z1(1:L)))+sign(real(z1(1:L))-2)+sign(real(z1(1:L))+2)+...
j*(sign(imag(z1(1:L)))+sign(imag(z1(1:L))-2)+sign(imag(z1(1:L))+2));
% Now compare against the original data to compute BER for
% the three pulses
%BER=[BER;sum(abs(s_data-dec1))/(2*L)]
SER=[SER;sum(s_data~=dec1)/L];
Q(i)=3*0.5*erfc(sqrt((2*Eb2N_num/5)/2));
%Compute the Analytical BER
end
figure(1)
subplot(111)
figber=semilogy(Eb2N,Q,'k-',Eb2N,SER,'b-*');
axis([2 18 .99e-5 1]);
legend('Analytical', 'Root-raised cosine');
xlabel('E_b/N (dB)');ylabel('Symbol error probability');
set(figber,'Linewidth',2);
% Constellation plot
figure(2)
subplot(111)
plot(real(z1(1:min(L,4000))),imag(z1(1:min(L,4000))),'.', 'Linewidth', 6);
axis('square')
xlabel('Real part of matched filter output samples')
ylabel('Imaginary part of matched filter output samples')
