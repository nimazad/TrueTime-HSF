function [exectime, data] = Controller_code(segment, data)
switch segment
    case 1
        idleSetPoint = .01;
        writeInWorkspace(data, idleSetPoint);%For plotting the results
        if evalin('base', 'Adaptive')
            data.idleLoopCounter = data.idleLoopCounter +1;
            myName = strcat('Server',int2str(data.Server));
            idlePerc = calcIdlePerc(myName, data);
            data.idleTime(data.Server) = ttGetCPUTime(strcat(myName, '-idle'));
            dlMissPerc = ttGetCBSError(myName)/data.ServerPeriods(data.Server);
            
            %% Calculating a new budget based on dl misses and idle time
            if(evalin('base', 'ControllerType')==1)
                Parameters = evalin('base', 'Parameters');
                
                dl_K_s      = Parameters(1);
                dl_d1       = Parameters(2);
                dl_d2       = Parameters(3);
                dl_h        = Parameters(4);
                idle_K_s    = Parameters(5);
                idle_d1     = Parameters(6);
                idle_d2     = Parameters(7);
                idle_h      = Parameters(8);
            
                %% Finding system state
                dl_border   = dl_h*1.5;
                idle_border = idle_h*1.5;
                m_dl_s = Membership(dlMissPerc, 0, .0, dl_border);
                m_dl_l = Membership(dlMissPerc, .0, dl_border, dl_border);
                %d_dl = ttGetCBSError(myName) - data.oldDLMissError(data.Server) ;
                m_i_s = Membership(idlePerc, 0, 0, idle_border);
                m_i_l = Membership(idlePerc, .0, idle_border, idle_border);
                %d_i = idlePerc - data.oldIdleError(data.Server);
                if (dlMissPerc>dl_border)
                    m_dl_l = 1;
                end
                if (idlePerc>idle_border)
                    m_i_l = 1;
                end
                rule(1) = FuzzyAnd([m_dl_s m_i_s]);%i-loop
                rule(2) = FuzzyAnd([m_dl_s m_i_l]);%i-loop
                rule(3) = FuzzyAnd([m_dl_l m_i_s]);%dl-loop
                rule(4) = FuzzyAnd([m_dl_l m_i_l]);%dl-loop
                
                dl_K_z = 0;
                dl_K_m = dl_K_s + dl_d1;
                dl_K_l = dl_K_m + dl_d2;
                dl_s = dl_h;
                dl_m = 2*dl_h;
                dl_l = 3*dl_h;
                dl_KP = FindGaint('DL Miss', dlMissPerc, data.oldDLMissError(data.Server), dl_s, dl_m, dl_l, dl_K_z, dl_K_s, dl_K_m, dl_K_l);
                NewBudget(3:4) = ttGetCBSBudget(myName) + data.ServerPeriods(data.Server)*PIController(ttGetCBSError(myName)/data.ServerPeriods(data.Server), data.oldDLMissError(data.Server), 0, dl_KP);
                
                idle_K_z = 0;
                idle_K_m = idle_K_s + idle_d1;
                idle_K_l = idle_K_m + idle_d2;
                idle_s = idle_h;
                idle_m = 2*idle_h;
                idle_l = 3*idle_h;
                KP = FindGaint('Idle Time', idlePerc, data.oldIdleError(data.Server), idle_s, idle_m, idle_l, idle_K_z, idle_K_s, idle_K_m, idle_K_l);
                NewBudget(1:2) = ttGetCBSBudget(myName) + data.ServerPeriods(data.Server)*PIController(abs(idlePerc - idleSetPoint), 0, 0, KP);
                writeErrors(idlePerc, dlMissPerc, data.Server);
                Qs = sum(rule.*NewBudget)/sum(rule);
                
                %Debug
                %fprintf('server %d, budget: %f, dlMiss: %f, idle: %f, border: %f, Time: %f\n',data.Server, Qs, dlMissPerc, idlePerc, border, ttCurrentTime());
                %rule
                %if data.Server == 3
                    %disp('------------------------------------');
                    %fprintf('server 1 Qs:%f dlB:%f idleB:%f dlMissPerc:%f idlePerc:%f at:%f\n', Qs, NewBudget(3), NewBudget(1), dlMissPerc, idlePerc, ttCurrentTime());
                    %disp(rule);
                    %disp(NewBudget);
                %end
            else%PI controller
                if(allDlMisses(data)>0)
                    Qs = ttGetCBSBudget(myName) + PIController(allDlMisses(data), data.oldDLMissError(data.Server), .07, .04);
                else
                    Qs = ttGetCBSBudget(myName)- PIController(idlePerc - idleSetPoint, data.oldIdleError(data.Server), .25, .1);
                end
            end
            
            %% Overload controller
            myPrevUtilization = (ttGetCBSBudget(myName)/data.ServerPeriods(data.Server));
            availableUtilization = (1 - (totalUtilization(data) - myPrevUtilization));
            if  Qs >availableUtilization*data.ServerPeriods(data.Server)
                totalUtilization(data);
                availableUtilization = releaseUtilization(data, availableUtilization, (Qs/data.ServerPeriods(data.Server)) - availableUtilization);
                Qs = availableUtilization*data.ServerPeriods(data.Server);
            end
            %% Update budget
            if Qs < 0
                Qs = 0;
            end
            ttSetCBSParameters(myName, Qs, data.ServerPeriods(data.Server));
            if(evalin('base', 'ControllerType')==1)
                data.oldDLMissError(data.Server) = ttGetCBSError(myName)/data.ServerPeriods(data.Server);
                data.oldIdleError(data.Server) = idlePerc ;%- idleSetPoint;
            else
                data.oldDLMissError(data.Server) = allDlMisses(data);
                data.oldIdleError(data.Server) = idlePerc - idleSetPoint;
            end
            
        end
        resetError(data);
        exectime = data.exectime;
    case 2
        exectime = -1;
end
end
function idlePerc = calcIdlePerc(myName, data)
%% Calculating idleTime based on the idle task execution
newIdleTime = ttGetCPUTime(strcat(myName, '-idle'));
oldIdleTime = data.idleTime(data.Server);
%data.idleTime(data.Server) = newIdleTime ;
myServerPeriod = data.myPeriod*data.ServerPeriods(data.Server);
idlePerc = (newIdleTime-oldIdleTime)/myServerPeriod;
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
        %fprintf('shut down %s at:', myName, ttCurrentTime());
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
        %taskData.NoJobs = 0;
        taskData.error = 0;
        ttSetData(task, taskData);
    end
end
myName = strcat('Server',int2str(data.Server));
ttResetCBSError(myName);
%ttAnalogOut(data.Server, allDlMisses(data));
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

function [sum] = totalFinishedTasks(data)
sum = 0;
for i=1:length(data.tasknames)
    if ~strcmp(data.tasknames{i},'')
        task = data.tasknames{i};
        taskData = ttGetData(task);
        sum = sum + taskData.finished;
    end
end
end

function writeInWorkspace(data, idleSetPoint)
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

IdleTime = evalin('base', 'IdleTime');
[row col] = size(IdleTime(data.Server,:));
IdleTime(data.Server, col+1) = ttGetCPUTime(strcat(myName, '-idle'));
assignin('base','IdleTime',IdleTime);


totalU = evalin('base', 'totalU');
[row col] = size(totalU);
totalU(1,col+1) = totalUtilization(data);
assignin('base','totalU',totalU);

TotalFinishes = evalin('base', 'TotalFinishes');
[row col] = size(TotalFinishes);
TotalFinishes(data.Server,col+1) = totalFinishedTasks(data);
assignin('base','TotalFinishes',TotalFinishes);

%SchedulingError = evalin('base', 'SchedulingError');
%[row col] = size(SchedulingError);
%if ttGetCBSError(myName)>0
%    SchedulingError(data.Server,col+1) = ttGetCBSError(myName)/data.ServerPeriods(data.Server);
%else
%    idlePerc = -(calcIdlePerc(myName, data)-idleSetPoint);
%    SchedulingError(data.Server,col+1) = idlePerc;
%end
%assignin('base','SchedulingError',SchedulingError);
end

%% Fuzzy calculations
function K = FindGaint(loop, e, olde, s, m, l, K_z, K_s, K_m, K_l)
%disp('----------------------------')
%disp(loop)
%e;
%% Delta error memberships
de = e - olde;
mde_nl = Membership(de, -l, -l, -m);
mde_nm = Membership(de, -l, -m, -s);
mde_ns = Membership(de, -m, -s, 0);
mde_z = Membership(de, -s, 0, s);
mde_ps = Membership(de, 0, s, m);
mde_pm = Membership(de, s, m, l);
mde_pl = Membership(de, m, l, l);
%% Error memberships
me_z = Membership(e, 0, 0, s);
me_ps = Membership(e, 0, s, m);
me_pm = Membership(e, s, m, l);
me_pl = Membership(e, m, l, l);
%% Rule base
rule(1) = FuzzyAnd([me_z mde_nl]);%nm
rule(2) = FuzzyAnd([me_z mde_nm]);%ns
rule(3) = FuzzyAnd([me_z mde_ns]);%ns
rule(4) = FuzzyAnd([me_z mde_z]);%z
rule(5) = FuzzyAnd([me_z mde_ps]);%ps
rule(6) = FuzzyAnd([me_z mde_pm]);%pm
rule(7) = FuzzyAnd([me_z mde_pl]);%pl
RuleOut(1:7) = [-K_m -K_s -K_s K_z K_s K_m K_l] ;


rule(8) = FuzzyAnd([me_ps mde_nl]);%nm
rule(9) = FuzzyAnd([me_ps mde_nm]);%ns
rule(10) = FuzzyAnd([me_ps mde_ns]);%z 
rule(11) = FuzzyAnd([me_ps mde_z]);%ps
rule(12) = FuzzyAnd([me_ps mde_ps]);%pm
rule(13) = FuzzyAnd([me_ps mde_pm]);%pl
rule(14) = FuzzyAnd([me_ps mde_pl]);%pl
RuleOut(8:14) = [-K_m -K_s K_z K_s K_m K_l K_l] ;

rule(15) = FuzzyAnd([me_pm mde_nl]);%ns
rule(16) = FuzzyAnd([me_pm mde_nm]);%z
rule(17) = FuzzyAnd([me_pm mde_ns]);%ps
rule(18) = FuzzyAnd([me_pm mde_z]);%pm
rule(19) = FuzzyAnd([me_pm mde_ps]);%pl
rule(20) = FuzzyAnd([me_pm mde_pm]);%pl
rule(21) = FuzzyAnd([me_pm mde_pl]);%pl
RuleOut(15:21) = [-K_s K_z K_s K_m K_l K_l K_l] ;

rule(22) = FuzzyAnd([me_pl mde_nl]);%z
rule(23) = FuzzyAnd([me_pl mde_nm]);%ps
rule(24) = FuzzyAnd([me_pl mde_ns]);%pm
rule(25) = FuzzyAnd([me_pl mde_z]);%pl
rule(26) = FuzzyAnd([me_pl mde_ps]);%pl
rule(27) = FuzzyAnd([me_pl mde_pm]);%pl
rule(28) = FuzzyAnd([me_pl mde_pl]);%pl
RuleOut(22:28) = [K_z K_s K_m K_l K_l K_l K_l] ;
if strcmp(loop, 'Idle Time')
    RuleOut = - RuleOut;
    RuleOut(1:7) = [K_l K_m K_s K_m K_m K_s K_z] ;   
    RuleOut(8:14) = [K_m K_s K_z K_z K_z K_z K_z] ;
end
K = sum(rule.*RuleOut)/sum(rule);
if(abs(e)>l || abs(de)>l)
    %fprintf('out of bound at:%f\n', ttCurrentTime())
    K = K_l;
    if strcmp(loop, 'Idle Time')
        K = -K;
    end
end
end

function y = FuzzyAnd(x) 
   y = min(x);
end

function writeErrors(idlePerc, dlMissPerc, server)
IdleError = evalin('base', 'IdleError');
[row col] = size(IdleError);
IdleError(server,col+1) = idlePerc;
assignin('base','IdleError',IdleError);

DlError = evalin('base', 'DlError');
[row col] = size(DlError);
DlError(server,col+1) = dlMissPerc;
assignin('base','DlError',DlError);
end