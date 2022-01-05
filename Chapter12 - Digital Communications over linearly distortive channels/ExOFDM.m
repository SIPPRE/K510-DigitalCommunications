% Matlab Program <ExOFDM.m>
% This Matlab exercise <ExOFDM.m> performs simulation of
% an OFDM system that employs 16-QAM baseband signaling
% a multipath channel with AWGN.
% Correct carrier and synchronization is assumed.
clear;clf;
L=1600000; % Total data symbols in experiment is 1 million
num_subcarrier=64;
cycle_prefix = 5 ; 

Lfr=L/num_subcarrier; % number of data frames

% Generating random signal data for polar signaling
s_data=4*round(rand(L,1))+2*round(rand(L,1))-3+j*(4*round(rand(L,1))+2*round(rand(L,1))-3);

channel=[0.3 -0.5 0 1 .2 -0.3];% channel in t-domain
hf=fft(channel,num_subcarrier); % find the channel in f-domain

p_data=reshape(s_data,num_subcarrier,Lfr); % S/P conversion
p_td=ifft(p_data);% IDFT to convert to t-domain
p_cyc=[p_td(end-(cycle_prefix-1):end,:);p_td]; % add cyclic prefix
s_cyc=reshape(p_cyc,(num_subcarrier+cycle_prefix)*Lfr,1); % P/S conversion

Psig=10/num_subcarrier; % average channel input power
chsout=filter(channel,1,s_cyc); % generate channel output signal
clear p_td p_cyc s_data s_cyc; % release some memory

noiseq=(randn((num_subcarrier+cycle_prefix)*Lfr,1)+j*randn((num_subcarrier+cycle_prefix)*Lfr,1));
SEReq=[];

for ii=1:(num_subcarrier-1),
    SNR(ii)=ii-1; % SNR in dB
    Asig=sqrt(Psig*10^(-SNR(ii)/10))*norm(channel);
    x_out=chsout+Asig*noiseq; % Add noise
    x_para=reshape(x_out,(num_subcarrier+cycle_prefix),Lfr); % S/P conversion
    x_disc=x_para((cycle_prefix+1):(cycle_prefix+num_subcarrier),:); % discard tails
    xhat_para=fft(x_disc); % FFT back to f-domain
    z_data=inv(diag(hf))*xhat_para; % f-domain equalizing
    
    % compute the QAM decision after equalization
    deq=sign(real(z_data))+sign(real(z_data)-2)+sign(real(z_data)+2)+j*(sign(imag(z_data))+sign(imag(z_data)-2)+sign(imag(z_data)+2));
    % Now compare against the original data to compute SER
    SEReq=[SEReq sum(p_data~=deq,2)/Lfr];
end
for ii=1:9,
    SNRa(ii)=2*ii-2;
    Q(ii)=3*0.5*erfc(sqrt((2*10^(SNRa(ii)*0.1)/5)/2)); %Compute the Analytical BER
end
% call another program to display OFDM Analysis
ofdmAz
