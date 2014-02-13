clc
tmp = load('ID_System');
sys = tmp.m;
co = ctrb(sys);
controllability = rank(co)
%sys_filtered = tmp.sys_filtered;
%%Plole placement
noStates=2;
I = eye(noStates);
ZA = zeros(noStates);
ZB = zeros(noStates,2);
A=[sys.a ZA;I I];
B=[-sys.b; ZB];
%A=sys.a;
%B=-sys.b;

%A_filtered=[sys_filtered.a Z;I I];
%B_filtered=[-sys_filtered.b; Z];

%A_filtered = sys_filtered.a;
%B_filtered = sys_filtered.b;
%A_gray= sys_gray.a;
%B_gray = -sys_gray.b;
k= samplingTime*12;
M=0.01;
dominant=1;
[p1 p2] = poleplacement(k, M, dominant);
dominant=0;
[p3 p4] = poleplacement(k, M, dominant);
p = [p1 p2 p3 p4];
%p = [p1 p2];
%[K perc mess] = place(A,B,p);
%K_filtered = place(A_filtered,B_filtered,p)
%K= place(A,B,p)
%return
bandwidth_var = 30;
period_var = 100;
%R = diag([1/bandwidth_var^2  1/period_var^2]);
R = diag([30  10]);
%R = R.*10^2;
Q = diag([1 1 1 1]);
%Q = Q/1000;
eig(R);
eig(Q);
K_lqr = dlqr(A, B, Q, R)

save('PIController',  'K_lqr');%, 'K_gray')


%% simulation
close all
A = A - B*K_lqr;
C = eye(4);
D = zeros(4,2);
B = B; 
sys_cl = ss(A,B,C,D, samplingTime);
r =[10 ; 0];
simulateModel(sys_cl, r, 100);

return

t = 1:samplingTime:samplingTime*24;

[y,t,x]= lsim(sys_cl,r,t);
[AX,H1,H2] = plotyy(t,y(:,1),t,y(:,2),'plot');
set(get(AX(1),'Ylabel'),'String','x_1')
set(get(AX(2),'Ylabel'),'String','x_2')
title('Step Response with LQR Control')
finalY = y(end,:)*.0;
tmp = ones(length(t),1);
hold on
plotyy(t,finalY(1).*tmp, t,finalY(2).*tmp,'plot');