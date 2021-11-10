% (uniquan.m)
function [q_out, Delta,SQNR]=uniquan(sig_in,L)
%   Usage
%   [q_out, Delta,SQNR]=uniquan(sig_in,L)
%   L  -  number of uniform quantization levels
%   sig_in  -  input signal vector
%   Function ouputs:
%            q_out - quantized output
%            Delta - quantization interval
%            SQNR  - actual signal to quantization noise ratio
sig_pmax=max(sig_in);% finding the positive peak;
sig_nmax=min(sig_in);% finding the negative peak
Delta=(sig_pmax-sig_nmax)/L; % quantization interval
q_level=sig_nmax+Delta/2:Delta:sig_pmax-Delta/2;% dfine Q-levels
L_sig=length(sig_in); % find signal length
sigp=(sig_in-sig_nmax)/Delta+1/2;% convert into 1/2 to L+1/2 range
qindex=round(sigp); % round to 1,2,... L levels
qindex=min(qindex,L); % eleminate L+1 as a rare possibility
q_out=q_level(qindex);% use index vector to generate output
SQNR=20*log10(norm(sig_in)/norm(sig_in-q_out));% actual SQNR value
end
