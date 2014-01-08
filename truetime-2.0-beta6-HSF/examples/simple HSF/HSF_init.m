function HSF_init(arg)

PrepareSimulation()
%% Simulation settings
PeriodicServers = 1;

ServerNames     = {'Server1', 'Server2', 'Server3'};
ServerPeriods   = [15  ,        20  ,        17.5];
ServerBudgates  = [4,       6,     4];
assignin('base','ServerPeriods',ServerPeriods);
%ServerBudgates(1,3) = .0150;
%ServerBudgates  =zeros(1,3);
%S1_Util = ServerBudgates(1,1)/ServerPeriods(1,1)

%Server1 tasks
tasknames{1}    = {'S1T1', 'S1T2', 'S1T3'};
periods(1,:)    =  [40,        30,      30];
exectimes(1,:)  =  [2.5427,    2,    3];%4.3543
%Server2 tasks
tasknames{2}    = {'S2T1', 'S2T2', 'S2T3'};
periods(2,:)    =  [40,        50,      90];
exectimes(2,:)  =  [2.4060,   5,      5];
%Server3 tasks
tasknames{3}    = {'S3T1', 'S3T2', ''};
periods(3,:)    =  [40,        70,      35];
exectimes(3,:)  =  [2.3213,      7,      3];%4.0628
%ServerBudgates = CalculateBudgets(periods, exectimes, tasknames, ServerPeriods, ServerBudgates, ServerNames);
U_tasks = sum(sum(exectimes./periods))
U_servers = sum(ServerBudgates./ServerPeriods)

%% Initialize the kernel
ttInitKernel('prioHEDF')
HardCBS = 1;
data.K = 2;            % controller proportional gain
data.dlMisses = 0;
data.finished = 0;
data.dlMissesHistory = 0;
data.NoJobs = 0;
data.sumExectime =0;
data.CPUTime = 0;
data.neededCPU = 0;
data.error = 0;
starttime = 0.0;
idlePeriod = 1000000;
idleExec = 1000000;
ttCreateHandler('dl_miss_handler', 1, 'DeadlineMiss_Code');
numberOfServers = evalin('base', 'numberOfServers');
NumberOfTaskInServer = evalin('base', 'NumberOfTaskInServer');
controllerFrequency = evalin('base', 'controllerFrequency');
data.oldIdleError= zeros(numberOfServers, 1);
data.oldDLMissError= zeros(numberOfServers, 1);
data.idleTime = zeros(numberOfServers, 1);
data.ServerPeriods = ServerPeriods;
data.ServerNames = ServerNames;
%% Manager Server Creation
ManagerPeriod = (min(ServerPeriods)*controllerFrequency)/2;
ManagerBudget = 0.01 * ManagerPeriod;
ttCreateCBS('Manager', ManagerBudget, ManagerPeriod, HardCBS);

%% Servers and tasks creations
for ServerID=1:numberOfServers
    data.tasknames = tasknames{ServerID};
    data.Server = ServerID;
    ttCreateCBS(ServerNames{ServerID}, ServerBudgates(ServerID), ServerPeriods(ServerID), HardCBS)
    for i=1:NumberOfTaskInServer
        if ~strcmp(data.tasknames{i},'')
            data.exectime = exectimes(ServerID, i);
            %Utilization(ServerID) = Utilization(ServerID) + data.exectime/periods(ServerID, i);
            data.myName   = data.tasknames{i};
            data.myPeriod = periods(ServerID, i);
            ttCreatePeriodicTask(data.tasknames{i}, starttime, periods(ServerID, i), 'Task_code', data)
            ttAttachDLHandler(data.tasknames{i}, 'dl_miss_handler');
            ttAttachCBS(data.tasknames{i}, ServerNames{ServerID});
        end
    end
    %% Create idle tasks
    %Idle task is needed to mimic the behavior of the periodic servers
    %using constant bandwidth servers
    if PeriodicServers 
        data.exectime   = idleExec;   % control task execution time
        data.myName     = strcat(ServerNames{ServerID}, '-idle');
        ttCreatePeriodicTask(data.myName, starttime, idlePeriod, 'Idle_code', data)
        ttAttachCBS(data.myName, ServerNames{ServerID})
    end
    %% Create controller/Monitor tasks
    % we can use these tasks to achieve an adaptive framework
    data.idleLoopCounter = 0;
    data.PrevIdleTime = 0;
    data.exectime   = 0;   % control task execution time
    data.myName     = strcat(ServerNames{ServerID}, '-controller');
    %data.myPeriod   = round((evalin('base','changeFrequency')/controllerFrequency)/ServerPeriods(ServerID));
    data.myPeriod = controllerFrequency;
    ttCreatePeriodicTask(data.myName, starttime, data.myPeriod*ServerPeriods(ServerID), 'Controller_code', data);
    assignin('base','controlPeriodRatio',data.myPeriod);
    ttAttachCBS(data.myName, 'Manager');
end
%% Global idle task
    ttCreatePeriodicTask('GlobalIdleTask', starttime, idlePeriod, 'Idle_code', data)

end