clc
clear
close all
%%
numberOfServers = 3;
NumberOfTaskInServer = 3;
SystemUtilization = 1;
maxSystemUtilization = 1;
Adaptive = 1;
Scenario = 3;
random = 0;
ControllerType = 1;
maxExecTime = 0.2;
simTime = 1000;

dl_K_s = 0.5;
dl_d1 = 0.2;
dl_d2 = 0.2;
dl_h = .03;
idle_K_s = 0.5;
idle_d1 = 0.2;
idle_d2 = 0.2;
idle_h = .03;

controllerFrequency = 6;
%%
dl_h = 0.05*rand;
PrevFitness = intmin ;
direction = 1;
for iterations=1:100
    h_history(iterations) = dl_h;
    %fprintf('    -----------------------------------------Iteration -------------------------------------------\n')
    %disp(h_history);
    Parameters = [dl_K_s dl_d1 dl_d2 dl_h idle_K_s idle_d1 idle_d2 idle_h];
    sim('HSF_Fuzzy.mdl', simTime)
    
    S1_dlMiss = max(TotalDeadlineMiss(1,:));
    S1_Finish = max(TotalFinishes(1,:));
    S1_MissRatio = S1_dlMiss / (S1_dlMiss+S1_Finish);
    S2_dlMiss = max(TotalDeadlineMiss(2,:));
    S2_Finish = max(TotalFinishes(2,:));
    S2_MissRatio = S2_dlMiss / (S2_dlMiss+S2_Finish);
    S3_dlMiss = max(TotalDeadlineMiss(3,:));
    S3_Finish = max(TotalFinishes(3,:));
    S3_MissRatio = S3_dlMiss / (S3_dlMiss+S3_Finish);
    missRatio(1,:) =  [S1_MissRatio S2_MissRatio S3_MissRatio];
    finish(1,:) =  [S1_Finish S2_Finish S3_Finish];
    dlMiss(1,:) =  [S1_dlMiss S2_dlMiss S3_dlMiss];
    %disp('    ----Deadline Miss Ratio----');
    %disp(x)
    S1_idle = max(IdleTime(1,:));
    S2_idle = max(IdleTime(2,:));
    S3_idle = max(IdleTime(3,:));
    idle(1,:) = [S1_idle S2_idle S3_idle];
    %% Fitness Function
    for ServerID=1:numberOfServers
        MeanBudgets(ServerID) = mean(Budgets(ServerID,find(Budgets(ServerID,:)>0)));
    end
    %fitness(iterations) = sum(finish-(dlMiss.*20+(idle./MeanBudgets)));
    fitness(iterations) = sum(finish-(dlMiss.*20));
   
    hold on
    plot(fitness,'k*')

    if fitness(iterations) >= PrevFitness
        Prev_h = dl_h;
        dl_h = dl_h + direction*0.01*dl_h;
    else
        direction = -direction;
        dl_h = Prev_h + direction*0.01*Prev_h;
    end
    if iterations > 2 && fitness(iterations) == fitness(iterations-2)
        dl_h = 0.05*rand;
        PrevFitness = intmin;
    end
    PrevFitness = fitness(iterations);
end