%%
clc
close all
%range = find(output(:,5)==150);%change freq
All = 2;
S1 = 1;
show = S1;
%range = find(output(:,show)>0);%All RM
myData = output;%(range,:);
%%
%'S1-RM' 'All-RM' 'Server Period' 'Controller Period' 'Change Frequency'
%'Control/Server' 'Change/Control' 'change/server'
%plot(myData(:,6), myData(:,2), '*')
LoopCount = round(1+10*(max(myData(:,3))-min(myData(:,3))));
meanRM = zeros(LoopCount, 2);
strdRM = zeros(LoopCount, 2);
medianRM= zeros(LoopCount, 2);
meanRM_UnW = zeros(LoopCount, 2);
strdRM_UnW = zeros(LoopCount, 2);
medianRM_UnW = zeros(LoopCount, 2);
i=.5;
row = 0;
while i<1.3
    i = i+.1;
    row = row +1;
    for j=1:2
        range = find(abs(100000000*(myData(:,3)-i))<1 & myData(:,4)==j-1);
        meanRM(row,j) = mean(myData(range,show));
        medianRM(row,j) = median(myData(range,show));
        strdRM(row,j) = std(myData(range,show));
        
        meanRM_UnW(row,j) = mean(myData(range,6));
        medianRM_UnW(row,j) = median(myData(range,6));
        strdRM_UnW(row,j) = std(myData(range,6));
    end
end
X=1:LoopCount;
X = X./10 + .6

errorbar(X, meanRM(:,1), strdRM(:,1),'-xr');
%plot(X,meanRM(:,1))
xlabel('Utilization');
ylabel('Total Deadline Miss Ratio');
hold on
errorbar(X, meanRM(:,2), strdRM(:,2),'-xb');
%hold on
%errorbar(X, meanRM_UnW(:,1), strdRM_UnW(:,1),'-xk');
%hold on
%errorbar(X, meanRM_UnW(:,2), strdRM_UnW(:,2),'-xg');
legend('HSF','AHSF')%, 'Unweighted HSF', 'Unweighted AHSF')
return
%%
%'S1-RM' 'All-RM' 'Server Period' 'Controller Period' 'Change Frequency'
%'Control/Server' 'Change/Control' 'change/server'
%plot(myData(:,6), myData(:,2), '*')
meanRM = zeros(1,max(myData(:,6)));
strdRM = zeros(1,max(myData(:,6)));
medianRM= zeros(1,max(myData(:,6)));
for i=1:2*max(myData(:,6))
    range = find(myData(:,6)==i/2);
    meanRM(i) = mean(myData(range,show));
    medianRM(i) = median(myData(range,show));
    strdRM(i) = std(myData(range,show));
    
end
X=1:.5:max(myData(:,6))+.5;

errorbar(X, meanRM, strdRM,'-xr');
xlabel('Control Period / Server Period');
ylabel('Total Deadline Miss Ratio');
hold on
%errorbar(X, medianRM, strdRM,'-xb');
return
%%
%'S1-RM' 'All-RM' 'Server Period' 'Controller Period' 'Change Frequency'
%'Control/Server' 'Change/Control' 'change/server'
%plot(myData(:,6), myData(:,2), '*')
close
myColor = ['y' 'm' 'c' 'r' 'g' 'b' 'w' 'k' ];
plotNo = 1;
for j=50:50:max(myData(:,5))
    newRange = find(myData(:,5)==j);
    newData = myData(newRange,:);
    meanRM = zeros(1,max(newData(:,6)));
    strdRM = zeros(1,max(newData(:,6)));
    medianRM= zeros(1,max(newData(:,6)));
    for i=1:max(newData(:,6))
        range = find(newData(:,6)==i);
        meanRM(i) = mean(newData(range,show));
        medianRM(i) = median(newData(range,show));
        strdRM(i) = std(newData(range,show));
    end
    X=1:max(newData(:,6));
    rndclr=[rand, rand, rand];
    axis([1 20 0 .5])
    subplot(5,2,plotNo)
    plotNo = plotNo +1;
    errorbar(X, meanRM, strdRM,'-x','color','b');
    ylabel('Total Deadline Miss Ratio');
    xlabel(strcat('Control Period / Server Period Change Period = ', int2str(j)));
    %hold on
end
%errorbar(X, medianRM, strdRM,'-xb');

return

%% Change/Server - S1RM
meanRM = zeros(1,10);
strdRM = zeros(1,10);
for i=1:10
    range = find(myData(:,8)<100*i);
    meanRM(i) = mean(myData(range,1));
    strdRM(i) = std(myData(range,1));
    
end
X=1:10;
subplot
errorbar(X, meanRM, strdRM,'-xr');

%% Change/Server - show
meanRM = zeros(1,10);
strdRM = zeros(1,10);
for i=1:10
    range = find(myData(:,7)<100*i);
    meanRM(i) = mean(myData(range,show));
    strdRM(i) = std(myData(range,show));
    
end
X=1:10;
subplot
errorbar(X, meanRM, strdRM,'-xr');
