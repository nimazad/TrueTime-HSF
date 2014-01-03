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

function execTime = TaskExecution(data)
execTime = data.exectime;
changeCnt = evalin('base', 'changeCnt');
numberOfChanges = evalin('base', 'numberOfChanges');
Scenario = evalin('base', 'Scenario');
switch Scenario
    case 1
        maxExecTime = evalin('base', 'maxExecTime');
        %%Server 1
        if strcmp(data.myName,'S1T3')
            if (ttCurrentTime()>100 && ttCurrentTime()<300) || (ttCurrentTime()>800)
                execTime = execTime + normrnd((data.myPeriod*maxExecTime), (data.myPeriod*maxExecTime)/10);
            else
                execTime = normrnd((data.exectime*2)/3, data.exectime/10);
            end
            %% Write in the workspace
            DynamicTask = evalin('base', 'DynamicTask');
            [row col] = size(DynamicTask(1,:));
            DynamicTask(1, col+1) = execTime;
            DynamicTask(2, col) = ttCurrentTime();
            assignin('base','DynamicTask',DynamicTask);
        end
        %%Server 2
        if strcmp(data.myName,'S2T3')
            if (ttCurrentTime()>300 && ttCurrentTime()<500) || (ttCurrentTime()>700 && ttCurrentTime()<900)
                execTime = execTime + normrnd((data.myPeriod*maxExecTime), (data.myPeriod*maxExecTime)/10);
            else
                execTime = normrnd((data.exectime*2)/3, data.exectime/10);
            end
            %% Write in the workspace
            DynamicTask2 = evalin('base', 'DynamicTask2');
            [row col] = size(DynamicTask2(1,:));
            DynamicTask2(1, col+1) = execTime;
            DynamicTask2(2, col) = ttCurrentTime();
            assignin('base','DynamicTask2',DynamicTask2);
        end
        %%Server 3
        if strcmp(data.myName,'S3T3')
            if (ttCurrentTime()<500)
                execTime = execTime + normrnd((data.myPeriod*maxExecTime), (data.myPeriod*maxExecTime)/10);
            else
                execTime = normrnd((data.exectime*2)/3, data.exectime/10);
            end
            %% Write in the workspace
            DynamicTask3 = evalin('base', 'DynamicTask3');
            [row col] = size(DynamicTask3(1,:));
            DynamicTask3(1, col+1) = execTime;
            DynamicTask3(2, col) = ttCurrentTime();
            assignin('base','DynamicTask3',DynamicTask3);
        end
        %%Server 4
        if strcmp(data.myName,'S4T3')
            if (ttCurrentTime()>100 && ttCurrentTime()<300) || (ttCurrentTime()>500)
                execTime = execTime + normrnd((data.myPeriod*maxExecTime), (data.myPeriod*maxExecTime)/10);
            else
                execTime = normrnd((data.exectime*2)/3, data.exectime/10);
            end
            %% Write in the workspace
            DynamicTask4 = evalin('base', 'DynamicTask4');
            [row col] = size(DynamicTask4(1,:));
            DynamicTask4(1, col+1) = execTime;
            DynamicTask4(2, col) = ttCurrentTime();
            assignin('base','DynamicTask4',DynamicTask4);
        end
    case 2
        maxExecTime = evalin('base', 'maxExecTime');
        %%Server 2
        if strcmp(data.myName,'S2T3')
            if (ttCurrentTime()>100 && ttCurrentTime()<500) || (ttCurrentTime()>700 && ttCurrentTime()<900)
                execTime = execTime + normrnd((data.myPeriod*maxExecTime), (data.myPeriod*maxExecTime)/10);
            else
                execTime = normrnd((data.exectime*2)/3, data.exectime/10);
            end
            %% Write in the workspace
            DynamicTask2 = evalin('base', 'DynamicTask2');
            [row col] = size(DynamicTask2(1,:));
            DynamicTask2(1, col+1) = execTime;
            DynamicTask2(2, col) = ttCurrentTime();
            assignin('base','DynamicTask2',DynamicTask2);
        end
        %%Server 3
        if strcmp(data.myName,'S3T2')
            if (ttCurrentTime()<500)
                execTime = execTime + normrnd((data.myPeriod*maxExecTime), (data.myPeriod*maxExecTime)/10);
            else
                execTime = normrnd((data.exectime*2)/3, data.exectime/10);
            end
            %% Write in the workspace
            DynamicTask3 = evalin('base', 'DynamicTask3');
            [row col] = size(DynamicTask3(1,:));
            DynamicTask3(1, col+1) = execTime;
            DynamicTask3(2, col) = ttCurrentTime();
            assignin('base','DynamicTask3',DynamicTask3);
        end
        %%Server 4
        if strcmp(data.myName,'S4T3')
            if (ttCurrentTime()>100 && ttCurrentTime()<300) || (ttCurrentTime()>500)
                execTime = execTime + normrnd((data.myPeriod*maxExecTime), (data.myPeriod*maxExecTime)/10);
            else
                execTime = normrnd((data.exectime*2)/3, data.exectime/10);
            end
            %% Write in the workspace
            DynamicTask4 = evalin('base', 'DynamicTask4');
            [row col] = size(DynamicTask4(1,:));
            DynamicTask4(1, col+1) = execTime;
            DynamicTask4(2, col) = ttCurrentTime();
            assignin('base','DynamicTask4',DynamicTask4);
        end
    case 3
        execTime = data.exectime;
        if (strcmp(data.myName,'S1T1'))
            if (ttCurrentTime()>100 && ttCurrentTime()<200)
                maxExecTime = evalin('base', 'maxExecTime');
                execTime = execTime + (data.myPeriod*maxExecTime/2);
            end
            if (ttCurrentTime()>250 && ttCurrentTime()<300)
                maxExecTime = evalin('base', 'maxExecTime');
                execTime = execTime + (data.myPeriod*maxExecTime);
            end
            if (ttCurrentTime()>500 && ttCurrentTime()<600)
                maxExecTime = evalin('base', 'maxExecTime');
                execTime = execTime + (data.myPeriod*maxExecTime*2);
            end
            if (ttCurrentTime()>800 && ttCurrentTime()<900)
                maxExecTime = evalin('base', 'maxExecTime');
                execTime = execTime + (data.myPeriod*maxExecTime/5);
            end
            %% Write in the workspace
            DynamicTask = evalin('base', 'DynamicTask');
            [row col] = size(DynamicTask(1,:));
            DynamicTask(1, col+1) = execTime;
            DynamicTask(2, col) = ttCurrentTime();
            assignin('base','DynamicTask',DynamicTask);
        end
        if (strcmp(data.myName,'S2T1'))
            if (ttCurrentTime()>100 && ttCurrentTime()<200)
                maxExecTime = evalin('base', 'maxExecTime');
                execTime = execTime + (data.myPeriod*maxExecTime*3);
            end
            if (ttCurrentTime()>300 && ttCurrentTime()<350)
                maxExecTime = evalin('base', 'maxExecTime');
                execTime = execTime + (data.myPeriod*maxExecTime/3);
            end
            if (ttCurrentTime()>500 && ttCurrentTime()<600)
                maxExecTime = evalin('base', 'maxExecTime');
                execTime = execTime + (data.myPeriod*maxExecTime*2);
            end
            if (ttCurrentTime()>650 && ttCurrentTime()<700)
                maxExecTime = evalin('base', 'maxExecTime');
                execTime = execTime + (data.myPeriod*maxExecTime/2);
            end
            if (ttCurrentTime()>800 && ttCurrentTime()<900)
                maxExecTime = evalin('base', 'maxExecTime');
                execTime = execTime + (data.myPeriod*maxExecTime/5);
            end
            %% Write in the workspace
            DynamicTask2 = evalin('base', 'DynamicTask2');
            [row col] = size(DynamicTask2(1,:));
            DynamicTask2(1, col+1) = execTime;
            DynamicTask2(2, col) = ttCurrentTime();
            assignin('base','DynamicTask2',DynamicTask2);
        end
        
    case 4
        execTime = data.exectime;
        if (strcmp(data.myName,'S1T1'))%  strcmp(data.myName,'S3T1') )
            decodeTimes = evalin('base', 'VideoDecoder.data');
            execTime = decodeTimes(data.NoJobs,3)/10000;
            %% Write in the workspace
            DynamicTask = evalin('base', 'DynamicTask');
            [row col] = size(DynamicTask(1,:));
            DynamicTask(1, col+1) = execTime;
            DynamicTask(2, col) = ttCurrentTime();
            assignin('base','DynamicTask',DynamicTask);
        end
         if (strcmp(data.myName,'S2T1') )
            decodeTimes = evalin('base', 'VideoDecoder.data');
            execTime = decodeTimes(data.NoJobs,2)/10000;
         
             %mode = floor(ttCurrentTime()/200);
             %if mod(mode,2)
             %   execTime = 4;
             %else
             %    execTime = 4;
             %end
            %% Write in the workspace
            DynamicTask2 = evalin('base', 'DynamicTask2');
            [row col] = size(DynamicTask2(1,:));
            DynamicTask2(1, col+1) = execTime;
            DynamicTask2(2, col) = ttCurrentTime();
            assignin('base','DynamicTask2',DynamicTask2);
        end
        if (strcmp(data.myName,'S3T1') )
            decodeTimes = evalin('base', 'VideoDecoder.data');
            execTime = decodeTimes(data.NoJobs,1)/10000;
            %% Write in the workspace
            DynamicTask3 = evalin('base', 'DynamicTask3');
            [row col] = size(DynamicTask3(1,:));
            DynamicTask3(1, col+1) = execTime;
            DynamicTask3(2, col) = ttCurrentTime();
            assignin('base','DynamicTask3',DynamicTask3);
        end
end
end


function u = totalUtilization(data)
u = 0;
for i=1:length(data.ServerNames)
    u = u + (ttGetCBSBudget(data.ServerNames{i})/data.ServerPeriods(i));
end
end