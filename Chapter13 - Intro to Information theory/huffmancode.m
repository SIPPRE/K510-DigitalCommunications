% Matlab Program <huffmancode.m>
function [huffcode,n]=huffmancode(p)
% input p is a probability vector consisting of
% probabilities of source symbols x_i
if min(p)<0
    error('Negative element cannot be in a probability vector')
    return
else if abs(sum(p)-1)>1.e-12,
    error('Sum of input probability is not 1')
    return
end
[psort,pord]=sort(p);
n=length(p);
q=p;
for i=1:n-1
    [q,l]=sort(q);
    m(i,:)=[l(1:n-i+1),zeros(1,i-1)];
    q=[q(1)+q(2),q(3:end),1];
end
Cword=blanks(n^2);
Cword(n)='0';
Cword(2*n)='1';
for i1=1:n-2
    Ctemp=Cword;
    idx0=find(m(n-i1,:)==1)*n;
    Cword(1:n)=[Ctemp(idx0-n+2:idx0) '0'];
    Cword(n+1:2*n)=[Cword(1:n-1) '1'];
    for i2=2:i1+1
        idx2=find(m(n-i1,:)==i2);
        Cword(i2*n+1:(i2+1)*n)=Ctemp(n*(idx2-1)+1:n*idx2);
    end
end
for i=1:n
    idx1=find(m(1,:)==i);
    huffcode(i,1:n)=Cword(n*(idx1-1)+1:idx1*n);
end
end
