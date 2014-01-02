j = 1;
figure
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
j = 1;
figure
for i=1:numberOfServers
    subplot(numberOfServers,1,j);
    j = j + 1;
    plot(ControlTime(i,:), Budgets(i,:), '*')
    xlabel('Time');
    ylabel('Budgets');
end
j = 1;
figure
for i=1:numberOfServers
    subplot(numberOfServers,1,j);
    j = j + 1;
    plot(ControlTime(i,:), unused(i,:), '*')
    xlabel('Time');
    ylabel('UnUsed Budget');
end

%% Clear variables
ControlTime = zeros(numberOfServers, 1);    
TotalDeadlineMiss = zeros(numberOfServers, 1);
Budgets = zeros(numberOfServers, 1);
DeadlineMisses = zeros(numberOfServers, 1);
unused = zeros(numberOfServers, 1);
