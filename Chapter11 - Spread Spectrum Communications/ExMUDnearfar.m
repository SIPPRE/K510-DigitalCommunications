% MATLAB PROGRAM <ExMUDnearfar.m>
% This program provides simulation for multiuser CDMA system
% that experiences the near-far effect due to user Tx power
% variations.
%
% Decorrelator receivers are
% applied to mitigate the near-far effect
%
%clear;clf
Ldata=100000; % data length in simulation; Must be divisible by 8
Lc=31; % spreading factor vs data rate
%User number = 4;
% Generate QPSK modulation symbols
data_sym=2*round(rand(Ldata,4))-1+j*(2*round(rand(Ldata,4))-1);
% Select 4 spreading codes (Gold Codes of Length 11)
gold31code;
pcode=GPN;
% Spreading codes are now in matrix pcode of 31x4
PowerMat=diag(sqrt([10 1 5 1]));
pcodew=pcode*PowerMat;
Rcor=pcodew'*pcodew;
Rinv=pinv(Rcor);
% Now spread
x_in=kron(data_sym(:,1),pcodew(:,1))+kron(data_sym(:,2),pcodew(:,2)) +...
kron(data_sym(:,3),pcodew(:,3))+kron(data_sym(:,4),pcodew(:,4));
% Signal power of the channel input is 2*Lc
% Generate noise (AWGN)
noiseq=randn(Ldata*Lc,1)+j*randn(Ldata*Lc,1); % Power is 2
BERb2=[];
BERa2=[];
BERb4=[];
BERa4=[];
BER_az=[];
for i=1:13,
Eb2N(i)=(i-1); %(Eb/N in dB)
Eb2N_num=10^(Eb2N(i)/10); % Eb/N in numeral
Var_n=Lc/(2*Eb2N_num); %1/SNR is the noise variance
signois=sqrt(Var_n); % standard deviation
awgnois=signois*noiseq; % AWGN
% Add noise to signals at the channel output
y_out=x_in+awgnois;
Y_out=reshape(y_out,Lc,Ldata).'; clear y_out awgnois;
% Despread first and apply decorrelator Rinv
z_out=(Y_out*pcode); % despreader (conventional) output
clear Y_out;
z_dcr=z_out*Rinv; % decorrelator output
% Decision based on the sign of the single receivers
dec1=sign(real(z_out))+j*sign(imag(z_out));
dec2=sign(real(z_dcr))+j*sign(imag(z_dcr));
% Now compare against the original data to compute BER of user 2
% and user 4 (weaker ones).
BERa2=[BERa2;sum([real(data_sym(:,2))~=real(dec1(:,2));...
imag(data_sym(:,2))~=imag(dec1(:,2))])/(2*Ldata)];
BERa4=[BERa4;sum([real(data_sym(:,4))~=real(dec1(:,4));...
imag(data_sym(:,4))~=imag(dec1(:,4))])/(2*Ldata)];
BERb2=[BERb2;sum([real(data_sym(:,2))~=real(dec2(:,2));...
imag(data_sym(:,2))~=imag(dec2(:,2))])/(2*Ldata)];
BERb4=[BERb4;sum([real(data_sym(:,4))~=real(dec2(:,4));...
imag(data_sym(:,4))~=imag(dec2(:,4))])/(2*Ldata)];
BER_az=[BER_az;0.5*erfc(sqrt(Eb2N_num))]; %analytical
end
figure(1)
figber=semilogy(Eb2N,BER_az,'k-',Eb2N,BERa2,'k-o',Eb2N,BERa4,' k-s',...
Eb2N,BERb2,'k--o',Eb2N,BERb4,'k--s');
legend('Single-user (analysis)','User 2 (single user detector)',...
'User 4 (single user detector)','User 2 (decorrelator)',...
'User 4 (decorrelator)')
axis([0 12 0.99e-5 1.e0]);
set(figber,'LineWidth',2);
xlabel('E_b/N (dB)');ylabel('QPSK bit error rate')
title('Weak-user BER comparisons');