function [cA,cD]=hwt(x)

%This function is used to do Haar Wavelet Transform

sfc=[1/2,1/2];wfc=[1,-1]; 

N=length(x);         % The length of the sequence 
M=floor(N/2);        
k=1:M;
cA(k)=x(2*k-1) * 1/2 + x(2*k) * 1/2;
cD(k)=abs(x(2*k-1) - x(2*k));