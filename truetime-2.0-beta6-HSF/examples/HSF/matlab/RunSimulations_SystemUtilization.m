clc
numberOfServers = 4;
NumberOfTaskInServer = 3;
minPeriod = 5;
maxPeriod = 20;
SystemUtilization = .5;
Adaptive = 1;
Dynamic = 1;
ControllerType = 1;
%%
w = wieghts(numberOfServers);

controllerFrequency = 1;
%
numberOfSimulation = 100;
maxSystemUtilization = 1.2;
maxControllerFrequencyCnt = 10;
meanMissRatio = zeros(1,maxControllerFrequency);
stdMissRatio = zeros(1,maxControllerFrequency);
ctrlRatio  = zeros(maxControllerFrequency, numberOfSimulation);
meanControlRatio = zeros(1,maxControllerFrequency);
stdControlRatio = zeros(1,maxControllerFrequency);
output = zeros(1,5);
j=1;
for cnt=1:numberOfSimulation
    [periods, exectimes, tasknames, ServerPeriods, ServerBudgates, ServerNames] = TaskGenerator(numberOfServers, NumberOfTaskInServer, minPeriod, maxPeriod, SystemUtilization, Adaptive, Dynamic);
    for changeFrequency=50:50:500
        cnt
        changeFrequency
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
            %change frequency
            output(j,5) = changeFrequency;
            j = j+1;
            %ctrlRatio(controllerFrequency, cnt) = controlPeriodRatio;
        end
        %meanMissRatio(controllerFrequency) = mean(MissRatio);
        %stdMissRatio(controllerFrequency) = std(MissRatio);
        %meanControlRatio(controllerFrequency) = mean(ctrlRatio(controllerFrequency,:));
        %stdControlRatio(controllerFrequency) =
        %std(ctrlRatio(controllerFrequency,:));
    end
     save('ControlFrequencyData6-SlowerULoop.mat', 'output');
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

