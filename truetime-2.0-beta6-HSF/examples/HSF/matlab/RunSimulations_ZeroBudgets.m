clc
numberOfServers = 4;
NumberOfTaskInServer = 3;
minPeriod = 50;
maxPeriod = 200;
SystemUtilization = .5;
Adaptive = 1;
Dynamic = 0;
%%
w = wieghts(numberOfServers);

controllerFrequency = 1;
numberOfChanges = 0;
%
numberOfSimulation = 50;
maxSystemUtilization = 1.2;
maxControllerFrequency = 15;
meanMissRatio = zeros(1,maxControllerFrequency);
stdMissRatio = zeros(1,maxControllerFrequency);
ctrlRatio  = zeros(maxControllerFrequency, numberOfSimulation);
meanControlRatio = zeros(1,maxControllerFrequency);
stdControlRatio = zeros(1,maxControllerFrequency);
output = zeros(1,5);
j=1;
for cnt=1:numberOfSimulation
    cnt
    [periods, exectimes, tasknames, ServerPeriods, ServerBudgates, ServerNames] = TaskGenerator(numberOfServers, NumberOfTaskInServer, minPeriod, maxPeriod, SystemUtilization, Adaptive, Dynamic);
    for controllerFrequency = 1:maxControllerFrequency
        
        ServerBudgates = zeros(1,numberOfServers);
        MissRatio = zeros(1,numberOfSimulation);
        sim('HSF.mdl', 1000)
        run('C:\Users\nmd01\Documents\MATLAB\truetime-2.0-beta6\examples\HSF\matlab\Plot.m')
        %%
        for server = 1:NumberOfTaskInServer
            if (max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))) ~= 0
                MissRatio(1, cnt) = MissRatio(1, cnt) + w(server)*(max(TotalDeadlineMiss(server,:))/(max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))));
                %MissRatio(1, cnt) = MissRatio(1, cnt) + (max(TotalFinishes(server,:))/(10*max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))));
            end
        end
        %server 1 MissRatio
        output(j,1) = w(1)*(max(TotalDeadlineMiss(1,:))/(max(TotalDeadlineMiss(1,:)+max(TotalFinishes(1,:)))));
        %all servers MissRatio
        output(j,2) = MissRatio(1, cnt);
        %server period
        output(j,3) = ServerPeriods(1);
        %controller period
        output(j,4) = controllerFrequency*ServerPeriods(1);

        j = j+1;
        %ctrlRatio(controllerFrequency, cnt) = controlPeriodRatio;
    end
    %meanMissRatio(controllerFrequency) = mean(MissRatio);
    %stdMissRatio(controllerFrequency) = std(MissRatio);
    %meanControlRatio(controllerFrequency) = mean(ctrlRatio(controllerFrequency,:));
    %stdControlRatio(controllerFrequency) = std(ctrlRatio(controllerFrequency,:));
    save('ControlFrequencyData_ZeroBudgets2.mat', 'output');
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

