clc
samplingTime = 40;
k= samplingTime*12;
M=0.01;
dominant=1;
[p1 p2] = poleplacement(k, M, dominant);
%dominant=0;
%[p3 p4] = poleplacement(k, M, dominant);
%p = [p1 p2 p3 p4];
p = [p1 p2];
A = [1 1; 1 1];
B = [1 .1; .1 1];
K = place(A,B,p)