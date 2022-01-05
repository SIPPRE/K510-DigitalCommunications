% MATLAB PROGRAM <dfe.m>
% This is the receiver part of the QAM equalization
% that uses Decision feedback equalizer (DFE)
%
Ntrain=200; % Number of training symbols for Equalization
Nch=3; % Order of FIR channel (=length-1)

SEReq=[]; SERneq=[];
for i=1:13,
    Eb2N(i)=i*2-1;%(Eb/N in dB)
    Eb2N_num=10^(Eb2N(i)/10);% Eb/N in numeral
    Var_n=Es/(2*Eb2N_num);%1/SNR is the noise variance
    signois=sqrt(Var_n/2);% standard deviation
    z1=out_mf+signois*noisesamp;% Add noise
    
    Z=toeplitz(s_data(Nch+1:Ntrain),s_data(Nch+1:-1:1)); % signal matrix for computing R
    dvec=[z1(Nch+1:Ntrain)]; % build training data vector
    h_hat=pinv(Z'*Z)*Z'*dvec; % find channel estimate tap vector
    z1=z1/h_hat(1); % equalize the gain loss
    h_hat=h_hat(2:end)/h_hat(1); % set the leading tap to 1
    feedbk=zeros(1,Nch);
    for kj=1:L,
        zfk=feedbk*h_hat; % feedback data
        dsig(kj)=z1(kj)-zfk; % subtract the feedback
        % Now make decision after feedback
        d_temp=sign(real(dsig(kj)))+sign(real(dsig(kj))-2)+sign(real(dsig(kj))+2)+j*(sign(imag(dsig(kj)))+sign(imag(dsig(kj))-2)+sign(imag(dsig(kj))+2));
        feedbk=[d_temp feedbk(1:Nch-1)]; % update the feedback data
    end
    % Now compute the entire DFE decision after decision feedback
    dfeq=sign(real(dsig))+sign(real(dsig)-2)+sign(real(dsig)+2)+j*(sign(imag(dsig))+sign(imag(dsig)-2)+sign(imag(dsig)+2));
    dfeq=reshape(dfeq,L,1);
    % Compute the SER after decision feedback equalization
    SEReq=[SEReq;sum(s_data(1:L)~=dfeq)/L];
    % find the decision without DFE
    dneq=sign(real(z1(1:L)))+sign(real(z1(1:L))-2)+sign(real(z1(1:L))+2)+j*(sign(imag(z1(1:L)))+sign(imag(z1(1:L))-2)+sign(imag(z1(1:L))+2));
    % Compute the SER without equalization
    SERneq=[SERneq;sum(abs(s_data~=dneq))/(L)];
end