function [exectime, data] = Task_code(segment, data)

switch segment
    case 1
        data.NoJobs = data.NoJobs + 1;
        data.exectime = TaskExecution(data);
        ttSetData(data.myName, data);
        currentLoad = evalin('base', 'currentLoad');
        [r c] = size(currentLoad);
        currentLoad(data.Server,c) = currentLoad(data.Server,c) + data.exectime;%/data.myPeriod;
        assignin('base','currentLoad',currentLoad);
        exectime = data.exectime;
        myName = strcat('Server',int2str(data.Server));
         fprintf('time:%d - %s-j%d started beta: %d <task code>\n', ttCurrentTime(), data.myName, data.NoJobs, ttGetCPUTime(strcat(myName, '-idle')));
    case 2
        %ttAnalogOut(1, data.u)
        data.sumExectime = data.sumExectime + data.exectime;
        data.finished = data.finished +1;
        ttSetData(data.myName, data);
        ttSetDLFlag(0, data.myName); %important
        exectime = -1;
        %data.myName
        myName = strcat('Server',int2str(data.Server));
         fprintf('time:%d - %s-j%d finished beta: %d invocations%d<task code>\n', ttCurrentTime(), data.myName, data.NoJobs, ttGetCPUTime(strcat(myName, '-idle')), ttGetInvocations(data.myName));
end
end

%% In this function we can read execution times of a decoder task or any other dynamic task.
function execTime = TaskExecution(data)
execTime = data.exectime;
if (strcmp(data.myName,'S1T1'))%  strcmp(data.myName,'S3T1') )
    %ttCurrentTime()
    decodeTimes = evalin('base', 'VideoDecoder.data');
    execTime = (decodeTimes(data.NoJobs,1))/2;
%     if ttCurrentTime() > evalin('base', 'simTime')/2
%         execTime = (decodeTimes(data.NoJobs,1))/10;
%     end
    %% Write in the workspace
    DynamicTask = evalin('base', 'DynamicTask');
    [row col] = size(DynamicTask(1,:));
    DynamicTask(1, col+1) = execTime;
    DynamicTask(2, col+1) = ttCurrentTime();
    assignin('base','DynamicTask',DynamicTask);
end

if (strcmp(data.myName,'S1T2'))%  strcmp(data.myName,'S3T1') )
    decodeTimes = evalin('base', 'VideoDecoder.data');
    %if evalin('base', 'identification') & ttCurrentTime() < evalin('base', 'simTime')/2
    %;
    %else
             execTime = (decodeTimes(data.NoJobs+1000,3))/2;
    %end
    %% Write in the workspace
    DynamicTask2 = evalin('base', 'DynamicTask2');
    [row col] = size(DynamicTask2(2,:));
    DynamicTask2(1, col+1) = execTime;
    DynamicTask2(2, col+1) = ttCurrentTime();
    assignin('base','DynamicTask2',DynamicTask2);
end
execTime = data.exectime;
%if (strcmp(data.myName,'S1T1'))
%    execTime
%end
end