% Copyright (C) 2016 Oscar Monerris Belda
% 
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% -*- texinfo -*- 
% @deftypefn {Function File} {@var{h} =} rcosfir(@var{R},@var{nT},@var{rate},@var{T},@var{filterType})
%
% Implements a cosine filter or root cosine filter impulse response
%
% @var{R} Roll-off factor
%
% @var{nT}  scalar vector of length 2 such as N = (nT(2)-nT(1))*rate+1
%
% @var{T} symbol rate 
%
% @var{filterType} 'normal' or 'sqrt'
%
% @var{h} impulse response
%
%
% Example:
%
% h = rcosfir(0.2,[-3 3],4,1,'sqrt');
% @seealso{filter, downsample, rectfilt}
% @end deftypefn

% Author: Oscar Monerris Belda <osmobel@osmobel-XPS-M1330>
% Created: 2016-05-29

function h = rcosfir1(R,nT,rate,T,filterType)


if (nargin < 1)
    error('rcosfir: Not enough input arguments');
elseif (nargin == 1)
    nT=[-3 3];
    rate=5;
    T=1;
    filterType ='normal';
elseif (nargin == 2)       
    rate=5;
    T=1;
    filterType ='normal';
elseif (nargin == 3)         
    T=1;
    filterType ='normal';
elseif (nargin == 4)
    filterType ='normal';    
end
if (numel(nT) == 1)
    nT = [-nT nT];
end

if (fix(rate) ~= rate || rate < 1)
    error('rcosfir: rate must be an integer greater than 1')
end

if (numel(nT) ~= 2)
   error('rcosfir: nT must be a two elements vector')
end

if (T < 0)
   error('rcosfir: T must be greater than zero')
end

if (~strcmpi(filterType,{'normal','sqrt'}))
    error('rcosfir: filter type must be ''normal'' or ''sqrt''')
end

N = (nT(2)-nT(1))*rate+1;

if (mod(N,2) == 0)
   error('rcosfir: filter order (nT(2)-nT(1))*rate + 1 must be odd') 
end

n = -(N-1)/2:(N-1)/2;

n = n/(rate);

if strcmpi(filterType,'normal')
    % Raised cosine
    h = sinc(n).*cos(pi*R*n)./(1-(2*R*n).^2);
    id = rate*T/(2*R);
    if (abs(fix(id) - id) < eps)
       h(0.5*(N+1)+id) = sinc(1/(2*R))*pi/4;
       h(0.5*(N+1)-id) = h(0.5*(N+1)+id);
    end    
else
% Root raised cosine
    h = (sin(pi*n*(1-R)) + 4*R*n.*cos(pi*n*(1+R)))./(pi*n.*(1-(4*R*n).^2))/T;
    
    % Singularity h(0)
    h(0.5*(N+1)) = (1-R+4*R/pi)/T;
    
    % Singularities h(-rate*T/(4*R)) and h(rate*T/(4*R))
    id = rate*T/(4*R);       
    if (abs(fix(id) - id) < eps)
       h(0.5*(N+1)+id) = R*((1+2/pi)*sin(pi/(4*R))+(1-2/pi)*cos(pi/(4*R)))/(sqrt(2)*T);
       h(0.5*(N+1)-id) = h(0.5*(N+1)+id);
    end
    % Normalize by the energy
    h = h/sqrt(h*h');
end

% Normalize
%h = h/max(h);

if (nargout == 2)
   st = n/T;
   st = st(2)-st(1);
end

end

