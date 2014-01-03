close
clc
random = 0;
numberOfServers = 3;
NumberOfTaskInServer = 3;

minPeriod = 5;
maxPeriod = 20;
SystemUtilization = .27;
Dynamic = 1;

maxSystemUtilization = 1;
controllerFrequency = 50;
Adaptive = 1;
%[periods, exectimes, tasknames, ServerPeriods, ServerBudgates, ServerNames] = TaskGenerator(numberOfServers, NumberOfTaskInServer, minPeriod, maxPeriod, SystemUtilization, Adaptive, Dynamic, maxExecTime);
Scenario = 5;
maxExecTime = 0.2;
simTime = 10000;
ControllerType = 1;
sim('HSF_Fuzzy.mdl', simTime)
shape = '*r';

for i=1:numberOfServers
    subplot(2*numberOfServers,1,2*i-1);
    j = j + 1;
    plot(ControlTime(i,:), Budgets(i,:), shape)
    hold on
    subplot(2*numberOfServers,1,2*i);
    plot(ControlTime(i,:), IdleError(i,:), 'k.')
    hold on
    plot(ControlTime(i,:), DlError(i,:), 'g.')
    hold on
    if i ==3
        xlabel('Time');
    end
    label = strcat('B_',int2str(i),'C_{1,',int2str(i),'}');
    ylabel(label);
end