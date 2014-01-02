function simple_init(arg)
clc
%% Simulation settings
random = 0;
PeriodicServers = 1;

if random == 1
    periods = evalin('base', 'periods');
    exectimes = evalin('base', 'exectimes');
    tasknames = evalin('base', 'tasknames');
    ServerPeriods = evalin('base', 'ServerPeriods');
    ServerBudgates = evalin('base', 'ServerBudgates');
    ServerNames = evalin('base', 'ServerNames');
else
    ServerNames     = {'Server1', 'Server2', 'Server3'};
    ServerPeriods   = [0.5,        1.5,       2];
    ServerBudgates  = [0.1,       0.5,     0.1];
    %Server1 tasks
    tasknames{1}    = {'S1T1', 'S1T2', 'S1T3'};
    periods(1,:)    =  [4,        3,      2];
    exectimes(1,:)  =  [0.1,    0.1,    0.1];
    %Server2 tasks
    tasknames{2}    = {'S2T1', 'S2T2', 'S2T3'};
    periods(2,:)    =  [4,        3,      9];
    exectimes(2,:)  =  [0.1,   0.1,      0.1];
    %Server3 tasks
    tasknames{3}    = {'S3T1', 'S3T2', ''};
    periods(3,:)    =  [4,        3,      0];
    exectimes(3,:)  =  [0.1,      0.1,      0];
end

%% Initialize the kernel
ttInitKernel('prioHEDF')
HardCBS = 1;
data.K = 2;            % controller proportional gain
data.dlMisses = 0;
data.dlMissesHistory = 0;
data.NoJobs = 0;
data.sumExectime =0;
data.CPUTime = 0;
data.neededCPU = 0;
data.error = 0;
starttime = 0.0;
idlePeriod = 100000;
idleExec = 100000;
ttCreateHandler('dl_miss_handler', 1, 'DeadlineMiss_Code')
data.oldIdleError= [0           0           0];
data.oldDLMissError= [0           0           0];
data.idleTime   =[0             0           0];
data.ServerPeriods = ServerPeriods;
data.ServerNames = ServerNames;

%% Servers and tasks creations
for ServerID=1:length(ServerNames)
    if random == 1
        data.tasknames = tasknames(ServerID,:);
    else
        data.tasknames = tasknames{ServerID};
    end
    data.Server = ServerID;
    ttCreateCBS(ServerNames{ServerID}, ServerBudgates(ServerID), ServerPeriods(ServerID), HardCBS)

    
    for i=1:length(data.tasknames)
        if ~strcmp(data.tasknames{i},'')
            data.exectime = exectimes(ServerID, i);
            %Utilization(ServerID) = Utilization(ServerID) + data.exectime/periods(ServerID, i);
            data.myName   = data.tasknames{i};
            ttCreatePeriodicTask(data.tasknames{i}, starttime, periods(ServerID, i), 'ctrl_code', data)
            ttAttachDLHandler(data.tasknames{i}, 'dl_miss_handler');
            ttAttachCBS(data.tasknames{i}, ServerNames{ServerID});
        end
    end
    %% Create idle tasks
    if PeriodicServers 
        data.exectime   = idleExec;   % control task execution time
        data.myName     = strcat(ServerNames{ServerID}, '-idle');
        ttCreatePeriodicTask(data.myName, starttime, idlePeriod, 'idle_code', data)
        ttAttachCBS(data.myName, ServerNames{ServerID})
    end
    %% Create controller tasks
    data.PrevIdleTime = 0;
    data.exectime   = 0;   % control task execution time
    data.myName     = strcat(ServerNames{ServerID}, '-controller');
    data.myPeriod   = 1;
    ttCreatePeriodicTask(data.myName, starttime, data.myPeriod*ServerPeriods(ServerID), 'controller_code', data)
    ttAttachCBS(data.myName, ServerNames{ServerID})
end

