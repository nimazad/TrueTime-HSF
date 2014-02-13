close all
clc
clear 
ImportVideoData
numberOfServers = 1;
NumberOfTaskInServer = 3;
simTime = 20000;
samplingTime = 40
adaptTime = 20;
identification = 1;
Adaptive = 0;
PeriodChange = 120;
BudgetChange = 135;
h=5;
%controllerFrequency = 5;
sim('HSF.mdl', simTime)
input(:,1) = Budgets(1,:);
input(:,2) = Periods(1,:);
output(:,1) = currentIdleTime(1,:);
output(:,2) = SchedulingError(1,:);

HSFiddata = iddata(output, input, samplingTime);
sys = ssest(HSFiddata, 2, 'Ts', samplingTime, 'DisturbanceModel', 'none', 'Form', 'canonical');

y_hat = sys.a * output' + sys.b * input';
[rsq rmse] = rsquare(output, y_hat');
disp(sprintf('Training data: R^2 = %f, RMSE = %f', rsq, rmse));


a = 1;
b = 1/h.*ones(1,h);
output_filtered = filter(b,a,output);
HSFiddata_filtered = iddata(output_filtered, input, samplingTime);
sys_filtered = ssest(HSFiddata_filtered, 2, 'Ts', samplingTime, 'DisturbanceModel', 'none', 'Form', 'canonical');
y_hat_filtered = sys_filtered.a * output' + sys_filtered.b * input';
[rsq rmse] = rsquare(output, y_hat_filtered');
disp(sprintf('Training data - filtered model: R^2 = %f, RMSE = %f', rsq, rmse));

%plot(ControlTime(1,:), output(:,1))
%hold on
%%plot(ControlTime(1,:), output_filtered(:,1),'g')
%plot(ControlTime(1,:), y_hat_filtered(1,:),'g')
%return
%%Test data
clear input
clear output
PeriodChange = 60;
BudgetChange = 65;
sim('HSF.mdl', simTime)
input(:,1) = Budgets(1,:);
input(:,2) = Periods(1,:);
output(:,1) = SchedulingError(1,:);
output(:,2) = currentIdleTime(1,:);

y_hat = sys.a * output' + sys.b * input';
[rsq rmse] = rsquare(output, y_hat');
disp(sprintf('Test data: R^2 = %f, RMSE = %f', rsq, rmse));

y_hat_filtered = sys_filtered.a * output' + sys_filtered.b * input';
[rsq rmse] = rsquare(output, y_hat_filtered');
disp(sprintf('Test data - filtered model: R^2 = %f, RMSE = %f', rsq, rmse));

%%Plole placement
I = [1 0; 0 1];
Z = [0 0; 0 0];
A=[sys_filtered.a Z;-I I];
B=[-sys_filtered.b; Z];
%p = [0.9764+0.0881j 0.9764-0.0881j 0.2442+0.0212j 0.2442-0.0212j];

k= samplingTime*2;
M=0.05;
dominant=1;
[p1 p2] = poleplacement(k, M, dominant);
dominant=0;
[p3 p4] = poleplacement(k, M, dominant);
p = [p1 p2 p3 p4]
K = place(A,B,p)

save('PIController', 'K')



return
error(:,1) = .5*.59 - output(:,1);
error(:,2) = .5*.59 - output(:,2);
errorI=zeros(size(output));
controlInput = K*[error errorI]';
totalPlots = 3;
subplot(totalPlots,1,1);
plot(ControlTime(1,:), controlInput(1,:))
ylabel('Budgets');
hold on
subplot(totalPlots,1,2);
plot(ControlTime(1,:), controlInput(1,:),'g')
ylabel('Periods');
hold on
subplot(totalPlots,1,3);
plot(ControlTime(1,:), controlInput(1,:)./controlInput(2,:),'g')
ylabel('Bandwidth');