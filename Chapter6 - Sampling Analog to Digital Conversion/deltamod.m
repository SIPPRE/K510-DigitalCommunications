% (deltamod.m)
function s_DMout=deltamod(sig_in,Delta,td,ts)
%   Usage
%       s_DMout = deltamod(sig_in,Delta,td,ts)
%   Delta - DM stepsize
%   sig_in - input signal vector
%   td - original signal sampling period of sig_in
%   ts - new sampling period
% NOTE: td*fs must be a positive integer;
%   Function outputs:
%       s_DMout - DM sampled output
if (rem(ts/td,1)==0)
    nfac=round(ts/td);
    p_zoh=ones(1,nfac);
    s_down=downsample(sig_in,nfac);
    Num_it=length(s_down);
    s_DMout(1)=-Delta/2;
    for k=2:Num_it
        xvar=s_DMout(k-1);
        s_DMout(k)=xvar+Delta*sign(s_down(k-1)-xvar);
    end
    s_DMout=kron(s_DMout,p_zoh);
else
    warning('Error! ts/td is not an integer!');
    s_DMout=[];
end
end