% MATLAB PROGRAM <ExMUDDecFB.m>
% This program provides simulation for multiuser CDMA
% systems. The 4 users have different powers to illustrate the
% near-far effect in single user conventional receivers
%
% Decision feedback detectors are tested to show its
% ability to overcome the near-far problem.
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
% Now spread
x_in=kron(data_sym(:,1),pcodew(:,1))+kron(data_sym(:,2),pcodew(:,2)) +...
kron(data_sym(:,3),pcodew(:,3))+kron(data_sym(:,4),pcodew(:,4));
% Signal power of the channel input is 2*Lc
% Generate noise (AWGN)
noiseq=randn(Ldata*Lc,1)+j*randn(Ldata*Lc,1); % Power is 2
BER_c2=[];
BER2=[];
BER_c4=[];
BER4=[];
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
% Despread first
z_out=Y_out*pcode; % despreader (conventional) output
clear Y_out;
% Decision based on the sign of the single receivers
dec=sign(real(z_out))+j*sign(imag(z_out));
% Decision based on the sign of the samples
dec1=sign(real(z_out(:,1)))+j*sign(imag(z_out(:,1)));
z_fk1=z_out-dec1*Rcor(1,:);
dec3=sign(real(z_fk1(:,3)))+j*sign(imag(z_fk1(:,3)));
z_fk2=z_fk1-dec3*Rcor(3,:);
dec2=sign(real(z_fk2(:,2)))+j*sign(imag(z_fk2(:,2)));
z_fk3=z_fk2-dec2*Rcor(2,:);
dec4=sign(real(z_fk3(:,4)))+j*sign(imag(z_fk3(:,4)));
% Now compare against the original data to compute BER
BER_c2=[BER_c2;sum([real(data_sym(:,2))~=real(dec(:,2));...
imag(data_sym(:,2))~=imag(dec(:,2))])/(2*Ldata)];
BER2=[BER2;sum([real(data_sym(:,2))~=real(dec2);...
imag(data_sym(:,2))~=imag(dec2)])/(2*Ldata)];
BER_c4=[BER_c4;sum([real(data_sym(:,4))~=real(dec(:,4));...
imag(data_sym(:,4))~=imag(dec(:,4))])/(2*Ldata)];
BER4=[BER4;sum([real(data_sym(:,4))~=real(dec4);...
imag(data_sym(:,4))~=imag(dec4)])/(2*Ldata)];
BER_az=[BER_az;0.5*erfc(sqrt(Eb2N_num))]; %analytical
end
clear z_fk1 z_fk2 z_fk3 dec1 dec3 dec2 dec4 x_in y_out noiseq;
figure(1)
figber=semilogy(Eb2N,BER_az,'k-',Eb2N,BER_c2,'k-o',Eb2N,BER_c4,'k-s',...
Eb2N,BER2,'k--o',Eb2N,BER4,'k--s');
legend('Single-user (analysis)','User 2 (single user detector)',...
'User 4 (single user detector)','User 2 (decision feedback)',...
'User 4 (decision feedback)')
axis([0 12 0.99e-5 1.e0]);
set(figber,'LineWidth',2);
xlabel('E_b/N (dB)');ylabel('QPSK bit error rate')
title('Weak-user BER comparisons');