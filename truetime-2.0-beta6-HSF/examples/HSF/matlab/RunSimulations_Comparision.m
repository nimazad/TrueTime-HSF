clc
numberOfServers = 4;
NumberOfTaskInServer = 3;
minPeriod = 5;
maxPeriod = 20;
%SystemUtilization = .3;
controllerFrequency = 4;
Dynamic = 0;
%%
w = wieghts(numberOfServers);
Adaptive = 1;
numberOfChanges = 0;
changeFrequency = 500;
%
numberOfSimulation = 1;
maxSystemUtilization = 1.2;
maxControllerFrequency = 20;
meanMissRatio = zeros(1,maxControllerFrequency);
stdMissRatio = zeros(1,maxControllerFrequency);
ctrlRatio  = zeros(maxControllerFrequency, numberOfSimulation);
meanControlRatio = zeros(1,maxControllerFrequency);
stdControlRatio = zeros(1,maxControllerFrequency);
output = zeros(1,5);
j=1;
for cnt=1:numberOfSimulation
    numberOfSimulation
    SystemUtilization = .3;
    while SystemUtilization < 1.5
        SystemUtilization = SystemUtilization + .1
        cnt
        for t=1:2
            MissRatio = zeros(1,numberOfSimulation);
            UnWeightedMissRatio = 0;
            Adaptive = ChangeMode(Adaptive);
            [periods, exectimes, tasknames, ServerPeriods, ServerBudgates, ServerNames] = TaskGenerator(numberOfServers, NumberOfTaskInServer, minPeriod, maxPeriod, SystemUtilization, Adaptive, Dynamic);
            sim('HSF.mdl', 1000)
            %run('C:\Users\nmd01\Documents\MATLAB\truetime-2.0-beta6\examples\HSF\matlab\Plot.m')
            %%
            for server = 1:NumberOfTaskInServer
                if (max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))) ~= 0
                    MissRatio(1, cnt) = MissRatio(1, cnt) + w(server)*(max(TotalDeadlineMiss(server,:))/(max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))));
                    %MissRatio(1, cnt) = MissRatio(1, cnt) + (max(TotalFinishes(server,:))/(10*max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))));
                    UnWeightedMissRatio = UnWeightedMissRatio + (1/numberOfServers)*(max(TotalDeadlineMiss(server,:))/(max(TotalDeadlineMiss(server,:)+max(TotalFinishes(server,:)))));
                end
            end
            %server 1 MissRatio
            output(j,1) = w(1)*(max(TotalDeadlineMiss(1,:))/(max(TotalDeadlineMiss(1,:)+max(TotalFinishes(1,:)))));
            %all servers MissRatio
            output(j,2) = MissRatio(1, cnt);
            %SystemUtilization
            output(j,3) = SystemUtilization;
            %Adaptive
            output(j,4) = Adaptive;
            %Server Utilizaqtion
            output(j,5) = sum(ServerBudgates./ServerPeriods);
            %unweigthed Miss Ratio
            output(j,6) = UnWeightedMissRatio;
            j = j+1;
            %ctrlRatio(controllerFrequency, cnt) = controlPeriodRatio;
        end
        %meanMissRatio(controllerFrequency) = mean(MissRatio);
        %stdMissRatio(controllerFrequency) = std(MissRatio);
        %meanControlRatio(controllerFrequency) = mean(ctrlRatio(controllerFrequency,:));
        %stdControlRatio(controllerFrequency) = std(ctrlRatio(controllerFrequency,:));
    end
    save('ControlFrequencyData_Comparision2.mat', 'output');
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
    