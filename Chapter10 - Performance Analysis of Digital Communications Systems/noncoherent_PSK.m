% MATLAB PROGRAM <ExDPSK.m>
% This program <ExDPSK.m> provides simulation for differential detection
% of binary DPSK. Differential detection only needs to compare the
% successive phases of the signal samples at the receiver
%
clear;clf
L=1000000;
%Number of data symbols in the simulation
s_data=round(rand(L,1));
% Generating initial random phase
initphase=[2*rand];
% differential modulation
s_denc=mod(cumsum([0;s_data]),2);
% define the phase divisible by pi
xphase=initphase+s_denc;
clear s_denc;
% modulate the phase of the signal
xmodsig=exp(j*pi*xphase); clear xphase;
Lx=length(xmodsig);
% Generating noise sequence
noiseq=randn(Lx,2);
BER=[];
BER_az=[];
% Generating the channel noise (AWGN)
for i=1:11,
  Eb2N(i)=i;
  %(Eb/N in dB)
  Eb2N_num=10^(Eb2N(i)/10);
  % Eb/N in numeral
  Var_n=1/(2*Eb2N_num);
  %1/SNR is the noise variance
  signois=sqrt(Var_n);
  % standard deviation
  awgnois=signois*(noiseq*[1;j]);
  % AWGN complex channels
  % Add noise to signals at the channel output
  ychout=xmodsig+awgnois;
  % Non-coherent detection
  yphase=angle(ychout);
  %find the channel output phase
  clear ychout;
  ydfdec=diff(yphase)/pi;
  %calculate phase difference
  clear yphase;
  dec=(abs(ydfdec)>0.5);
  %make hard decisions
  clear ydfdec;
  % Compute BER from simulation
  BER=[BER; sum(dec~=s_data)/L];
  % Compare against analytical BER.
  BER_az=[BER_az; 0.5*exp(-Eb2N_num)];
end
% now plot the results
figber=semilogy(Eb2N,BER_az,'k-',Eb2N,BER,'k-o');
axis([1 11 .99e-5 1]);
set(figber,'Linewidth',2);
legend('Analytical BER', 'Binary DPSK simulation');
fx=xlabel('E_b/N (dB)');
fy=ylabel('Bit error rate');
set(fx,'FontSize',11); set(fy,'Fontsize',11);