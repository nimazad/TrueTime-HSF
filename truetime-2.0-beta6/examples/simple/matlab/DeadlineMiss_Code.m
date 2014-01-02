function [exectime, data] = DeadlineMiss_Code(seg, data)
taskname = sscanf(ttGetInvoker,'DLtimer:%s');
data = ttGetData(taskname);
%if ttGetRemainedCPUTime(taskname)>0
    %RemainedTime = ttGetRemainedCPUTime(taskname)
    %taskname
    %currentTime = ttCurrentTime()
    data.dlMisses = data.dlMisses +1;
    
    %NODLMiss = data.dlMisses 
    %ttGetRemainedCPUTime(taskname)
    data.error = data.error + (ttGetRemainedCPUTime(taskname)/ ttGetPeriod(taskname));
    error = data.error;
    ttKillJob(taskname);
%end
ttSetData(taskname, data);
ttAnalogOut(data.Server, allDlMisses(data));
% calculate scheduling error

exectime = -1;
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
