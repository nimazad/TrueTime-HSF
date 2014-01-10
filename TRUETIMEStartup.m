truetimePath = strcat(pwd,'\truetime-2.0-beta6-HSF\kernel')
setenv('TTKERNEL', truetimePath)
addpath([getenv('TTKERNEL')])
addpath([getenv('TTKERNEL') '/matlab/help'])
addpath([getenv('TTKERNEL') '/matlab'])
truetime
clc
clear