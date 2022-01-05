% Matlab Program <huffmanEx.m>
% This exercise requires the input of a
% probability vector p that list all the
% probabilities of each source input symbol
clear;
%p=[0.2 0.05 0.03 0.1 0.3 0.02 0.22 0.08]; %Symbol probability vector
p = [0.3 0.6 0.05 0.05];
[huffcode,n]=huffmancode(p);
%Encode Huffman code
entropy=sum(-log(p)*p')/log(2);
%Find entropy of the source
% Display the results of Huffman encoder
display(['symbol',' --> ',' codeword',' Probability'])
for i=1:n
    codeword_Length(i)=n-length(find(abs(huffcode(i,:))==32));
    display(['x',num2str(i),' --> ',huffcode(i,:),' ',num2str(p(i))]);
end
codeword_Length
avg_length=codeword_Length*p';
display(['Entropy = ', num2str(entropy)])
display(['Average codeword length = ', num2str(avg_length)])