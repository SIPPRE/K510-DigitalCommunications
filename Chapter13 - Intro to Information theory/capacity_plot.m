% Matlab program <capacity_plot.m>
clear;clf;
Channel_gain=1;
H=Channel_gain; % AWGN Channel gain
SNRdb=0:5:20;
% SNR in dB
L=1000000;
SNR=10.^(SNRdb/10);
% Compute the analytical channel capacity
Capacity=1/2*log(1+H*SNR)/log(2);
% Now to estimate the mutual information between the input
% and the output signals of AWGN channels
for kk=1:length(SNRdb),
    noise=randn(L,1)/sqrt(SNR(kk));
    x=randn(L,1);
    x1=sign(x);
    x2=(floor(rand(L,1)*4-4.e-10)*2-3)/sqrt(5);
    x3=(floor(rand(L,1)*8-4.e-10)*2-7)/sqrt(21);
    x4=(rand(L,1)-0.5)*sqrt(12);
    muinfovec(kk,1)=mutualinfo(x,x+noise);   %Gaussian input
    muinfovec(kk,2)=mutualinfo(x1,x1+noise); % Binary input (-1,+1)
    muinfovec(kk,3)=mutualinfo(x2,x2+noise); % 4-PAM input (-3,-1,1,3)
    muinfovec(kk,4)=mutualinfo(x3,x3+noise); % 8-PAM input (-7,-5,-3,-1,1,3,5,7)
    muinfovec(kk,5)=mutualinfo(x4,x4+noise); % Uniform input(-0.5,0.5)
end
plot(SNRdb,Capacity,'k-d');hold on
plot(SNRdb,muinfovec(:,1),'k-o')
plot(SNRdb,muinfovec(:,2),'k-s')
plot(SNRdb,muinfovec(:,3),'k-v')
plot(SNRdb,muinfovec(:,4),'k-x')
plot(SNRdb,muinfovec(:,5),'k-*')
xlabel('SNR (dB)');ylabel('mutual information (bits/sample)')
legend('Capacity','Gaussian','binary','PAM-4','PAM-8','uniform','Location','NorthWest')
hold off
