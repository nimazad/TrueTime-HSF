Header;
simTime = simTime/20;
identification = 1;
Adaptive = 0;
changeAlpha = 1;
changeP = 1;

samplingTime = 40
sim('HSF.mdl', simTime)
Parameters;
input(:,1) = alpha;
input(:,2) = P;
output(:,1) = x1;
output(:,2) = x2;

PlotRows = 2;
PlotCols = 2;
serverID = 1;
xmin = 0;
xmax = simTime;
subplot(PlotRows,PlotCols,1);
plot(samplePoints, output(:,1))
hold on
plot(samplePoints, r1, 'r')
label = strcat('x_1');
ylabel(label);xlabel('Time (\Psi=40)');
set(gca,'xtick',[])
set(gca,'xticklabel',[])
axis([xmin xmax min(output(:,1)) max(output(:,1))])

%%
clear input output 
samplingTime = 100
sim('HSF.mdl', simTime)
Parameters;
input(:,1) = alpha;
input(:,2) = P;
output(:,1) = x1;
output(:,2) = x2;
subplot(PlotRows,PlotCols,2);
plot(samplePoints, output(:,1))
hold on
plot(samplePoints, r1, 'r')
label = strcat('x_1');
ylabel(label); xlabel('Time (\Psi=100)');
set(gca,'xtick',[])
set(gca,'xticklabel',[])
axis([xmin xmax min(output(:,1)) max(output(:,1))])

%%
clear input output 
samplingTime = 200
sim('HSF.mdl', simTime)
Parameters;
input(:,1) = alpha;
input(:,2) = P;
output(:,1) = x1;
output(:,2) = x2;
subplot(PlotRows,PlotCols,3);
plot(samplePoints, output(:,1))
hold on
plot(samplePoints, r1, 'r')
label = strcat('x_1');
ylabel(label);xlabel('Time (\Psi=200)');
set(gca,'xtick',[])
set(gca,'xticklabel',[])
axis([xmin xmax min(output(:,1)) max(output(:,1))])

%%
clear input output 
samplingTime = 400
sim('HSF.mdl', simTime)
Parameters;
input(:,1) = alpha;
input(:,2) = P;
output(:,1) = x1;
output(:,2) = x2;
subplot(PlotRows,PlotCols,4);
plot(samplePoints, output(:,1))
hold on
plot(samplePoints, r1, 'r')
label = strcat('x_1');
ylabel(label);xlabel('Time (\Psi=400)');
set(gca,'xtick',[])
set(gca,'xticklabel',[])
axis([xmin xmax min(output(:,1)) max(output(:,1))])