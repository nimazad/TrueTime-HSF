%close all
%clc
scrsz = get(0,'ScreenSize');
DeadlineMissFig = 1;
BudgetsFig = 1;
idleTimeFig = 1;
%% Deadline Misses
j = 1;
figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])%[left, bottom, width, height]
for i=1:numberOfServers
    subplot(numberOfServers,2,j);
    j = j + 1;
    plot(ControlTime(i,:), DeadlineMisses(i,:), '*')
    xlabel('Time');
    ylabel('DL Miss Per Control Period');
    subplot(numberOfServers,2, j);
    j = j + 1;
    plot(ControlTime(i,:), TotalDeadlineMiss(i,:), '*')
    xlabel('Time');
    ylabel('Total DL Miss');
end
%% Budgets
j = 1;
figure('Position',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])
for i=1:numberOfServers
    subplot(numberOfServers,1,j);
    j = j + 1;
    plot(ControlTime(i,:), Budgets(i,:), '*')
    xlabel('Time');
    ylabel('Budgets');
end
j = 1;
%% Dynamic execution time and idle time
figure('Position',[1 1 scrsz(3)/2 scrsz(4)/2])
plot(ControlTime(1,:), totalU(1,:), '*')
xlabel('Time');
ylabel('total Utilization');

j = 1;
%% Scheduling Error
figure('Position',[scrsz(3)/2 1 scrsz(3)/2 scrsz(4)/2])
subplot(numberOfServers,1,j);
j= j + 1;
plot(ControlTime(1,:), SchedulingError(1,:), '*')
xlabel('Scheduling Error');
ylabel('S_1');
subplot(numberOfServers,1,j);
j= j + 1;
plot(ControlTime(2,:), SchedulingError(2,:), '*')
xlabel('Scheduling Error');
ylabel('S_2');
subplot(numberOfServers,1,j);
j= j + 1;
plot(ControlTime(3,:), SchedulingError(3,:), '*')
xlabel('Scheduling Error');
ylabel('S_3');
return
%% Dynamic execution time and total finished
figure('Position',[scrsz(3)/2 1 scrsz(3)/2 scrsz(4)/2])
subplot(numberOfServers,1,j);
j= j + 1;
plot(DynamicTask(2,:), DynamicTask(1,:), '*')
xlabel('Time');
ylabel('S_1');
subplot(numberOfServers,1,j);
j= j + 1;
plot(DynamicTask2(2,:), DynamicTask2(1,:), '*')
xlabel('Time');
ylabel('S_2');
subplot(numberOfServers,1,j);
j= j + 1;
plot(DynamicTask3(2,:), DynamicTask3(1,:), '*')
xlabel('Time');
ylabel('S_3');
subplot(numberOfServers,1,j);
j= j + 1;
plot(DynamicTask4(2,:), DynamicTask4(1,:), '*')
xlabel('Time');
ylabel('S_4');

return
%%
J=1;
figure
for i=1:numberOfServers
    subplot(numberOfServers,1,j);
    j = j + 1;
    plot(ControlTime(i,:), TotalFinishes(i,:), '*')
    xlabel('Time');
    ylabel('TotalFinishes');
end
