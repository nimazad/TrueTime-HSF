function PrepareSimulation()
numberOfServers = evalin('base', 'numberOfServers');
%% Clear variables
ControlTime = zeros(numberOfServers, 1); 
assignin('base','ControlTime',ControlTime);
TotalDeadlineMiss = zeros(numberOfServers, 1);
assignin('base','TotalDeadlineMiss',TotalDeadlineMiss);
TotalFinishes = zeros(numberOfServers, 1);
assignin('base','TotalFinishes',TotalFinishes);
Budgets = zeros(numberOfServers, 1);
assignin('base','Budgets',Budgets);
DeadlineMisses = zeros(numberOfServers, 1);
assignin('base','DeadlineMisses',DeadlineMisses);
unused = zeros(numberOfServers, 1);
assignin('base','unused',unused);
DynamicTask = zeros(2, 1);
assignin('base','DynamicTask',DynamicTask);
IdleTime = zeros(numberOfServers, 1); 
DynamicTask2 = zeros(2, 1);
assignin('base','DynamicTask2',DynamicTask2);
DynamicTask3 = zeros(2, 1);
assignin('base','DynamicTask3',DynamicTask3);
DynamicTask4 = zeros(2, 1);
assignin('base','DynamicTask4',DynamicTask4);
assignin('base','IdleTime',IdleTime);
totalU = zeros(1, 1); 
assignin('base','totalU',totalU);

%% Static variables
%Adaptive = 1;
%assignin('base','Adaptive',Adaptive);
%changeFrequency = 500;
%assignin('base','changeFrequency',changeFrequency);
mode = 1;
assignin('base','mode',mode);
changeTime = 100;
changeCnt = 0;
assignin('base','changeCnt',changeCnt);
%numberOfChanges = 100;
%assignin('base','numberOfChanges',numberOfChanges);
assignin('base','changeTime',changeTime);
SystemUtilization =  evalin('base', 'SystemUtilization');
maxSystemUtilization = evalin('base', 'maxSystemUtilization');
%maxExecTime = maxSystemUtilization - SystemUtilization;
%assignin('base','maxExecTime',maxExecTime);
end