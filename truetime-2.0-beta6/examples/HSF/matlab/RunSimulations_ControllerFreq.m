clc
numberOfServers = 4;
NumberOfTaskInServer = 3;
minPeriod = 5;
maxPeriod = 20;
SystemUtilization = .5;
Adaptive = 1;
Dynamic = 1;
ControllerType = 0;
changeFrequency=50;
Scenario = 3;
numberOfChanges = 120;
maxSystemUtilization = .8;
maxExecTime = maxSystemUtilization - SystemUtilization;
%%
w = wieghts(numberOfServers);

controllerFrequency = 1;
%
numberOfSimulation = 1000;

maxControllerFrequencyCnt = 10;
meanMissRatio = zeros(1,maxControllerFrequencyCnt);
stdMissRatio = zeros(1,maxControllerFrequencyCnt);
ctrlRatio  = zeros(maxControllerFrequencyCnt, numberOfSimulation);
meanControlRatio = zeros(1,maxControllerFrequencyCnt);
stdControlRatio = zeros(1,maxControllerFrequencyCnt);
output = zeros(1,5);
j=1;
for cnt=1:numberOfSimulation
    [periods, exectimes, tasknames, ServerPeriods, ServerBudgates, ServerNames] = TaskGenerator(numberOfServers, NumberOfTaskInServer, minPeriod, maxPeriod, SystemUtilization, Adaptive, Dynamic);
    cnt
    UtilizationStd = std(ServerBudgates./ServerPeriods);
    DynamicTaskUtilization = exectimes(1,3)/periods(1,3);
    for controllerFrequencyCnt = 1:maxControllerFrequencyCnt
        MissRatio = 0;
        controllerFrequency = controllerFrequencyCnt ;
        sim('HSF.mdl', 1000)
        %run('C:\Users\nmd01\Documents\MATLAB\truetime-2.0-beta6\examples\HSF\matlab\Plot.m')
        %%
        for server = 1:NumberOfTaskInServer
            if (max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))) ~= 0
                MissRatio = MissRatio + w(server)*(max(TotalDeadlineMiss(server,:))/(max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))));
            end
        end
        %server 1 MissRatio
        output(j,1) = w(1)*(max(TotalDeadlineMiss(1,:))/(max(TotalDeadlineMiss(1,:)+max(TotalFinishes(1,:)))));
        %all servers MissRatio
        output(j,2) = MissRatio;
        %server period
        output(j,3) = ServerPeriods(1);
        %controller period
        output(j,4) = controllerFrequency*ServerPeriods(1);
        %change periods std
        output(j,5) = std(ServerPeriods);
        %change periods std
        output(j,6) = UtilizationStd;
        %Dynamic task U
        output(j,7) = DynamicTaskUtilization;
        %Server Priority
        output(j,8) = myPriority(ServerPeriods,1);
        %myPriority
        output(j,9) = myPriority(periods(1,:),3);
        %myPriority
        output(j,10) = myPriority(periods(1,:),2);
        j = j+1;
        %ctrlRatio(controllerFrequency, cnt) = controlPeriodRatio;
    end
    %meanMissRatio(controllerFrequency) = mean(MissRatio);
    %stdMissRatio(controllerFrequency) = std(MissRatio);
    %meanControlRatio(controllerFrequency) = mean(ctrlRatio(controllerFrequency,:));
    %stdControlRatio(controllerFrequency) =
    %std(ctrlRatio(controllerFrequency,:));
    
    save('ControlFrequencyData12-Change=50-2Tasks(500).mat', 'output');
end
return
%%
subplot(2,1,1)
X=1:maxControllerFrequency;
errorbar(X, meanMissRatio, stdMissRatio,'-xr');
ylabel('MissRatio');
xlabel('Control frequency to server frequency');
subplot(2,1,2)
errorbar(X, meanControlRatio, stdControlRatio,'-xr');
xlabel('controller frequency');
ylabel('control to server period ratio');
return
%% Plot
mu = mean(meanMissRatio);
sd = std(meanMissRatio);
ix = -3*sd:1e-3:3*sd; %covers more than 99% of the curve
iy = pdf('normal', ix, mu, sd);
plot(ix,iy);
%%


