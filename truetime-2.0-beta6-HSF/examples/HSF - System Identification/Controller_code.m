function [exectime, data] = Controller_code(segment, data)
switch segment
    case 1
        writeInWorkspace(data);%For plotting the results
        resetError(data);
        exectime = data.exectime;
    case 2
        exectime = -1;
end
end
%% This function returns sum of all deadline misses in the system up to this time point
function [sum] = allDlMisses(data)
sum = 0;
for i=1:length(data.tasknames)
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        taskData = ttGetData(task);
        sum = sum + taskData.dlMisses;
    end
end
end

%% Returns sum of processor utilization (if the frameworks is adaptive the total utilization also changes over time)
function u = totalUtilization(data)
u = 0;
for i=1:evalin('base', 'numberOfServers')
    u = u + (ttGetCBSBudget(data.ServerNames{i})/data.ServerPeriods(i));
end
end

%% Resets dlMisses, error and CBSError
function resetError(data)
for i=1:length(data.tasknames)
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        taskData = ttGetData(task);
        %taskData.sumExectime = 0;
        taskData.dlMissesHistory = taskData.dlMissesHistory + taskData.dlMisses;
        taskData.dlMisses = 0;
        %taskData.NoJobs = 0;
        taskData.error = 0;
        ttSetData(task, taskData);
    end
end
myName = strcat('Server',int2str(data.Server));
ttResetCBSError(myName);
end

%% Returns the total dlMissesHistory
function [sum] = allDlMissesHistory(data)
sum = 0;
for i=1:length(data.tasknames)
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        taskData = ttGetData(task);
        sum = sum + taskData.dlMissesHistory;
    end
end
end

%% Returns the total number of finished jobs
function [sum] = totalFinishedTasks(data)
sum = 0;
for i=1:length(data.tasknames)
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        taskData = ttGetData(task);
        sum = sum + taskData.finished;
    end
end
end

%% Writes variables to the workspace
function writeInWorkspace(data)
DeadlineMisses = evalin('base', 'DeadlineMisses');
ControlTime = evalin('base', 'ControlTime');
TotalDeadlineMiss = evalin('base', 'TotalDeadlineMiss');
Budgets = evalin('base', 'Budgets');
[row col] = size(DeadlineMisses(data.Server,:));
DeadlineMisses(data.Server, col+ 1) = allDlMisses(data);
[row col] = size(ControlTime(data.Server,:));
ControlTime(data.Server, col+ 1) = ttCurrentTime();
[row col] = size(TotalDeadlineMiss(data.Server,:));
TotalDeadlineMiss(data.Server, col+ 1) = allDlMissesHistory(data);
[row col] = size(Budgets(data.Server,:));
myName = strcat('Server',int2str(data.Server));
Budgets(data.Server, col+ 1) = ttGetCBSBudget(myName);
assignin('base','DeadlineMisses',DeadlineMisses);
assignin('base','ControlTime',ControlTime);
assignin('base','TotalDeadlineMiss',TotalDeadlineMiss);
assignin('base','Budgets',Budgets);
baseUnused = evalin('base', 'unused');
[row col] = size(baseUnused(data.Server,:));
baseUnused(data.Server, col+1) = ttGetUnusedBudget(myName);
assignin('base','unused',baseUnused);

IdleTime = evalin('base', 'IdleTime');
[row col] = size(IdleTime(data.Server,:));
IdleTime(data.Server, col+1) = ttGetCPUTime(strcat(myName, '-idle'));
assignin('base','IdleTime',IdleTime);


totalU = evalin('base', 'totalU');
[row col] = size(totalU);
totalU(1,col+1) = totalUtilization(data);
assignin('base','totalU',totalU);

TotalFinishes = evalin('base', 'TotalFinishes');
[row col] = size(TotalFinishes);
TotalFinishes(data.Server,col+1) = totalFinishedTasks(data);
assignin('base','TotalFinishes',TotalFinishes);

SchedulingError = evalin('base', 'SchedulingError');
[row col] = size(SchedulingError);
%if ttGetCBSError(myName)>0
   SchedulingError(data.Server,col+1) = ttGetCBSError(myName);%/data.ServerPeriods(data.Server);
   ttGetCBSError(myName)
%else
 %  idlePerc = -(calcIdlePerc(myName, data)-idleSetPoint);
  % SchedulingError(data.Server,col+1) = idlePerc;
%end
assignin('base','SchedulingError',SchedulingError);
end

