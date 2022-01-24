% Matlab Program <ExBlockHammingdecoding.m>
% to illustrate encoding and decoding of Hamming (7,4) code
%
G=[1 0 0 0 1 0 1 % Code Generating Matrix
0 1 0 0 1 1 1
0 0 1 0 1 1 0
0 0 0 1 0 1 1];
H=[G(:,5:7)', eye(3,3)]; %Parity Check Matrix
E=[1 0 0 0 0 0 0 %List of correctable errors
0 1 0 0 0 0 0
0 0 1 0 0 0 0
0 0 0 1 0 0 0
0 0 0 0 1 0 0
0 0 0 0 0 1 0
0 0 0 0 0 0 1];
K=size(E,1);
Syndrome=mod(mtimes(E,H'),2); %Find Syndrome List
r=[1 0 1 0 1 1 1] %Received codeword
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