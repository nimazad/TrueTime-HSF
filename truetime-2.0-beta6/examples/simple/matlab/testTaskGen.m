clc 
numberOfServers = 3;
NumberOfTaskInServer = 3;
minPeriod = 5;
maxPeriod = 20;
SystemUtilization = .75;
DeadlineMisses = zeros(numberOfServers, 1);
ControlTime = zeros(numberOfServers, 1);
TotalDeadlineMiss = zeros(numberOfServers, 1);
Budgets = zeros(numberOfServers, 1);
unused =  zeros(numberOfServers, 1);
[periods, exectimes, tasknames, ServerPeriods, ServerBudgates, ServerNames] = TaskGenerator(numberOfServers, NumberOfTaskInServer, minPeriod, maxPeriod, SystemUtilization);
%% 
[r c] = size(ControlTime);
for i=1:c
    if ControlTime(3,i)>400 
        if ControlTime(3,i)<500
            i
        end
    end
end


