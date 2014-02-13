function [exectime, data] = Controller_code(segment, data)
switch segment
    case 1
%         fprintf('%s started at %d<cont. code>\n',data.myName, ttCurrentTime())
        %if ttCurrentTime() > evalin('base', 'samplingTime')
            writeInWorkspace(data);%For plotting the results
            resetError(data);
            adaptive = evalin('base', 'Adaptive');
            %changeTaskPeriods();
            if adaptive
               adapt(data); 
            end
            if evalin('base', 'identification') == 1 
                    changePAlphaOneByOne(data);           
            end
        %end
            exectime = data.exectime;
    case 2
        exectime = -1;
%         fprintf('%s finished at %d<cont. code>\n',data.myName, ttCurrentTime())
end
end
function changePAlphaOneByOne(data)
    myName = strcat('Server',int2str(data.Server));
    operating_bandwidth = evalin('base', 'operating_bandwidth');
    bandwidth_var = evalin('base', 'bandwidth_var');
    operating_period = evalin('base', 'operating_period');
    period_var = evalin('base', 'period_var');
    if evalin('base', 'changeP')
        P = operating_period+period_var/2*(sin(ttCurrentTime()/evalin('base', 'PeriodChange')));
        alpha = operating_bandwidth;
    else
        P = operating_period;
        alpha = operating_bandwidth + bandwidth_var/2*(sin(ttCurrentTime()/evalin('base', 'alphaChange')));
    end
    
    B = alpha * ceil(P)/100;
    %fprintf('B = %d, P=%d at %d\n', floor(B), ceil(P), ttCurrentTime())
    ttSetCBSParameters(myName, floor(B), ceil(P));    
end

function changeTaskPeriods()
if ttCurrentTime() > evalin('base', 'simTime')/2
    ttSetPeriod(5, 'S1T1');
    data = ttGetData('S1T1');
    data.exectime = 2;
    ttSetData('S1T1', data);
end
%ttGetPeriod('S1T1')

end

function adapt(data)
    currentIdleTime = evalin('base', 'currentIdleTime');
    SchedulingError = evalin('base', 'SchedulingError');
    samplingTime = evalin('base', 'samplingTime');
    DeadlineMisses = evalin('base', 'DeadlineMisses');
    currentInvocations = evalin('base', 'currentInvocations');
    myName = strcat('Server',int2str(data.Server));
    if ttCurrentTime() < samplingTime
        return;
    end
    [row col] = size(currentIdleTime(data.Server,:));
    beta = currentIdleTime(data.Server,col);
    
    %rho = -0.0013/2;
    %Omega = rho.*(ttGetCBSPeriod(myName) - 1) + .2988;
    mu = SchedulingError(data.Server,col);
    dlmiss = DeadlineMisses(data.Server,col) + currentInvocations(data.Server,col);
    
    K = (load('PIController'));
    
    filtered = 0;
    if filtered
        if col>evalin('base', 'h')
            h=evalin('base', 'h');
        else
            h=col-1;
        end;
        a = 1;
        b = 1/h.*ones(1,h);
        beta= filter(b,a,currentIdleTime(data.Server,col-h:col));
        beta = beta(h);
        mu= filter(b,a, SchedulingError(data.Server,col-h:col));
        mu = mu(h);
        dlmiss = filter(b, a, DeadlineMisses(data.Server,col-h:col) + currentInvocations(data.Server,col-h:col));
        dlmiss = dlmiss(h);
        K = K.K_lqr;
    else
        K = K.K_lqr;
    end
    normalBeta = beta./samplingTime;
    normalMu = mu./samplingTime;
    
    %x1 = 100*f_alpha(beta,mu)./(samplingTime);
    %x2 = 100*((beta+mu)./(samplingTime) - 5.7*.0001*ttGetCBSPeriod(myName));
    x1 = 100.*(normalBeta-normalMu);
    x2 = dlmiss;
    %x3 = 100.*(Omega + beta./samplingTime);
    e1 = data.r1 - x1;
    e2 = data.r2 - x2;
    %e3 = data.r3 - x3;
   
    intStates = evalin('base', 'intStates');
    intStates(1,1) = e1 + intStates(1,1);
    intStates(1,2) = e2 + intStates(1,2);
    %intStates(1,3) = e3 + intStates(1,3);
    e4 = intStates(1,1);
    e5 = intStates(1,2);
    %e6 = intStates(1,3);
    assignin('base','intStates',intStates);
    %[x1; x2; x3; x4]
    %u = ceil(-K*[x1; x2; x3; x4])
    u = (-K*[e1; e2; e4; e5; ]);
    alpha = u(1) +  evalin('base', 'operating_bandwidth');
    P = u(2) + evalin('base', 'operating_period');
    if alpha < 30
        alpha = 30;
    elseif alpha > 100
        alpha = 100;
    end
    if P < 2
        P = 2;
    elseif P > 300
        P = 300;
    end
    B = alpha * P /100;
    %fprintf('e1 = %f, e2 = %f, u_1 = %f, u_2 = %f,alpha = %f, P = %f at %d\n', e1, e2, u(1), u(2), alpha, P, ttCurrentTime())
    ttSetCBSParameters(myName, floor(B), ceil(P));
end

%% This function returns sum of all invocations due to queueing
function [sum] = allInvocations(data)
sum = 0;
for i=1:evalin('base', 'NumberOfTaskInServer')
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        sum = sum + ttGetInvocations(task);
    end
end
end

%% This function returns sum of all releases
function [sum] = allReleases(data)
sum = 0;
for i=1:evalin('base', 'NumberOfTaskInServer')
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        taskData = ttGetData(task);
        sum = sum + taskData.NoJobs;
    end
end
end

%% This function returns sum of all deadline misses in the system up to this time point
function [sum] = allDlMisses(data)
sum = 0;
for i=1:evalin('base', 'NumberOfTaskInServer')
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        taskData = ttGetData(task);
        sum = sum + taskData.dlMisses;
    end
end
end

%% Returns sum of processor utilization (if the frameworks is adaptive the total utilization also changes over time)
function u = totalUtilization(data)
u = 0;
for i=1:evalin('base', 'numberOfServers')
    u = u + (ttGetCBSBudget(data.ServerNames{i})/data.ServerPeriods(i));
end
end

%% Resets dlMisses, error and CBSError
function resetError(data)
for i=1:evalin('base', 'NumberOfTaskInServer') 
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        taskData = ttGetData(task);
        %taskData.sumExectime = 0;
        taskData.dlMissesHistory = taskData.dlMissesHistory + taskData.dlMisses;
        taskData.dlMisses = 0;
        %taskData.NoJobs = 0;
        taskData.error = 0;
        ttSetData(task, taskData);
    end
end
myName = strcat('Server',int2str(data.Server));
ttResetCBSError(myName);
end

%% Returns the total dlMissesHistory
function [sum] = allDlMissesHistory(data)
sum = 0;
for i=1:evalin('base', 'NumberOfTaskInServer')
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        taskData = ttGetData(task);
        sum = sum + taskData.dlMissesHistory;
    end
end
end

%% Returns the total number of finished jobs
function [sum] = totalFinishedTasks(data)
sum = 0;
for i=1:evalin('base', 'NumberOfTaskInServer')
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        taskData = ttGetData(task);
        sum = sum + taskData.finished;
    end
end
end

%% Writes variables to the workspace
function writeInWorkspace(data)
samplingTime = evalin('base', 'samplingTime');
DeadlineMisses = evalin('base', 'DeadlineMisses');
Releases = evalin('base', 'Releases');
currentReleases = evalin('base', 'currentReleases');
ControlTime = evalin('base', 'ControlTime');
TotalDeadlineMiss = evalin('base', 'TotalDeadlineMiss');
Budgets = evalin('base', 'Budgets');
[row col] = size(DeadlineMisses(data.Server,:));
Periods = evalin('base', 'Periods');
[row col] = size(DeadlineMisses(data.Server,:));
DeadlineMisses(data.Server, col+ 1) = allDlMisses(data);
Releases(data.Server, col+ 1) = allReleases(data);
currentReleases(data.Server, col+ 1) = Releases(data.Server, col+1)-Releases(data.Server, col);
[row col] = size(ControlTime(data.Server,:));
ControlTime(data.Server, col+ 1) = ttCurrentTime();
[row col] = size(TotalDeadlineMiss(data.Server,:));
TotalDeadlineMiss(data.Server, col+ 1) = allDlMissesHistory(data);
[row col] = size(Budgets(data.Server,:));
myName = strcat('Server',int2str(data.Server));
%% ******************
       
Budgets(data.Server, col+ 1) = ttGetCBSBudget(myName);%;/samplingTime;
Periods(data.Server, col+ 1) = ttGetCBSPeriod(myName);%;/samplingTime;
assignin('base','DeadlineMisses',DeadlineMisses);
assignin('base','ControlTime',ControlTime);
assignin('base','TotalDeadlineMiss',TotalDeadlineMiss);
assignin('base','Budgets',Budgets);
assignin('base','Periods',Periods);
assignin('base','currentReleases',currentReleases);
assignin('base','Releases',Releases);
baseUnused = evalin('base', 'unused');
[row col] = size(baseUnused(data.Server,:));
baseUnused(data.Server, col+1) = ttGetUnusedBudget(myName);
assignin('base','unused',baseUnused);

IdleTime = evalin('base', 'IdleTime');
[row col] = size(IdleTime(data.Server,:));
IdleTime(data.Server, col+1) = ttGetCPUTime(strcat(myName, '-idle'));
assignin('base','IdleTime',IdleTime);

totalAssigned = evalin('base', 'totalAssigned');
[row col] = size(totalAssigned(data.Server,:));
totalAssigned(data.Server, col+1) = ttGetCBSAssigned(myName);
assignin('base','totalAssigned',totalAssigned);

currentAssigned = evalin('base', 'currentAssigned');
[row col] = size(currentAssigned(data.Server,:));
currentAssigned(data.Server, col+1) = totalAssigned(data.Server, col+1) - totalAssigned(data.Server, col);
assignin('base','currentAssigned',currentAssigned);

currentIdleTime = evalin('base', 'currentIdleTime');
[row col] = size(currentIdleTime(data.Server,:));% 
idle = (IdleTime(data.Server, col+1) - IdleTime(data.Server, col));
%currentIdleTime(data.Server, col+1) = ( samplingTime* .5*.59 -idle)/samplingTime;%ttGetCBSPeriod(myName);
currentIdleTime(data.Server, col+1) =  ceil(idle);%- samplingTime* .5*.59)/samplingTime;
assignin('base','currentIdleTime',currentIdleTime);

totalU = evalin('base', 'totalU');
[row col] = size(totalU);
totalU(1,col+1) = totalUtilization(data);
assignin('base','totalU',totalU);

TotalFinishes = evalin('base', 'TotalFinishes');
[row col] = size(TotalFinishes);
TotalFinishes(data.Server,col+1) = totalFinishedTasks(data);
assignin('base','TotalFinishes',TotalFinishes);

TotalInvocations = evalin('base', 'TotalInvocations');
[row col] = size(TotalInvocations);
TotalInvocations(data.Server,col+1) = allInvocations(data);
assignin('base','TotalInvocations',TotalInvocations);

currentInvocations = evalin('base', 'currentInvocations');
[row col] = size(currentInvocations);
currentInvocations(data.Server,col+1) = TotalInvocations(data.Server,col+1)-TotalInvocations(data.Server,col);
assignin('base','currentInvocations',currentInvocations);


SchedulingError = evalin('base', 'SchedulingError');
[row col] = size(SchedulingError);%
%SchedulingError(data.Server,col+1) =  (samplingTime* .5*.59 - ttGetCBSError(myName))/samplingTime;%ttGetCBSPeriod(myName);
SchedulingError(data.Server,col+1) =  ceil(ttGetCBSError(myName));% - samplingTime* .5*.59)/samplingTime;
assignin('base','SchedulingError',SchedulingError);
currentLoad = evalin('base', 'currentLoad');
currentLoad(row,col+1) = 0;
assignin('base','currentLoad',currentLoad);
end

