% MATLAB PROGRAM <ExDSSS.m>
% This program provides simulation for DS-CDMA signaling using
% coherent QAM detection.
% To illustrate the CDMA spreading effect, a single user is spread by
% PN sequence of different lengths. Jamming is added as a narrowband;
% Changing spreading gain Lc;
clear;clf
Ldata=20000; % data length in simulation; Must be divisible by 8
Lc=11; % spreading factor vs data rate
% can also use the shorter Lc=7
% Generate QPSK modulation symbols
data_sym=2*round(rand(Ldata,1))-1+j*(2*round(rand(Ldata,1))-1);
jam_data=2*round(rand(Ldata,1))-1+j*(2*round(rand(Ldata,1))-1);
% Generating a spreading code
pcode=[1 1 1 -1 -1 -1 1 -1 -1 1 -1]';
% Now spread
x_in=kron(data_sym,pcode);
% Signal power of the channel input is 2*Lc
% Jamming power is relative
SIR=10; % SIR in dB
Pj=2*Lc/(10^(SIR/10));
% Generate noise (AWGN)
noiseq=randn(Ldata*Lc,1)+j*randn(Ldata*Lc,1); % Power is 2
% Add jamming sinusoid sampling frequency is fc = Lc
jam_mod=kron(jam_data,ones(Lc,1)); clear jam_data;
jammer= sqrt(Pj/2)*jam_mod.*exp(j*2*pi*0.12*(1:Ldata*Lc)).'; %fj/fc=0.12.
clear jam_mod;
[P,x]=pwelch(x_in,[],[],[4096],Lc,'twoside');
figure(1);
semilogy(x-Lc/2,fftshift(P));
axis([-Lc/2 Lc/2 1.e-2 1.e2]);
grid;
xfont=xlabel('frequency (in unit of 1/T_s)');
yfont=ylabel('CDMA signal PSD');
set(xfont,'FontSize',11);set(yfont,'FontSize',11);
[P,x]=pwelch(jammer+x_in,[],[],[4096],Lc,'twoside');
figure(2);semilogy(x-Lc/2,fftshift(P));
grid;
axis([-Lc/2 Lc/2 1.e-2 1.e2]);
xfont=xlabel('frequency (in unit of 1/T_s)');
yfont=ylabel('CDMA signal + narrowband jammer PSD');
set(xfont,'FontSize',11);set(yfont,'FontSize',11);
BER=[];
BER_az=[];
for i=1:10,
Eb2N(i)=(i-1); %(Eb/N in dB)
Eb2N_num=10^(Eb2N(i)/10); % Eb/N in numeral
Var_n=Lc/(2*Eb2N_num); %1/SNR is the noise variance
signois=sqrt(Var_n); % standard deviation
awgnois=signois*noiseq; % AWGN
% Add noise to signals at the channel output
y_out=x_in+awgnois+jammer;
Y_out=reshape(y_out,Lc,Ldata).'; clear y_out awgnois;
% Despread first
z_out=Y_out*pcode;
% Decision based on the sign of the samples
dec1=sign(real(z_out))+j*sign(imag(z_out));
% Now compare against the original data to compute BER
BER=[BER;sum([real(data_sym)~=real(dec1);...
imag(data_sym)~=imag(dec1)])/(2*Ldata)];
BER_az=[BER_az;0.5*erfc(sqrt(Eb2N_num))]; %analytical
end
figure(3)
figber=semilogy(Eb2N,BER_az,'k-',Eb2N,BER,'k-o');
legend('No jamming','Narrowband jamming (-10 dB)');
set(figber,'LineWidth',2);
xfont=xlabel('E_b/N (dB)');
yfont=ylabel('Bit error rate');
title('DSSS (CDMA) with spreading gain = 11');
