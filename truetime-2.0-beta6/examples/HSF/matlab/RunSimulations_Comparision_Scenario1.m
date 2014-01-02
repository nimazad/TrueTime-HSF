clc
numberOfServers = 4;
NumberOfTaskInServer = 3;
minPeriod = 5;
maxPeriod = 20;
SystemUtilization = .3;
controllerFrequency = 4;
maxSystemUtilization = .65;
Scenario = 2;
maxExecTime = maxSystemUtilization - SystemUtilization;
Dynamic = 1;
ControllerType = 0;
%%
w = wieghts(numberOfServers);
Adaptive = 1;
numberOfChanges = 100;
changeFrequency = 500;
%
numberOfSimulation = 120;

output = zeros(1,6);
row=1;
for cnt=1:numberOfSimulation
    cnt
    for t=1:2
        MissRatio = 0;
        UnWeightedMissRatio = 0;
        Adaptive = ChangeMode(Adaptive)
        [periods, exectimes, tasknames, ServerPeriods, ServerBudgates, ServerNames] = TaskGenerator(numberOfServers, NumberOfTaskInServer, minPeriod, maxPeriod, SystemUtilization, Adaptive, Dynamic, maxExecTime);
        while ( sum(ServerBudgates./ServerPeriods))>1
            [periods, exectimes, tasknames, ServerPeriods, ServerBudgates, ServerNames] = TaskGenerator(numberOfServers, NumberOfTaskInServer, minPeriod, maxPeriod, SystemUtilization, Adaptive, Dynamic, maxExecTime);
        end
        sim('HSF.mdl', 1000)
        %run('C:\Users\nmd01\Documents\MATLAB\truetime-2.0-beta6\examples\HSF\matlab\Plot.m')
        %%
        for server = 1:NumberOfTaskInServer
            if (max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))) ~= 0
                MissRatio = MissRatio + w(server)*(max(TotalDeadlineMiss(server,:))/(max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))));
                UnWeightedMissRatio = UnWeightedMissRatio + (1/numberOfServers)*(max(TotalDeadlineMiss(server,:))/(max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))));
                %MissRatio(1, cnt) = MissRatio(1, cnt) + (max(TotalFinishes(server,:))/(10*max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))));
            end
        end
        %server 1 MissRatio
        output(row,1) = w(1)*(max(TotalDeadlineMiss(1,:))/(max(TotalDeadlineMiss(1,:)+max(TotalFinishes(1,:)))));
        %all servers MissRatio
        output(row,2) = MissRatio;
        %SystemUtilization
      
        output(row,3) = maxSystemUtilization;
        %Adaptive
        output(row,4) = Adaptive;
        %Server Utilizaqtion
        output(row,5) = sum(ServerBudgates./ServerPeriods);
        %unweigthed Miss Ratio
        output(row,6) = UnWeightedMissRatio;
        if (output(row,1)>0 && ~Adaptive)
            'Y'
        end
        row = row+1;
        %ctrlRatio(controllerFrequency, cnt) = controlPeriodRatio;
    end
    %meanMissRatio(controllerFrequency) = mean(MissRatio);
    %stdMissRatio(controllerFrequency) = std(MissRatio);
    %meanControlRatio(controllerFrequency) = mean(ctrlRatio(controllerFrequency,:));
    %stdControlRatio(controllerFrequency) = std(ctrlRatio(controllerFrequency,:));
end
%save('Comparision_Scenario2-2.mat', 'output');
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

