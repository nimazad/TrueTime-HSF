close all
clc
numberOfServers = 1;
NumberOfTaskInServer = 3;
Adaptive = 0;
simTime = 20000;
controllerFrequency = .5;
sim('HSF.mdl', simTime)
i=1
subplot(3,1,i);
j = j + 1;
plot(ControlTime(i,:), SchedulingError(i,:))
%plot(SchedulingError(i,:))
hold on
label = strcat('\mu_',int2str(i),'C_{1,',int2str(i),'}');
ylabel(label);


subplot(3,1,2);
j = j + 1;
plot(ControlTime(i,:), IdleTime(i,:))
%plot(SchedulingError(i,:))
hold on
label = strcat('\beta_',int2str(i),'C_{1,',int2str(i),'}');
ylabel(label);

subplot(3,1,3);
j = j + 1;
plot(DynamicTask(2,:), DynamicTask(i,:))
