function [exectime, data] = DeadlineMiss_Code(seg, data)
taskname = sscanf(ttGetInvoker,'DLtimer:%s');
data = ttGetData(taskname);
data.dlMisses = data.dlMisses +1;
%ttKillJob(taskname);
%strcat('task killed: ', taskname)
ttSetDLFlag(true, taskname);
%fprintf('Deadline miss %s at %d\n', taskname, ttCurrentTime())
ttSetData(taskname, data);
exectime = -1;
end

