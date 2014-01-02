function [exectime, data] = controller_code(segment, data)

switch segment
    case 1
        writeInWorkspace(data)
        myName = strcat('Server',int2str(data.Server));
        newIdleTime = 0;%ttGetCPUTime(strcat(myName, '-idle'));
        oldIdleTime = data.idleTime(data.Server);
        data.idleTime(data.Server) = newIdleTime ;
        myServerPeriod = data.myPeriod*data.ServerPeriods(data.Server);
        idlePerc = (newIdleTime-oldIdleTime)/myServerPeriod;
        ttAnalogOut(data.Server + 3, idlePerc);
        ttAnalogOut(data.Server + 6, allError(data));
        
        if(allDlMisses(data)>0)
            Qs = ttGetCBSBudget(myName) + PIController(allDlMisses(data), data.oldDLMissError(data.Server), 0.07, 0.03);
        else
            Qs = ttGetCBSBudget(myName)- PIController(idlePerc - 0.015, data.oldIdleError(data.Server), 0.1, 0.3);
        end
        myPrevUtilization = (ttGetCBSBudget(myName)/data.ServerPeriods(data.Server));
        availableUtilization = (1 - (totalUtilization(data) - myPrevUtilization));
        if  Qs >availableUtilization*data.ServerPeriods(data.Server)
                %availableUtilization = releaseUtilization(data, availableUtilization, (Qs/data.ServerPeriods(data.Server)) - availableUtilization);
                Qs = availableUtilization*data.ServerPeriods(data.Server);
        end
        %ttSetCBSParameters(myName, Qs, data.ServerPeriods(data.Server));
        data.oldDLMissError(data.Server) = allDlMisses(data);
        data.oldIdleError(data.Server) = idlePerc - 0.05;
        %outp = ttGetCBSBudget('Server1')+ idlePerc*data.myPeriod
        %outp = ttCallBlockSystem(1,allError(data), 'PID_Controller');
        ttAnalogOut(data.Server + 9, Qs);
        resetError(data);
        exectime = data.exectime;
        
        %myName
        %allDlMissesHistory(data)
        U = totalUtilization(data);
        ttAnalogOut(14, U);
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

function [sum] = allError(data)
sum = 0;
for i=1:length(data.tasknames)
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        taskData = ttGetData(task);
        if taskData.dlMisses > 0
            sum = sum + taskData.error/taskData.dlMisses;
        end
    end
end
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
ttAnalogOut(data.Server, allDlMisses(data));
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
end