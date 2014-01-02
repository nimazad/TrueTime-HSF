output(:,6) = output(:,4)./output(:,3);
output(:,7) = output(:,4)./output(:,5);
output(:,8) = output(:,5)./output(:,3);
%%
clc
close all
range = find(output(:,5)>0 & output(:,5)<.15 );%change freq
All = 2;
S1 = 1;
show = All;
[r c] = size(output);
%range = r/2:r;
%range = find(output(:,show)>0);%All MissRatio
myData = output;%(range,:);
%%
%'S1-MissRatio' 'All-MissRatio' 'Server Period' 'Controller Period' 'Change Frequency'
%'Control/Server' 'Change/Control' 'change/server'
%plot(myData(:,6), myData(:,2), '*')
meanMissRatio = zeros(max(myData(:,6)),1);
strdMissRatio = zeros(max(myData(:,6)),1);
medianMissRatio= zeros(max(myData(:,6)),1);
%%
for i=1:max(myData(:,6))
    range = find(myData(:,6)==i);
    meanMissRatio(1,i) = mean(myData(range,show));
    medianMissRatio(1,i) = median(myData(range,show));
    strdMissRatio(1,i) = std(myData(range,show));
    
end
X=1:max(myData(:,6));
axis([1 20 0 1])
errorbar(X, meanMissRatio(1,:), strdMissRatio(1,:),'-xr');
%barweb(meanMissRatio', strdMissRatio', 10, X)
xlabel('Control Period / Server Period');
ylabel('Total Deadline Miss Ratio');
%old on
%errorbar(X, medianMissRatio, strdMissRatio,'-xb');
return
%%
myData = output;%(range,:);
%%
%'S1-MissRatio' 'All-MissRatio' 'Server Period' 'Controller Period' 'Change Frequency'
%'Control/Server' 'Change/Control' 'change/server'
%plot(myData(:,6), myData(:,2), '*')
meanMissRatio = zeros(1,max(myData(:,6)));
strdMissRatio = zeros(1,max(myData(:,6)));
medianMissRatio= zeros(1,max(myData(:,6)));
%% Each sample seperatly
[r c] = size(output);
Rmin = 1;
sampleSize = 10;
Rmax = Rmin + sampleSize;
for j=8:12%(r/200)
    range = Rmin:Rmax;
    Rmin = Rmin + sampleSize;
    Rmax = Rmax + sampleSize;
    myData = output(range,:);
for i=1:max(myData(:,6))
    range = find(myData(:,6)==i);
    meanMissRatio(i) = mean(myData(range,show));
    medianMissRatio(i) = median(myData(range,show));
    strdMissRatio(i) = std(myData(range,show));
    
end
X=1:max(myData(:,6))
meanMissRatio
axis([1 10 0 .15])
errorbar(X, meanMissRatio, strdMissRatio,'-xr');
xlabel('Control Period / Server Period');
ylabel('Total Deadline Miss Ratio');
hold on
end
%errorbar(X, medianMissRatio, strdMissRatio,'-xb');
%%
%'S1-MissRatio' 'All-MissRatio' 'Server Period' 'Controller Period' 'Change Frequency'
%'Control/Server' 'Change/Control' 'change/server'
%plot(myData(:,6), myData(:,2), '*')
meanMissRatio = zeros(1,max(myData(:,6)));
strdMissRatio = zeros(1,max(myData(:,6)));
medianMissRatio= zeros(1,max(myData(:,6)));
for i=1:2*max(myData(:,6))
    range = find(myData(:,6)==i/2);
    meanMissRatio(i) = mean(myData(range,show));
    medianMissRatio(i) = median(myData(range,show));
    strdMissRatio(i) = std(myData(range,show));
    
end
X=1:.5:max(myData(:,6))+.5;

errorbar(X, meanMissRatio, strdMissRatio,'-xr');
xlabel('Control Period / Server Period');
ylabel('Total Deadline Miss Ratio');
hold on
%errorbar(X, medianMissRatio, strdMissRatio,'-xb');
return
%%
%'S1-MissRatio' 'All-MissRatio' 'Server Period' 'Controller Period' 'Change Frequency'
%'Control/Server' 'Change/Control' 'change/server'
%plot(myData(:,6), myData(:,2), '*')
close
myColor = ['y' 'm' 'c' 'r' 'g' 'b' 'w' 'k' ];
plotNo = 1;
for j=50:50:max(myData(:,5))
    newRange = find(myData(:,5)==j);
    newData = myData(newRange,:);
    meanMissRatio = zeros(1,max(newData(:,6)));
    strdMissRatio = zeros(1,max(newData(:,6)));
    medianMissRatio= zeros(1,max(newData(:,6)));
    for i=1:max(newData(:,6))
        range = find(newData(:,6)==i);
        meanMissRatio(i) = mean(newData(range,show));
        medianMissRatio(i) = median(newData(range,show));
        strdMissRatio(i) = std(newData(range,show));    
    end
    X=1:max(newData(:,6));
    rndclr=[rand, rand, rand];
    axis([1 20 0 .5])
    subplot(5,2,plotNo)
    plotNo = plotNo +1;
    errorbar(X, meanMissRatio, strdMissRatio,'-x','color','b');
    ylabel('Total Deadline Miss Ratio');
    xlabel(strcat('Control Period / Server Period Change Period = ', int2str(j)));
    %hold on
end
%errorbar(X, medianMissRatio, strdMissRatio,'-xb');

return

%% Change/Server - S1MissRatio
meanMissRatio = zeros(1,10);
strdMissRatio = zeros(1,10);
for i=1:10
    range = find(myData(:,8)<100*i);
    meanMissRatio(i) = mean(myData(range,1));
    strdMissRatio(i) = std(myData(range,1));
    
end
X=1:10;
subplot
errorbar(X, meanMissRatio, strdMissRatio,'-xr');

%% Change/Server - show
meanMissRatio = zeros(1,10);
strdMissRatio = zeros(1,10);
for i=1:10
    range = find(myData(:,7)<100*i);
    meanMissRatio(i) = mean(myData(range,show));
    strdMissRatio(i) = std(myData(range,show));
    
end
X=1:10;
subplot
errorbar(X, meanMissRatio, strdMissRatio,'-xr');
