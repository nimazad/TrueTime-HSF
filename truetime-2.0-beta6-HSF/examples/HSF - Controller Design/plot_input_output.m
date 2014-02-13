totalPlots = 5;
serverID = 1;
xmin = 0;
xmax = simTime;
%%
plotNO = 1;
subplot(totalPlots,1,plotNO);
plot(samplePoints, output(:,1))
hold on
plot(samplePoints, r1, 'r')
label = strcat('x_1');
ylabel(label);
set(gca,'xtick',[])
set(gca,'xticklabel',[])
axis([xmin xmax min(output(:,1)) max(output(:,1))])

plotNO = plotNO + 1;
subplot(totalPlots,1,plotNO);
plot(samplePoints, output(:,2))
hold on
plot(samplePoints, r2, 'r')
hold on
label = strcat('x_2');
ylabel(label);
set(gca,'xtick',[])
set(gca,'xticklabel',[])
axis([xmin xmax min(r2,min(output(:,2))) max(r2,max(output(:,2)))])

plotNO = plotNO + 1;
subplot(totalPlots,1,plotNO);
plot(samplePoints, output(:,3))
hold on
plot(samplePoints, r3, 'r')
hold on
label = strcat('x_3');
ylabel(label);
set(gca,'xtick',[])
set(gca,'xticklabel',[])
axis([xmin xmax min(r3,min(output(:,3))) max(r3,max(output(:,3)))])

plotNO = plotNO + 1;
subplot(totalPlots,1,plotNO);
plot(samplePoints, input(:,1))
hold on
plot(samplePoints, w, 'r')
hold on
label = strcat('\alpha');
ylabel(label);
ymin = floor(min(min(input(:,1)),min(w)));
ymax =ceil(max(max(input(:,1)), max(w)));
axis([xmin xmax ymin ymax ])
set(gca,'xtick',[])
set(gca,'xticklabel',[])
%plot(samplePoints, input_upperBound(1), 'r')
%plot(samplePoints, input_lowerBound(1), 'r')
hold on

plotNO = plotNO + 1;
subplot(totalPlots,1,plotNO);
plot(samplePoints, input(:,2))
hold on
%plot(samplePoints, x2.*10, '-.r')
%hold on
label = strcat('T');
ylabel(label);
axis([xmin xmax min(input(:,2)) max(input(:,2))+1])
% plot(samplePoints, input_upperBound(2), 'r')
% plot(samplePoints, input_lowerBound(2), 'r')

set(gca,'xtick',[])
set(gca,'xticklabel',[])
hold on



return
subplot(totalPlots,1,5);
plot(DynamicTask(2,[2:end]), DynamicTask(serverID,[2:end]))
hold on
plot(DynamicTask2(2,[2:end]), DynamicTask2(serverID,[2:end]),'g')
hold on
label = strcat('C');
ylabel(label);
axis([xmin xmax min(DynamicTask2(serverID,[2:end])) max(DynamicTask2(serverID,[2:end]))])
set(gcf,'units','normalized','outerposition',[0 0 1 1])
return
figure
totalPlots = 2;
subplot(totalPlots,1,1);
plot(alpha, mu, 'r');
hold on
plot(alpha, beta, 'x');
xlabel('\alpha');ylabel('\mu - \beta'); 

subplot(totalPlots,1,2);
plot(P, mu, 'r');
hold on
plot(P, beta, 'x');
xlabel('x_1');ylabel('x_2'); 

return
%%
figure
totalPlots = 2;
subplot(totalPlots,1,1);
plot(P, alpha, '.');
xlabel('P');ylabel('\alpha'); 

subplot(totalPlots,1,2);
plot(x1, x2, 'x');
xlabel('x_1');ylabel('x_2'); 
