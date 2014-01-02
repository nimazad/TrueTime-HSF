close all
clc
max=10
x=1:max
y=x.*10*abs(randn(1,1))
z=50+10*abs(randn(max,1))
scatter3(x,y,z)
grid on
xlabel('t');

ylabel('sbf(t)');

zlabel('p');