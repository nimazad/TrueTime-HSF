close all
clear 
clc
ImportVideoData;
clc
numberOfServers = 1;
NumberOfTaskInServer = 1;
simTime = 1000000;
samplingTime = 400;
adaptTime = 20;
PeriodChange =9000 / (2*3.14);
alphaChange = 5500/ (2*3.14);
h=10;
min_bandwidth = 45;
max_bandwidth = 80;
bandwidth_var = max_bandwidth-min_bandwidth;
operating_bandwidth = min_bandwidth + bandwidth_var/2;
min_period = 40;
max_period = 300;
period_var = (max_period-min_period);
operating_period = min_period + period_var/2;
%    operating_period =40;
r1 = 10;
r2 = 1;%-100*(5.7*.0001*operating_period);
r3 =  0;
contextSwitchOverhead = .0;
