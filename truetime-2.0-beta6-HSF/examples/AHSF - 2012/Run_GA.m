clc
close all
%return
clear
VideoDecoder = importdata('C:\Users\nmd01\Desktop\alloallo1\alloallo1.txt')
%%
numberOfServers = 3;
NumberOfTaskInServer = 3;
SystemUtilization = 1;
maxSystemUtilization = 1;
Adaptive = 1;
Scenario = 4;
random = 0;
ControllerType = 1;
maxExecTime = 0.2;
simTime = 10000;

NumberOfGenes = 8;
controllerFrequency = 4;
NumberOfIndividuals = 150;%should be even
MaxGeneration = 100;
initGeneration = 1;
%%
if initGeneration
    dl_K_s = rand;
        dl_d1 = 0;
        dl_d2 = 0;
        dl_h = 0;
        idle_K_s = 0;
        idle_d1 = 0;
        idle_d2 = 0;
        idle_h = 0;
    for i=1:NumberOfIndividuals
        dl_K_s = rand;
        dl_d1 = rand;
        dl_d2 = rand;
        while dl_K_s + dl_d1 + dl_d2>2
            dl_K_s = rand;
            dl_d1 = rand;
            dl_d2 = rand;
        end
        dl_h = rand;
        idle_K_s = rand;
        idle_d1 = rand;
        idle_d2 = rand;
        while idle_K_s + idle_d1 + idle_d2 > 2
            idle_K_s = rand;
            idle_d1 = rand;
            idle_d2 = rand;
        end
        idle_h = rand;
        
        controllerFrequency = 6;%randint(1,1,[2,10]);
        Population(i,:) = [dl_K_s dl_d1 dl_d2 dl_h idle_K_s idle_d1 idle_d2 idle_h];
    end
end
%%
for Generation=1:MaxGeneration
    %t = cputime;
    for i=1:NumberOfIndividuals
        Parameters = Population(i,:);
        %controllerFrequency = Parameters(6);
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
        fitness_idle(i) = sum(finish-((idle./MeanBudgets)));%/(1706-350);
        fitness_dl(i) = sum(finish-(dlMiss.*10));%/1706;
        
        totalFitness(i) = sum(finish-(dlMiss.*10+(idle./MeanBudgets)));%/1706;
    end
    %%
    clc
    fprintf('    -----------------------------------------Generation: %d -----------------------------------------\n',Generation)
    fprintf('    -----------------------------------------Best Fitness -------------------------------------------\n')
    [bestTotalFitness(Generation) totalFit] = max(totalFitness);
    plot(bestTotalFitness,'r-*')
    hold on
    history(Generation,:) = Population(totalFit,:);
    disp(history)
    %% Increase fitted individuals
    [bestFitness_idle(Generation) fit_idle] = max(fitness_idle);
    plot(bestFitness_idle,'g-*')
    hold on
    [bestFitness_dl(Generation) fit_dl] = max(fitness_dl);
    plot(bestFitness_dl,'b-*')
    hold on
    bestIndividuals_idle(Generation,:) = Population(fit_idle,:);
    bestIndividuals_dl(Generation,:) = Population(fit_dl,:);
    %fprintf('    -----------------------------------------Best Fitness -------------------------------------------\n')
    %disp(BestIndividuals);
    temp_idle = fitness_idle;
    temp_dl = fitness_dl;
    temp_total = totalFitness;
    
    %fprintf('    -----------------------------------------Mean Fitness -------------------------------------------\n')
    %MeanFitness(Generation) = mean(fitness);
    %MedianFitness(Generation) = median(fitness);
    %plot(MeanFitness,'b*')
    %hold on
    %plot(MedianFitness,'k*')
    poolCounter = NumberOfIndividuals+1;
    Pool_idle = Population;
    Pool_dl = Population;
    Pool_total = Population;
    for j=1:NumberOfIndividuals/4
        [best_idle fit_idle_temp] = max(temp_idle);
        [best_dl fit_dl_temp] = max(temp_dl);
        [best_total fit_total_temp] = max(temp_total);
        for i=poolCounter:poolCounter+((NumberOfIndividuals/2)-2*j)
            Pool_idle(i,:) = Population(fit_idle_temp,:);
            Pool_dl(i,:) = Population(fit_dl_temp,:);
            Pool_total(i,:) = Population(fit_total_temp,:);
        end
        poolCounter = i;
        temp_idle(fit_idle_temp) = intmin;
        temp_dl(fit_dl_temp) = intmin;
        temp_total(fit_total_temp) = intmin;
    end
    
    PoolSize = size(Pool_idle);
    %Two fit individuals are copied from the previous generation
    Population(1,:) = Population(fit_idle,:);
    Population(2,:) = Population(fit_dl,:);
    Population(3,:) = Population(totalFit,:);
    %tempTotalFitness = totalFitness;
    %tempTotalFitness(totalFit) = intmin;
    %[bestTotalFitness2(Generation) totalFit2] = max(tempTotalFitness);
    Population(4,:) = Population(fit_idle,:);
    Population(4,1:4) = Population(fit_dl,1:4);
    [poolCounter col] = size(Pool_idle);
    %for i=1:2:4
    %     Pool_idle(poolCounter+i,:) = Population(3,:);
    %     Pool_dl(poolCounter+i,:) = Population(3,:);
    %     Pool_idle(poolCounter+i+1,:) = Population(4,:);
    %     Pool_dl(poolCounter+i+1,:) = Population(4,:);
    %end
    for i = 3:NumberOfIndividuals/2
        
        [parents_index] = randint(2,1,[1,PoolSize(1,1)]);
        P1 = randint(1,1,[1 5]);
        switch P1
            case 1
                Parent1 = Pool_idle(parents_index(1),:);
            case 2
                Parent1 = Pool_dl(parents_index(1),:);
            otherwise
                Parent1 = Pool_total(parents_index(1),:);
        end
        
        P2 = randint(1,1,[1 5]);
        switch P2
            case 1
                Parent2 = Pool_idle(parents_index(2),:);
            case 2
                Parent2 = Pool_dl(parents_index(2),:);
            otherwise
                Parent2 = Pool_total(parents_index(2),:);
        end
        
        %CrossOver
        CrossOverPoint = randint(1,1,[1,NumberOfGenes]);
        Population(i*2-1,[1 CrossOverPoint]) = Parent1([1 CrossOverPoint]);
        Population(i*2-1,[CrossOverPoint NumberOfGenes]) = Parent2([CrossOverPoint NumberOfGenes]);
        %Mutation
        MutationPoint = randint(1,1,[1,NumberOfGenes]);
        Population(i*2-1,MutationPoint) = Mutation(MutationPoint, Population(i*2-1,MutationPoint));
        %CrossOver
        Population(i*2,[1 CrossOverPoint]) = Parent2([1 CrossOverPoint]);
        Population(i*2,[CrossOverPoint NumberOfGenes]) = Parent1([CrossOverPoint NumberOfGenes]);
        %Mutation
        MutationPoint = randint(1,1,[1,NumberOfGenes]);
        Population(i*2,MutationPoint) = Mutation(MutationPoint, Population(i*2,MutationPoint));
    end
    
end
save('BestIndividuals_idle.mat', 'bestIndividuals_idle');
save('BestIndividuals_dl.mat', 'bestIndividuals_dl');
save('Population-Decoder.mat', 'Population');
save('history.mat', 'history');