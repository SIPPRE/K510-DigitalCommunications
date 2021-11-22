% (PAM2_eye.m)
% generate binary PAM signals and plot eye diagrams
%
clear all;clf;
data = sign(randn(1,400)); % Generate 400 random bits
Tau=32;
% Define the symbol period
Tped=0.001;
% true symbol period Tped in second
dataup=upsample(data, Tau); % Generate impulse train
yrz=conv(dataup,prz(Tau)); % Return to zero polar signal
yrz=yrz(1:end-Tau+1);
ynrz=conv(dataup,pnrz(Tau)); % Non-return to zero polar
ynrz=ynrz(1:end-Tau+1);
ysine=conv(dataup,psine(Tau)); % half sinusoid polar
ysine=ysine(1:end-Tau+1);
Td=4;
% truncating raised cosine to 4 periods
yrcos=conv(dataup,prcos(0.5,Td,Tau)); % rolloff factor = 0.5
yrcos=yrcos(Td*Tau-Tau/2:end-2*Td*Tau+1); % generating RC pulse train
txis=(1:1000)/Tau;
figure(1)
subplot(311);w1=plot(txis,yrz(1:1000)); title('(a) RZ waveform');
axis([0 1000/Tau -1.5 1.5]); xlabel('time unit (T sec)');
subplot(312);w2=plot(txis,ysine(1:1000)); title('(b) Half-sine waveform');
axis([0 1000/Tau -1.5 1.5]); xlabel('time unit (T sec)');
subplot(313);w3=plot(txis,yrcos(1:1000)); title('(c) Raise-cosine waveform');
axis([0 1000/Tau -1.5 1.5]); xlabel('time unit (T sec)');
set(w1,'Linewidth',2);set(w2,'Linewidth',2);set(w3,'Linewidth',2);
Nwidth=2;
% Eye diagram width in units of T
edged=1/Tau;
% Make viewing window slightly wider
figure(2);
subplot(221)
eye1=eyeplot(yrz,Nwidth,Tau,0);title('(a) RZ eye diagram')
axis([-edged Nwidth+edged, -1.5, 1.5]);xlabel('time unit (T second)');
subplot(222)
eye2=eyeplot(ynrz,Nwidth,Tau,0.5);title('(b) NRZ eye diagram');
axis([-edged Nwidth+edged, -1.5, 1.5]);xlabel('time unit (T second)');
subplot(223)
eye3=eyeplot(ysine,Nwidth,Tau,0); title('(c) Half-sine eye diagram');
axis([-edged Nwidth+edged, -1.5, 1.5]);xlabel('time unit (T second)');
subplot(224)
eye4=eyeplot(yrcos,Nwidth,Tau,edged+0.5); title('(d) Raised-cosine eye diagram');
axis([-edged Nwidth+edged, -1.5, 1.5]);xlabel('time unit (T second)');