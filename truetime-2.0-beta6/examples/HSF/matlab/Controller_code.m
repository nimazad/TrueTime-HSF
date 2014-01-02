function [exectime, data] = Controller_code(segment, data)

switch segment
    case 1
        writeInWorkspace(data);%For plotting the results
        if evalin('base', 'Adaptive')
            data.idleLoopCounter = data.idleLoopCounter +1;
            idleSetPoint = 0.01;
            myName = strcat('Server',int2str(data.Server));
            %% Calculating idleTime based on the idle task execution
            newIdleTime = ttGetCPUTime(strcat(myName, '-idle'));
            oldIdleTime = data.idleTime(data.Server);
            data.idleTime(data.Server) = newIdleTime ;
            myServerPeriod = data.myPeriod*data.ServerPeriods(data.Server);
            idlePerc = (newIdleTime-oldIdleTime)/myServerPeriod;
            %% Calculating a new budget based on dl misses and idle time
            if(allDlMisses(data)>0)
                Qs = ttGetCBSBudget(myName) + PIController(allDlMisses(data), data.oldDLMissError(data.Server), 0.07, 0.04);
            else
                if(rem(data.idleLoopCounter,3) == 0)|| (evalin('base', 'ControllerType') == 0)
                    Qs = ttGetCBSBudget(myName)- PIController(idlePerc - idleSetPoint, data.oldIdleError(data.Server), 0.25, 0.1);
                else
                    Qs = ttGetCBSBudget(myName);
                end
            end
            %% Overload controller
            myPrevUtilization = (ttGetCBSBudget(myName)/data.ServerPeriods(data.Server));
            availableUtilization = (1 - (totalUtilization(data) - myPrevUtilization));
            if  Qs >availableUtilization*data.ServerPeriods(data.Server)
                availableUtilization = releaseUtilization(data, availableUtilization, (Qs/data.ServerPeriods(data.Server)) - availableUtilization);
                Qs = availableUtilization*data.ServerPeriods(data.Server);
            end
            %% Update budget
            ttSetCBSParameters(myName, Qs, data.ServerPeriods(data.Server));
            data.oldDLMissError(data.Server) = allDlMisses(data);
            data.oldIdleError(data.Server) = idlePerc - idleSetPoint;
        end
        resetError(data);
        exectime = data.exectime;
        
        %myName
        %allDlMissesHistory(data)
        U = totalUtilization(data);
        %ttAnalogOut(14, U);
    case 2
        exectime = -1;
end
end

function availableU = releaseUtilization(data, avU, neededU)
%Server 1 highest criticality
availableU = avU;
for i=length(data.ServerNames):-1:data.Server+1
    myName = strcat('Server',int2str(i));
    u = (ttGetCBSBudget(data.ServerNames{i})/data.ServerPeriods(i));
    if (u >= neededU)
        u = u - neededU;
        Qs = u*data.ServerPeriods(i);
        ttSetCBSParameters(myName, Qs, data.ServerPeriods(i));
        availableU = availableU + neededU;
        %myName
        return;
    else
        ttSetCBSParameters(myName, 0, data.ServerPeriods(i));%shut down
        availableU = availableU + u;
        neededU = neededU - u;
    end
end

end
function u = totalUtilization(data)
u = 0;
for i=1:length(data.ServerNames)
    u = u + (ttGetCBSBudget(data.ServerNames{i})/data.ServerPeriods(i));
end
end
function budget = PIController(error, oldError, KI, KP)
budget = KI*oldError + KP * error;
end

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

function resetError(data)
for i=1:length(data.tasknames)
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        taskData = ttGetData(task);
        %taskData.sumExectime = 0;
        taskData.dlMissesHistory = taskData.dlMissesHistory + taskData.dlMisses;
        taskData.dlMisses = 0;
        taskData.NoJobs = 0;
        taskData.error = 0;
        ttSetData(task, taskData);
    end
end
%ttAnalogOut(data.Server, allDlMisses(data));
end

function result = myRound(input)
accuracy = 100;
result = round(input*accuracy)/accuracy;
end

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
IdleTime(data.Server, col+1) = data.idleTime(data.Server);
assignin('base','IdleTime',IdleTime);


totalU = evalin('base', 'totalU');
[row col] = size(totalU);
totalU(1,col+1) = totalUtilization(data);
assignin('base','totalU',totalU);

TotalFinishes = evalin('base', 'TotalFinishes');
[row col] = size(TotalFinishes);
TotalFinishes(data.Server,col+1) = totalFinishedTasks(data);
assignin('base','TotalFinishes',TotalFinishes);


end