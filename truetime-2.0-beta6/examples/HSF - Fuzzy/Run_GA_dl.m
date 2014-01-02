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

K_z = 0;
K_s = .2;
K_m = .3;
K_l = .4;
h= .03;
s=0.03;
m=0.06;
l=0.1;
border = 0.1;
NumberOfGenes = 4;
controllerFrequency = 6;
NumberOfIndividuals = 30;%should be even
MaxGeneration = 20;
initGeneration = 1;
%%  0    0.0301    0.6141    0.0075
idle_K_s = 0;
idle_d1 = 0.0301;
idle_d2 = 0.6141;
idle_h = 0.0075;
if initGeneration
    for i=1:NumberOfIndividuals
        dl_K_s = rand;
        dl_d1 = rand;
        dl_d2 = rand;
        dl_h = rand;        
        controllerFrequency = 6;%randint(1,1,[2,10]);
        Population(i,:) = [dl_K_s dl_d1 dl_d2 dl_h idle_K_s idle_d1 idle_d2 idle_h];
    end
end
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
        fitness(i) = sum(finish-(dlMiss.*10));
    end
    history(Generation,:) = fitness;    
    %%
    clc
    fprintf('    -----------------------------------------Generation: %d -----------------------------------------\n',Generation)
    %disp(history)
    %% Increase fitted individuals
    [C Fit] = max(fitness);
    BestFitness(Generation)= C;
    BestIndividuals(Generation,:) = Population(Fit,:);
    fprintf('    -----------------------------------------Best Fitness -------------------------------------------\n')
    disp(BestIndividuals);
    temp = fitness;    
    save('BestIndividuals(rand).mat', 'BestIndividuals');
    %fprintf('    -----------------------------------------Best Fitness -------------------------------------------\n')
    plot(BestFitness,'r-*')
    hold on
    %fprintf('    -----------------------------------------Mean Fitness -------------------------------------------\n')
    %MeanFitness(Generation) = mean(fitness);
    MedianFitness(Generation) = median(fitness);
    %plot(MeanFitness,'b*')
    hold on
    plot(MedianFitness,'k*')
    poolCounter = NumberOfIndividuals+1;
    Pool = Population;
    for j=1:NumberOfIndividuals/3
        [C Fit] = max(temp);
        fitTemp(j,:) = Population(Fit,:);
        for i=poolCounter:poolCounter+((NumberOfIndividuals/2)-2*j)
            Pool(i,:) = Population(Fit,:);
        end
        poolCounter = i;
        temp(Fit) = intmin;
    end
    %%
    PoolSize = size(Pool);
    %Two fit individuals are copied from the previous generation
    Population(1:2,:) = fitTemp(1:2,:);
    for i = 2:NumberOfIndividuals/2
        
        [Parents] = randint(2,1,[1,PoolSize(1,1)]);
        %CrossOver
        CrossOverPoint = randint(1,1,[1,NumberOfGenes]);
        Population(i*2-1,[1 CrossOverPoint]) = Pool(Parents(1), [1 CrossOverPoint]);
        Population(i*2-1,[CrossOverPoint NumberOfGenes]) = Pool(Parents(2), [CrossOverPoint NumberOfGenes]);
        %Mutation
        MutationPoint = randint(1,1,[1,NumberOfGenes]);
        Population(i*2-1,MutationPoint) = Mutation(MutationPoint, Population(i*2-1,MutationPoint));
        %CrossOver
        Population(i*2,[1 CrossOverPoint]) = Pool(Parents(2), [1 CrossOverPoint]);
        Population(i*2,[CrossOverPoint NumberOfGenes]) = Pool(Parents(1), [CrossOverPoint NumberOfGenes]);
        %Mutation
        MutationPoint = randint(1,1,[1,NumberOfGenes]);
        Population(i*2,MutationPoint) = Mutation(MutationPoint, Population(i*2,MutationPoint));
    end
    
end