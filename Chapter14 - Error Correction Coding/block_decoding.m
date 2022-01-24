% Matlab Program <ExBlock63decoding.m>
% to illustrate encoding and decoding of (6,3) block code
% in Example 13.1
%
G=[1 0 0 1 0 1 %Code Generator
0 1 0 0 1 1
0 0 1 1 1 0];
H=[1 0 1 %Parity Check Matrix
0 1 1
1 1 0
1 0 0
0 1 0
0 0 1]';
E=[0 0 0 0 0 0 %List of correctable errors
1 0 0 0 0 0
0 1 0 0 0 0
0 0 1 0 0 0
0 0 0 1 0 0
0 0 0 0 1 0
0 0 0 0 0 1
1 0 0 0 1 0];
K=size(E,1);
Syndrome=mod(mtimes(E,H'),2); %Find Syndrome List
r=[1 1 1 0 1 1] %Received codeword
display(['Syndrome ','Error Pattern'])
display(num2str([Syndrome E]))
x=mod(r*H',2); %Compute syndrome
for kk=1:K,
if Syndrome(kk,:)==x,
idxe=kk; %Find the syndrome index
end
end
syndrome=Syndrome(idxe,:) %display the syndrome
error=E(idxe,:)
cword=xor(r,error) %Error correction