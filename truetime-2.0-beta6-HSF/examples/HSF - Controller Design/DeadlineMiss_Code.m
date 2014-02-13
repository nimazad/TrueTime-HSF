function [exectime, data] = DeadlineMiss_Code(seg, data)
taskname = sscanf(ttGetInvoker,'DLtimer:%s');
data = ttGetData(taskname);
data.dlMisses = data.dlMisses +1;
%ttKillJob(taskname);
%strcat('task killed: ', taskname)
ttSetDLFlag(1, taskname); %important
fprintf('Deadline miss %s job %d at %d\n', taskname, data.NoJobs, ttCurrentTime())
ttSetData(taskname, data);
exectime = -1;
end

