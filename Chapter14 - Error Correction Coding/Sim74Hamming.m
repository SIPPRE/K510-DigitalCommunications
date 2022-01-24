% Matlab Program <Sim74Hamming.m>
% Simulation of the Hamming (7,4) code performance
% under polar signaling in AWGN channel and performance
% comparison with uncoded polar signaling
clf;clear sigcw BER_uncode BER_coded
G=[1 0 0 0 1 0 1 % Code Generator
0 1 0 0 1 1 1
0 0 1 0 1 1 0
0 0 0 1 0 1 1];

H=[1 1 1 0 1 0 0 % Parity Check Matrix
0 1 1 1 0 1 0
1 1 0 1 0 0 1];

E=[1 0 0 0 0 0 0 % Error patterns
0 1 0 0 0 0 0
0 0 1 0 0 0 0
0 0 0 1 0 0 0
0 0 0 0 1 0 0
0 0 0 0 0 1 0
0 0 0 0 0 0 1
0 0 0 0 0 0 0];

K2=size(E,1);
Syndrome=mod(mtimes(E,H'),2); % Syndrome list
L1=25000;K=4*L1; %Decide how many codewords
sig_b=round(rand(1,K)); %Generate message bits
sig_2=reshape(sig_b,4,L1); %4 per column for FEC
xig_1=mod(G'*sig_2,2); %Encode column by column
xig_2=2*reshape(xig_1,1,7*L1)-1; %P/S conversion

AWnoise1=randn(1,7*L1); %Generate AWGN for coded Tx
AWnoise2=randn(1,4*L1); %Generate AWGN for uncoded Tx

% Change SNR and compute BER's
for ii=1:14
    SNRdb=ii;
    SNR=10^(SNRdb*0.1);
    xig_n=sqrt(SNR*4/7)*xig_2+AWnoise1; %Add AWGN and adjust SNR
    rig_1=(1+sign(xig_n))/2; %Hard decisions
    r=reshape(rig_1,7,L1)'; %S/P to form 7 bit codewords
    x=mod(r*H',2); % generate error syndromes
    for k1=1:L1,
        for k2=1:K2,
            if Syndrome(k2,:)==x(k1,:),
                idxe=k2; %find the Syndrome index
            end
        end
        error=E(idxe,:); %look up the error pattern
        cword=xor(r(k1,:),error); %error correction
        sigcw(:,k1)=cword(1:4); %keep the message bits
    end
    cw=reshape(sigcw,1,K);
    BER_coded(ii)=sum(abs(cw-sig_b))/K; % Coded BER on info bits

    % Uncoded Simulation Without Hamming code
    xig_3=2*sig_b-1; %Polar signaling
    xig_m=sqrt(SNR)*xig_3+AWnoise2; %Add AWGN and adjust SNR
    rig_1=(1+sign(xig_m))/2; %Hard decision
    BER_uncode(ii)=sum(abs(rig_1-sig_b))/K; %Compute BER
end
EboverN=[1:14]-3; % Need to note that SNR = 2 Eb/N

figc = semilogy(EboverN, BER_coded, '--', EboverN, BER_uncode);
grid on ; 
set(figc,'LineWidth',2);
legend('Coded','Uncoded');
title('BER comparison');
axis([0 10 1.e-5 1]);hold off;
xlabel('E_b/N, dB');ylabel('BER');