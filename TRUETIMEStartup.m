truetimePath = 'C:\Users\nmd01\Documents\TrueTime-HSF\truetime-2.0-beta6-HSF\kernel'
%truetimePath = 'C:\Users\nmd01\Documents\MATLAB\Original-truetime-2.0-beta6\kernel'
setenv('TTKERNEL', truetimePath)
addpath([getenv('TTKERNEL')])
addpath([getenv('TTKERNEL') '/matlab/help'])
addpath([getenv('TTKERNEL') '/matlab'])
truetime
clc
clear