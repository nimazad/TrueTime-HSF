close all
clc
clear 
ImportVideoData
numberOfServers = 1;
NumberOfTaskInServer = 3;
Adaptive = 0;
simTime = 20000;
controllerFrequency = .5;
sim('HSF.mdl', simTime)
i=1;
totalPlots = 5;
subplot(totalPlots,1,i);
j = j + 1;
plot(ControlTime(i,:), SchedulingError(i,:))
%plot(SchedulingError(i,:))
hold on
label = strcat('\mu_',int2str(i),'C_{1,',int2str(i),'}');
ylabel(label);


subplot(totalPlots,1,2);
j = j + 1;
plot(ControlTime(i,:), currentIdleTime(i,:))
%plot(SchedulingError(i,:))
hold on
label = strcat('\beta_',int2str(i),'C_{1,',int2str(i),'}');
ylabel(label);

subplot(totalPlots,1,3);
j = j + 1;
plot(DynamicTask(2,:), DynamicTask(i,:))
hold on
label = strcat(int2str(i),'C_{1,',int2str(i),'}');
ylabel(label);

subplot(totalPlots,1,4);
j = j + 1;
plot(ControlTime(i,:), Budgets(i,:))
hold on
label = strcat('B_',int2str(i),'C_{1,',int2str(i),'}');
ylabel(label);

subplot(totalPlots,1,5);
j = j + 1;
plot(ControlTime(i,:), Periods(i,:))
hold on
label = strcat('P_',int2str(i),'C_{1,',int2str(i),'}');
ylabel(label);
input(:,1) = Budgets(1,:)
input(:,2) = Periods(1,:)
output(:,1) = SchedulingError(1,:)
output(:,2) = currentIdleTime(1,:)