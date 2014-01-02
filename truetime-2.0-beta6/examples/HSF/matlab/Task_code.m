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
if Scenario==1
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
else
    if Scenario == 2
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
    else
        if Scenario == 3
            if (strcmp(data.myName,'S1T3') || strcmp(data.myName,'S1T2')) && changeCnt<numberOfChanges
                changeFrequency = evalin('base', 'changeFrequency');
                changeTime = evalin('base', 'changeTime');
                mode = evalin('base', 'mode');
                maxExecTime = evalin('base', 'maxExecTime');
                if ttCurrentTime()>changeTime
                    mode = -mode ;
                    assignin('base','mode',mode);
                    changeTime = changeTime + changeFrequency;
                    assignin('base','changeTime',changeTime);
                    changeCnt = changeCnt +1;
                    assignin('base','changeCnt',changeCnt);
                end
                execTime = normrnd((data.exectime*2)/3, data.exectime/10);
                if mode == -1
                    execTime = execTime + normrnd((data.myPeriod*maxExecTime), (data.myPeriod*maxExecTime)/10);
                end
                %not more than 100% Utilization
                if execTime > data.myPeriod
                    execTime = data.myPeriod;
                end
                %% Write in the workspace
                DynamicTask = evalin('base', 'DynamicTask');
                [row col] = size(DynamicTask(1,:));
                DynamicTask(1, col+1) = execTime;
                DynamicTask(2, col) = ttCurrentTime();
                assignin('base','DynamicTask',DynamicTask);
                
            else
                if strcmp(data.myName,'S1T3') && changeCnt<numberOfChanges
                    changeFrequency = evalin('base', 'changeFrequency');
                    changeTime = evalin('base', 'changeTime');
                    mode = evalin('base', 'mode');
                    maxExecTime = evalin('base', 'maxExecTime');
                    if ttCurrentTime()>changeTime
                        mode = -mode ;
                        assignin('base','mode',mode);
                        changeTime = changeTime + changeFrequency;
                        assignin('base','changeTime',changeTime);
                        changeCnt = changeCnt +1;
                        assignin('base','changeCnt',changeCnt);
                    end
                    execTime = normrnd((data.exectime*2)/3, data.exectime/10);
                    if mode == -1
                        execTime = execTime + normrnd((data.myPeriod*maxExecTime), (data.myPeriod*maxExecTime)/10);
                    end
                    %not more than 100% Utilization
                    if execTime > data.myPeriod
                        execTime = data.myPeriod;
                    end
                    %% Write in the workspace
                    DynamicTask = evalin('base', 'DynamicTask');
                    [row col] = size(DynamicTask(1,:));
                    DynamicTask(1, col+1) = execTime;
                    DynamicTask(2, col) = ttCurrentTime();
                    assignin('base','DynamicTask',DynamicTask);
                end
            end
        end
    end
end
end