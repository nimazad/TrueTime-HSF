close all
clc
numberOfServers = 3;
NumberOfTaskInServer = 3;
Scenario = 4;
Adaptive = 0;
simTime = 1000;
controllerFrequency = 1;
sim('HSF.mdl', simTime)

for i=1:numberOfServers
    subplot(numberOfServers,1,i);
    j = j + 1;
    %plot(ControlTime(i,:), SchedulingError(i,:))
    plot(SchedulingError(i,:))
    hold on
    if i ==3
        xlabel('Time');
    end
    label = strcat('\mu_',int2str(i),'C_{1,',int2str(i),'}');
    ylabel(label);
end
return
figure
for i=1:numberOfServers
    subplot(numberOfServers,1,i);
    j = j + 1;
    %plot(ControlTime(i,:), SchedulingError(i,:))
    %plot(IdleTime(i,:))
    plot(unused(i,:))
    hold on
    if i ==3
        xlabel('Time');
    end
    label = strcat('\mu_',int2str(i),'C_{1,',int2str(i),'}');
    ylabel(label);
end