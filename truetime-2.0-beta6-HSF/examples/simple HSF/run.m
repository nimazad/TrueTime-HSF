clc
numberOfServers = 3;
NumberOfTaskInServer = 3;
Scenario = 4;
simTime = 1000;
controllerFrequency = 4;
sim('HSF.mdl', simTime)
        