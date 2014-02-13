clear
clc
load('ID_System_alpha')
m1 = sys;
load('ID_System_P')
m2 = sys;
m3 = merge(m1,m2);