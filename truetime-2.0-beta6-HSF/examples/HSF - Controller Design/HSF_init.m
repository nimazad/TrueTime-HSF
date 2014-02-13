function HSF_init(arg)
contextSwitchOverhead = evalin('base', 'contextSwitchOverhead');
%tmpPeriod = evalin('base', 'tmpPeriod');
PrepareSimulation()
%% Simulation settings
PeriodicServers = 1;
P1 = evalin('base', 'operating_period');
B1 = evalin('base', 'operating_bandwidth') * P1 /100; 
ServerNames     = {'Server1', 'Server2', 'Server3'};
ServerPeriods   = [P1,        20  ,        15];
ServerBudgates  = [B1,       1,     0];
assignin('base','ServerPeriods',ServerPeriods);
%ServerBudgates(1,3) = .0150;
%ServerBudgates  =zeros(1,3);
%S1_Util = ServerBudgates(1,1)/ServerPeriods(1,1)

%Server1 tasks
tasknames{1}    = {'S1T1', 'S1T2', 'S1T3'};
periods(1,:)    =  [40,        50,      100];
exectimes(1,:)  =  [12,    10,    5];%4.3543
periods(1,:)    =  [10,        8,      12];
exectimes(1,:)  =  [2,    2,    2];%4.3543


%Server2 tasks
tasknames{2}    = {'S2T1', 'S2T2', 'S2T3'};
periods(2,:)    =  [40,        50,      90];
exectimes(2,:)  =  [2.4060,   1,      1];
%Server3 tasks
tasknames{3}    = {'S3T1', 'S3T2', ''};
periods(3,:)    =  [40,        70,      35];
exectimes(3,:)  =  [2.3213,      1,      1];%4.0628
%ServerBudgates = CalculateBudgets(periods, exectimes, tasknames, ServerPeriods, ServerBudgates, ServerNames);
%U_tasks = sum(sum(exectimes./periods))
%U_servers = sum(ServerBudgates./ServerPeriods)

%% Initialize the kernel
ttInitKernel('prioHEDF', contextSwitchOverhead)
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
simTime = evalin('base', 'simTime');
idlePeriod = simTime * 100;
idleExec = idlePeriod;
ttCreateHandler('dl_miss_handler', 1, 'DeadlineMiss_Code');
numberOfServers = evalin('base', 'numberOfServers');
NumberOfTaskInServer = evalin('base', 'NumberOfTaskInServer');
samplingTime = evalin('base', 'samplingTime');
data.oldIdleError= zeros(numberOfServers, 1);
data.oldDLMissError= zeros(numberOfServers, 1);
data.idleTime = zeros(numberOfServers, 1);
data.ServerPeriods = ServerPeriods;
data.ServerNames = ServerNames;
%% Manager Server Creation
ManagerPeriod = samplingTime;
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
        data.exectime   = idleExec;   % idle task execution time
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
    %data.myPeriod   = round((evalin('base','changeFrequency')/samplingTime)/ServerPeriods(ServerID));
    data.myPeriod = samplingTime;
    data.IdleErrorI = 0;
    data.LateErrorI = 0;
    data.r1 = evalin('base', 'r1');%-.5*.59*samplingTime;
    data.r2 = evalin('base', 'r2');%0*samplingTime;%-.2*.59*samplingTime;
    data.r3 = evalin('base', 'r3');
    if ServerID == 1
        ttCreatePeriodicTask(data.myName, starttime, data.myPeriod, 'Controller_code', data);
        assignin('base','controlPeriodRatio',data.myPeriod);
        ttAttachCBS(data.myName, 'Manager');
        %% Create budget/period adapter for identification
    %     % we can use these tasks to achieve an adaptive framework
%         identification = evalin('base', 'identification');
%         if identification
%             data.idleLoopCounter = 0;
%             data.PrevIdleTime = 0;
%             data.exectime   = 0;   % ID task execution time
%             data.myName     = strcat('', '-id');
%             adaptTime = evalin('base', 'adaptTime');
%             data.myPeriod = adaptTime;
%             ttCreatePeriodicTask(data.myName, starttime, data.myPeriod, 'ID_code', data);
%             ttAttachCBS(data.myName, 'Manager');
%         end
    end
end
%% Global idle task
    data.myName = 'GlobalIdleTask';
    data.exectime = idleExec;
    ttCreatePeriodicTask('GlobalIdleTask', starttime, idlePeriod, 'Idle_code', data);
end