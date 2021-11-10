% (sampandquant.m)
function [s_out,sq_out,sqh_out,Delta,SQNR]=sampandquant(sig_in,L,td,ts)
%   Usage
%        [s_out,sq_out,sqh_out,Delta,SQNR]=sampandquant(sig_in,L,td,ts)
%   L - number of uniform quantization levels
%   sig_in - input signal vector
%   td - original signal sampling period of sig_in
%   ts - new sampling period
% NOTE: td*fs must be a positive integer;
%   Function outputs:
%            s_out - sampled output
%            sq_out - sample-and-quantized output
%            sqh_out - sample,quantize, and hold output
%            Delta - quantization interval
%            SQNR - actual signal to quantization noise ratio

if (rem(ts/td,1)==0)
    nfac=round(ts/td);
    p_zoh=ones(1,nfac);
    s_out=downsample(sig_in,nfac);
    [sq_out,Delta,SQNR]=uniquan(s_out,L);
    s_out=upsample(s_out,nfac);
    sqh_out=kron(sq_out,p_zoh);
else
    warning('Errors! ts/td is not an integer!');
    s_out=[];sq_out=[];sqh_out=[];Delta=[];SQNR=[];
end
end