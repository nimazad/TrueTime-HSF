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
        exectime = -1;
end
end

%% In this function we can read execution times of a decoder task or any other dynamic task.
function execTime = TaskExecution(data)
execTime = data.exectime;
end