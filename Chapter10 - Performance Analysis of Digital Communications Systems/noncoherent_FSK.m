% MATLAB PROGRAM <ExBFSK.m>
% This program <ExBFSK.m> provides simulation for noncoherent detection of
% orthogonal signaling including BFSK. Noncoherent MFSK detection
% only needs to compare the magnitude of each frequency bin.
L=100000;
%Number of data symbols in the simulation
s_data=round(rand(L,1));
% Generating random phases on the two frequencies
xbase1=[exp(j*2*pi*rand) 0];
xbase0=[0 exp(j*2*pi*rand)];
% Modulating two orthogonal frequencies
xmodsig=s_data*xbase1+(1-s_data)*xbase0;
% Generating noise sequences for both frequency channels
noisei=randn(L,2);
noiseq=randn(L,2);
BER=[];
BER_az=[];
% Generating the channel noise (AWGN)
for i=1:12,
  Eb2N(i)=i;
  %(Eb/N in dB)
  Eb2N_num=10^(Eb2N(i)/10);
  % Eb/N in numeral
  Var_n=1/(2*Eb2N_num);
  %1/SNR is the noise variance
  signois=sqrt(Var_n);
  % standard deviation
  awgnois=signois*(noisei+j*noiseq);
  % AWGN complex channels
  % Add noise to signals at the channel output
  ychout=xmodsig+awgnois;
  % Non-coherent detection
  ydim1=abs(ychout(:,1));
  ydim2=abs(ychout(:,2));
  dec=(ydim1>ydim2);
  % Compute BER from simulation
  BER=[BER; sum(dec~=s_data)/L];
  % Compare against analytical BER.
  BER_az=[BER_az; 0.5*exp(-Eb2N_num/2)];
end
figber=semilogy(Eb2N,BER_az,'k-',Eb2N,BER,'k-o');
set(figber,'Linewidth',2);
legend('Analytical BER', 'Noncoherent FSK simulation');
fx=xlabel('E_b/N (dB)');
fy=ylabel('Bit error rate');
set(fx,'FontSize',11); set(fy,'Fontsize',11);
