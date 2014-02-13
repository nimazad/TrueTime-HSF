close all
clc
clear 
ImportVideoData
numberOfServers = 1;
NumberOfTaskInServer = 3;
Adaptive = 0;
simTime = 4000;
samplingTime = 10
adaptTime = 20;
h=5
xmin=0;
xmax=simTime;
ymin=-.7;
ymax=.4;
%controllerFrequency = 5;
sim('HSF.mdl', simTime)
i=1;
totalPlots = 4;
subplot(totalPlots,1,i);
j = j + 1;
plot(ControlTime(i,:), SchedulingError(i,:))
%plot(SchedulingError(i,:))
hold on
label = strcat('\Psi =', int2str(samplingTime));
ylabel(label);
axis([xmin xmax ymin ymax])
%%
samplingTime = 20
clear SchedulingError

sim('HSF.mdl', simTime)
subplot(totalPlots,1,2);
j = j + 1;
plot(ControlTime(i,:), SchedulingError(i,:))
%plot(SchedulingError(i,:))
hold on
label = strcat('\Psi =', int2str(samplingTime));
ylabel(label);
axis([xmin xmax ymin ymax])

samplingTime = 30
clear SchedulingError

sim('HSF.mdl', simTime)
subplot(totalPlots,1,3);
j = j + 1;
plot(ControlTime(i,:), SchedulingError(i,:))
%plot(SchedulingError(i,:))
hold on
label = strcat('\Psi =', int2str(samplingTime));
ylabel(label);
axis([xmin xmax ymin ymax])

samplingTime = 40
clear SchedulingError

sim('HSF.mdl', simTime)
subplot(totalPlots,1,4);
j = j + 1;
plot(ControlTime(i,:), SchedulingError(i,:))
%plot(SchedulingError(i,:))
hold on
label = strcat('\Psi =', int2str(samplingTime));
ylabel(label);
axis([xmin xmax ymin ymax])
