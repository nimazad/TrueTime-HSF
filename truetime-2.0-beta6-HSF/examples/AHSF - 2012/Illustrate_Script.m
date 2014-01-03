%clc
%Idle Time
S1_idle = max(IdleTime(1,:));
S2_idle = max(IdleTime(2,:));
S3_idle = max(IdleTime(3,:));
idle(simulationNumber,:) = [S1_idle S2_idle S3_idle];
%Deadline Miss
S1_dlMiss = max(TotalDeadlineMiss(1,:));
S2_dlMiss = max(TotalDeadlineMiss(2,:));
S3_dlMiss = max(TotalDeadlineMiss(3,:));
DlMiss(simulationNumber,:) = [S1_dlMiss S2_dlMiss S3_dlMiss];
%Finished Jobs
S1_Finish = max(TotalFinishes(1,:));
S2_Finish = max(TotalFinishes(2,:));
S3_Finish = max(TotalFinishes(3,:));
Finished(simulationNumber,:)  = [S1_Finish S2_Finish S3_Finish];
%Deadline Miss Ratio
S1_MissRatio = S1_dlMiss / (S1_dlMiss+S1_Finish);
S2_MissRatio = S2_dlMiss / (S2_dlMiss+S2_Finish);
S3_MissRatio = S3_dlMiss / (S3_dlMiss+S3_Finish);
MissRatio(simulationNumber,:) = [S1_MissRatio S2_MissRatio S3_MissRatio];
%Total value
value(simulationNumber) = sum(MissRatio(simulationNumber,:).*wieghts(3));
for i=1:numberOfServers
    MeanBudgets(i) = mean(Budgets(i,find(Budgets(i,:)>0)));
end
MissFitness = (Finished(simulationNumber,:)-DlMiss(simulationNumber,:).*10);
myFitness(simulationNumber,1) = sum(MissFitness-idle(simulationNumber,:)./(MeanBudgets));%.*wieghts(3));
myFitness_idle(simulationNumber,1) = sum(Finished(simulationNumber,:)-idle(simulationNumber,:)./(MeanBudgets));%/(1706-350);%.*wieghts(3));
myFitness_dl(simulationNumber,1) = sum(MissFitness);%/(1706);%.*wieghts(3));

for i=1:numberOfServers
    subplot(numberOfServers,1,i);
    j = j + 1;
    plot(ControlTime(i,:), Budgets(i,:), shape)
    hold on
    plot(ControlTime(i,:), unused(i,:), '.')
    hold on
    if i ==3
        xlabel('Time');
    end
    label = strcat('B_',int2str(i),'C_{1,',int2str(i),'}');
    ylabel(label);
end
%% Dynamic Task
if simulationNumber<2
    return
end
j=1;
subplot(numberOfServers,1,j);
[r c] = size(DynamicTask)
DynamicTask(:,c)=[];
plot(DynamicTask(2,:), DynamicTask(1,:), 'g-')
%legend('PI', 'Fixed', 'Fuzzy', 'Dynamic task')
legend('Fixed', 'Adaptive','Dynamic task')
j= j + 1;
subplot(numberOfServers,1,j);
[r c] = size(DynamicTask2)
DynamicTask2(:,c)=[];
plot(DynamicTask2(2,:), DynamicTask2(1,:), 'g-')
j= j + 1;
subplot(numberOfServers,1,j);
[r c] = size(DynamicTask3)
DynamicTask3(:,c)=[];
plot(DynamicTask3(2,:), DynamicTask3(1,:), 'g-')


disp('    S1        S2        S3 ');

disp('    --# Deadline Misses --');
disp(DlMiss)
disp('    ----Fitness----');
disp(myFitness)
disp('    ----Fitness_idle----');
disp(myFitness_idle)
disp('    ----Fitness_dl----');
disp(myFitness_dl)
disp('    ----Finished Jobs----');
disp(Finished)
disp('    ----IdleTime----');
disp(idle)
disp('    ----Deadline Miss Ratio----');
disp(MissRatio)
disp('    ----Total Value----');
disp(value')