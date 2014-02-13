function PrepareSimulation()
numberOfServers = evalin('base', 'numberOfServers');
%% Clear variables
TotalInvocations = zeros(numberOfServers, 1); 
assignin('base','TotalInvocations',TotalInvocations);
currentInvocations = zeros(numberOfServers, 1); 
assignin('base','currentInvocations',currentInvocations);
currentReleases = zeros(numberOfServers, 1); 
assignin('base','currentReleases',currentReleases);
Releases = zeros(numberOfServers, 1); 
assignin('base','Releases',Releases);
currentAssigned = zeros(numberOfServers, 1); 
assignin('base','currentAssigned',currentAssigned);
totalAssigned = zeros(numberOfServers, 1); 
assignin('base','totalAssigned',totalAssigned);
intStates = zeros(1,3); 
assignin('base','intStates',intStates);
currentLoad = zeros(numberOfServers, 1); 
assignin('base','currentLoad',currentLoad);
ControlTime = zeros(numberOfServers, 1); 
assignin('base','ControlTime',ControlTime);
TotalDeadlineMiss = zeros(numberOfServers, 1);
assignin('base','TotalDeadlineMiss',TotalDeadlineMiss);
TotalFinishes = zeros(numberOfServers, 1);
assignin('base','TotalFinishes',TotalFinishes);
Budgets = zeros(numberOfServers, 1);
assignin('base','Budgets',Budgets);
Periods = zeros(numberOfServers, 1);
assignin('base','Periods',Periods);
DeadlineMisses = zeros(numberOfServers, 1);
assignin('base','DeadlineMisses',DeadlineMisses);
unused = zeros(numberOfServers, 1);
assignin('base','unused',unused);
DynamicTask = zeros(2, 1);
assignin('base','DynamicTask',DynamicTask); 
DynamicTask2 = zeros(2, 1);
assignin('base','DynamicTask2',DynamicTask2);
DynamicTask3 = zeros(2, 1);
assignin('base','DynamicTask3',DynamicTask3);
DynamicTask4 = zeros(2, 1);
assignin('base','DynamicTask4',DynamicTask4);
IdleTime = zeros(numberOfServers, 1);
assignin('base','IdleTime',IdleTime);
currentIdleTime = zeros(numberOfServers, 1);
assignin('base','currentIdleTime',currentIdleTime);

totalU = zeros(1, 1); 
assignin('base','totalU',totalU);
IdleError = zeros(1, 1); 
assignin('base','IdleError',IdleError);
DlError = zeros(1, 1); 
assignin('base','DlError',DlError);
SchedulingError = zeros(numberOfServers, 1);
assignin('base','SchedulingError',SchedulingError);

%% Static variables
%Adaptive = 1;
%assignin('base','Adaptive',Adaptive);
%changeFrequency = 500;
%assignin('base','changeFrequency',changeFrequency);
mode = 1;
assignin('base','mode',mode);
changeTime = 300;
changeCnt = 0;
assignin('base','changeCnt',changeCnt);
numberOfChanges = 100;
assignin('base','numberOfChanges',numberOfChanges);
assignin('base','changeTime',changeTime);
%SystemUtilization =  evalin('base', 'SystemUtilization');
%maxSystemUtilization = evalin('base', 'maxSystemUtilization');
%maxExecTime = maxSystemUtilization - SystemUtilization;
%assignin('base','maxExecTime',maxExecTime);
end