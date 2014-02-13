function [exectime, data] = Task_code(segment, data)

switch segment
    case 1
        data.NoJobs = data.NoJobs + 1;
        ttSetData(data.myName, data);
        exectime = TaskExecution(data);
    case 2
        %ttAnalogOut(1, data.u)
        data.sumExectime = data.sumExectime + data.exectime;
        data.finished = data.finished +1;
        ttSetData(data.myName, data);
        ttSetDLFlag(false, data.myName); %important
        exectime = -1;
        %data.myName
end
end

%% In this function we can read execution times of a decoder task or any other dynamic task.
function execTime = TaskExecution(data)
execTime = data.exectime;
if (strcmp(data.myName,'S1T1'))%  strcmp(data.myName,'S3T1') )
    decodeTimes = evalin('base', 'VideoDecoder.data');
    execTime = (decodeTimes(data.NoJobs,1))/2;
    %% Write in the workspace
    DynamicTask = evalin('base', 'DynamicTask');
    [row col] = size(DynamicTask(1,:));
    DynamicTask(1, col+1) = execTime;
    DynamicTask(2, col+1) = ttCurrentTime();
    assignin('base','DynamicTask',DynamicTask);
end

if (strcmp(data.myName,'S1T2'))%  strcmp(data.myName,'S3T1') )
    decodeTimes = evalin('base', 'VideoDecoder.data');
    execTime = (decodeTimes(data.NoJobs+1000,3))/2;
    %% Write in the workspace
    DynamicTask2 = evalin('base', 'DynamicTask2');
    [row col] = size(DynamicTask2(2,:));
    DynamicTask2(1, col+1) = execTime;
    DynamicTask2(2, col+1) = ttCurrentTime();
    assignin('base','DynamicTask2',DynamicTask2);
end
end