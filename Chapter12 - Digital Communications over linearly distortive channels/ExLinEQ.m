% Matlab Program <ExLinEQ.m>
% This Matlab exercise <ExLinEQ.m> performs simulation of
% linear equalization under 16-QAM baseband transmission
% a multipath channel with AWGN.
% Correct carrier and synchronization is assumed.
% Root-raised cosine pulse of rolloff factor = 0.5 is used
% Matched filter is applied at the receiver front end.
% The program estimates the symbol error rate (SER) at different Eb/N

clear;
L=1000000; % Total data symbols in experiment is 1 million
% To display the pulseshape, we oversample the signal by factor of f_ovsamp=8
f_ovsamp=8;
% Oversampling factor vs data rate
delay_rc=10;
% Generating root-raised cosine pulseshape (rolloff factor = 0.5)
% Generating root-raised cosine pulseshape (roll-off factor = 0.5)

%prcos = rcosflt([1], 1, f_ovsamp, 'sqrt', 0.5, delay_rc);
%prcos=prcos(1:end-f_ovsamp+1);

nsamp = 2*f_ovsamp*delay_rc; t_limits=[-nsamp/2,nsamp/2]/f_ovsamp ;  
prcos = rcosfir1(0.5, t_limits,f_ovsamp,1,'sqrt') ; 

prcos=prcos/norm(prcos); % normalize
pcmatch=prcos(end:-1:1); % MF

% Generating random signal data for polar signaling
s_data=4*round(rand(L,1))+2*round(rand(L,1))-3+j*(4*round(rand(L,1))+2*round(rand(L,1))-3);
% upsample to match the 'oversampling rate' (normalize by 1/T).
% It is f_ovsamp/T (T=1 is the symbol duration)
s_up=upsample(s_data,f_ovsamp);
% Identify the decision delays due to pulse shaping and matched filters
delayrc=2*delay_rc*f_ovsamp;
% Generate polar signaling of different pulse-shaping
xrcos=conv(s_up,prcos);
[c_num,c_den] = cheby2(12,20,(1+0.5)/8);

% The next commented line finds frequency response
%[H,fnlz]=freqz(c_num,c_den,512,8);

% The lowpass filter is the Tx filter before signal is sent to channel
xchout=filter(c_num,c_den,xrcos);

% We can now plot the power spectral densities of the two signals
% xrcos and xchout
% This shows the filtering effect of the Tx filter before
% transmission in terms of the signal power spectral densities
% It shows how little lowpass Tx filter may have distorted the signal
plotPSD_comparison

% Apply a 2-ray multipath channel
mpath=[1 0 0 -0.65]; % multipath delta(t)-0.65 delta(t-3T/8)

% time-domain multipath channel
h=conv(conv(prcos,pcmatch),mpath);
hscale=norm(h);
xchout=conv(mpath,xchout); % apply 2-ray multipath
xrxout=conv(xchout,pcmatch); % send the signal through matched filter separately from the noise
delaychb=delayrc+3;
out_mf=xrxout(delaychb+1:f_ovsamp:delaychb+L*f_ovsamp);
clear xrxout;

% Generate complex random noise for channel output
noiseq=randn(L*f_ovsamp,1)+j*randn(L*f_ovsamp,1); % send AWGN noise into matched filter first

noiseflt=filter(pcmatch,[1],noiseq);
clear noiseq;

% Generate sampled noise after matched filter before scaling it and adding to the QAM signal
noisesamp=noiseflt(1:f_ovsamp:L*f_ovsamp,1);
clear noiseq noiseflt;
Es=10*hscale; % symbol energy

% Call linear equalizer receiver to work 
linear_eq
for ii=1:10;
    Eb2Naz(ii)=2*ii-2;
    Q(ii)=3*0.5*erfc(sqrt((2*10^(Eb2Naz(ii)*0.1)/5)/2));
    %Compute the Analytical BER
end
% Now plot results
plotQAM_result

