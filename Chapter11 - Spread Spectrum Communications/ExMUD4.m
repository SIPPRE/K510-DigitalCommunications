% MATLAB PROGRAM <ExMUD4.m>
% This program provides simulation for multiuser DS-CDMA signaling using
% coherent QPSK for 4 users.
%
%clear;clf
Ldata=10000; % data length in simulation; Must be divisible by 8
Lc=31; % spreading factor vs data rate
%User number = 4;
% Generate QPSK modulation symbols
data_sym=2*round(rand(Ldata,4))-1+j*(2*round(rand(Ldata,4))-1);
% Select 4 spreading codes (Gold Codes of Length 11)
gold31code;
pcode=GPN;
% Spreading codes are now in matrix pcode of 31x4
PowerMat=diag(sqrt([1 1 1 1]));
pcodew=pcode*PowerMat;
% Now spread
x_in=kron(data_sym(:,1),pcodew(:,1))+kron(data_sym(:,2),pcodew(:,2)) +...
kron(data_sym(:,3),pcodew(:,3))+kron(data_sym(:,4),pcodew(:,4));
% Signal power of the channel input is 2*Lc
% Generate noise (AWGN)
noiseq=randn(Ldata*Lc,1)+j*randn(Ldata*Lc,1); % Power is 2
BER1=[];
BER2=[];
BER3=[];
BER4=[];
BER_az=[];
for i=1:12,
Eb2N(i)=(i-1); %(Eb/N in dB)
Eb2N_num=10^(Eb2N(i)/10); % Eb/N in numeral
Var_n=Lc/(2*Eb2N_num); %1/SNR is the noise variance
signois=sqrt(Var_n); % standard deviation
awgnois=signois*noiseq; % AWGN
% Add noise to signals at the channel output
y_out=x_in+awgnois;
Y_out=reshape(y_out,Lc,Ldata).'; clear y_out awgnois;
% Despread first
z_out=Y_out*pcode;
% Decision based on the sign of the samples
dec=sign(real(z_out))+j*sign(imag(z_out));
% Now compare against the original data to compute BER
BER1=[BER1;sum([real(data_sym(:,1))~=real(dec(:,1));...
imag(data_sym(:,1))~=imag(dec(:,1))])/(2*Ldata)];
BER2=[BER2;sum([real(data_sym(:,2))~=real(dec(:,2));...
imag(data_sym(:,2))~=imag(dec(:,2))])/(2*Ldata)];
BER3=[BER3;sum([real(data_sym(:,3))~=real(dec(:,3));...
imag(data_sym(:,3))~=imag(dec(:,3))])/(2*Ldata)];
BER4=[BER4;sum([real(data_sym(:,4))~=real(dec(:,4));...
imag(data_sym(:,4))~=imag(dec(:,4))])/(2*Ldata)];
BER_az=[BER_az;0.5*erfc(sqrt(Eb2N_num))]; %analytical
end
BER=[BER1 BER2 BER3 BER4];
figure(1)
figber=semilogy(Eb2N,BER_az,'k-',Eb2N,BER1,'k-o',Eb2N,BER2,'k-s',...
Eb2N,BER3,'k-v',Eb2N,BER4,'k-*');
legend('Single-user (analysis)','User 1 BER','User 2 BER','User 3 BER','User 4 BER')
axis([0 12 0.99e-5 1.e0]);
set(figber,'LineWidth',2);
xlabel('E_b/N (dB)');ylabel('QPSK bit error rate')
title('4-user CDMA BER with Gold code of length 31');