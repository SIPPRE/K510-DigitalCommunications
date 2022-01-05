% Matlab Program <mutualinfo.m>
function muinfo_bit=mutualinfo(x,y)
%mutualinfo Computes the mutual information of two
% vectors x and y in bits
% muinfo_bit = mutualinfo(X,Y)
% output mutual information
% X,Y The 1-D vectors to be analyzed
%
minx=min(x);
maxx=max(x);
deltax=(maxx-minx)/(length(x)-1);
lowerx=minx-deltax/2;
upperx=maxx+deltax/2;
ncellx=ceil(length(x)^(1/3));
miny=min(y);
maxy=max(y);
deltay=(maxy-miny)/(length(y)-1);
lowery=miny-deltay/2;
uppery=maxy+deltay/2;
ncelly=ncellx;
rout(1:ncellx,1:ncelly)=0;
xx=round( (x-lowerx)/(upperx-lowerx)*ncellx + 1/2 );
yy=round( (y-lowery)/(uppery-lowery)*ncelly + 1/2 );
for n=1:length(x)
    indexx=xx(n);
    indexy=yy(n);
    if indexx >= 1 & indexx <= ncellx & indexy >= 1 & indexy <= ncelly
        rout(indexx,indexy)=rout(indexx,indexy)+1;
    end
end
h=rout;
estimate=0;
sigma=0;
count=0;
% determine row and column sums
hy=sum(h);
hx=sum(h');
for nx=1:ncellx
    for ny=1:ncelly
        if h(nx,ny)~=0
            logf=log(h(nx,ny)/hx(nx)/hy(ny));
            else
            logf=0;
        end
        count=count+h(nx,ny);
        estimate=estimate+h(nx,ny)*logf;
        sigma=sigma+h(nx,ny)*logf^2;
    end
end
% biased estimate
estimate=estimate/count;
sigma =sqrt( (sigma/count-estimate^2)/(count-1) );
estimate=estimate+log(count);
nbias =(ncellx-1)*(ncelly-1)/(2*count);
% remove bias
muinfo_bit=(estimate-nbias)/log(2);