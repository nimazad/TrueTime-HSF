clc
close all
clear DlMiss myFitness Finished idle MissRatio
%%
VideoDecoder = importdata('C:\Users\nmd01\Documents\My Papers\Paper - 5.2 - SIES 2012\Data\Decoder task\alloallo1.txt');
[r c] =  size(VideoDecoder.data);
random = 0;
numberOfServers = 3;
NumberOfTaskInServer = 3;
minPeriod = 5;
maxPeriod = 20;
SystemUtilization = .27;
Dynamic = 1;
maxSystemUtilization = 1;
controllerFrequency = 4;
Adaptive = 1;
%[periods, exectimes, tasknames, ServerPeriods, ServerBudgates, ServerNames] = TaskGenerator(numberOfServers, NumberOfTaskInServer, minPeriod, maxPeriod, SystemUtilization, Adaptive, Dynamic, maxExecTime);
Scenario = 4;
maxExecTime = 0.2;
simTime = 200000;%ceil(r/25)*1000;
show = -1;
%% Static
Adaptive = 0;
ControllerType = 0;
sim('HSF_Fuzzy.mdl', simTime)
simulationNumber = 1;
shape = '.k';
run('C:\Users\nmd01\Documents\MATLAB\truetime-2.0-beta6\examples\HSF - Fuzzy\Illustrate_Script.m'),

%% PI period=4
ControllerType = 1;
Adaptive = 1;
controllerFrequency = 20;
sim('HSF_Fuzzy.mdl', simTime)
simulationNumber = 2;
shape = '*';
run('C:\Users\nmd01\Documents\MATLAB\truetime-2.0-beta6\examples\HSF - Fuzzy\Illustrate_Script.m'),
return
%% PI period=4
ControllerType = 1;
Adaptive = 1;
controllerFrequency = 4;
sim('HSF_Fuzzy.mdl', simTime)
simulationNumber = 3;
shape = '*y';
run('C:\Users\nmd01\Documents\MATLAB\truetime-2.0-beta6\examples\HSF - Fuzzy\Illustrate_Script.m'),
%% PI period=6
ControllerType = 1;
Adaptive = 1;
controllerFrequency = 6;
sim('HSF_Fuzzy.mdl', simTime)
simulationNumber = 4;
shape = '*r';
run('C:\Users\nmd01\Documents\MATLAB\truetime-2.0-beta6\examples\HSF - Fuzzy\Illustrate_Script.m'),
return
%% Fuzzy
ControllerType = 2;
Adaptive = 1;
controllerFrequency = 6;
%[D B] = max(BestFitness);
%Parameters = BestIndividuals(200,:);
dl_K_s = 0.5;
dl_d1 = 0.2;
dl_d2 = 0.2;
dl_h = 0.0244;
idle_K_s = 0.5;
idle_d1 = 0.2;
idle_d2 = 0.2;
idle_h = 0.02;

Parameters = [dl_K_s dl_d1 dl_d2 dl_h idle_K_s idle_d1 idle_d2 idle_h];


Adaptive = 1;
dl_K_s = 0.4445;
dl_d1 = 0.3073;
dl_d2 = 0.0455;
dl_h = 0.0168;
idle_K_s = 0.0942;
idle_d1 = 0.0765;
idle_d2 = 0.0338;
idle_h = 0.0125;
%Period = 2 Parameters 100 Generation;
%Parameters = [ 0.6832    0.0563    0.5682    0.0254    0.0576    0.0048    0.1507    0.0696];
%Period = 6 Parameters 70 Generation;
Parameters = [0.6242    0.2763    0.4700    0.3720    0.0128    0.1128    0.7727    0.0418];
%Period = 2 dynamic task in S2 
%Parameters = [0.0266    0.1623    0.1520    0.1695    0.2296    0.0912    0.0241    0.0209];
%period 4 40 generations
%Parameters = [0.2410    0.2072    0.8912    0.0649    0.0825    0.1200    0.1332    0.0124];
%GenNumber = 50;
%Parameters = history(GenNumber,:);
%Parameters = bestIndividuals_idle(GenNumber,:);
%Parameters = bestIndividuals_dl(GenNumber,:);
%Parameters(1:4) = bestIndividuals_dl(GenNumber,1:4);
%Parameters(1:4) = [dl_K_s dl_d1 dl_d2 dl_h ];
sim('HSF_Fuzzy.mdl', simTime)
simulationNumber = 5;
shape = '*r';
run('C:\Users\nmd01\Documents\MATLAB\truetime-2.0-beta6\examples\HSF - Fuzzy\Illustrate_Script.m'),


