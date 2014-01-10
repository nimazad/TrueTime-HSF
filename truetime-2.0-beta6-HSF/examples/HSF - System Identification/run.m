close all
clc
clear 
ImportVideoData
numberOfServers = 1;
NumberOfTaskInServer = 3;
Adaptive = 0;
simTime = 20000;
samplingTime = 40
adaptTime = 30;
h=5
%controllerFrequency = 5;
sim('HSF.mdl', simTime)
i=1;
totalPlots = 5;
subplot(totalPlots,1,i);
j = j + 1;
plot(ControlTime(i,:), SchedulingError(i,:))
%plot(SchedulingError(i,:))
hold on
label = strcat('\mu_',int2str(i));
ylabel(label);


subplot(totalPlots,1,2);
j = j + 1;
plot(ControlTime(i,:), currentIdleTime(i,:))
%plot(SchedulingError(i,:))
hold on
label = strcat('\beta_',int2str(i));
ylabel(label);

subplot(totalPlots,1,3);
j = j + 1;
plot(DynamicTask(2,:), DynamicTask(i,:))
hold on
label = strcat(int2str(i),'C_{1,',int2str(i),'}');
ylabel(label);

subplot(totalPlots,1,4);
j = j + 1;
plot(ControlTime(i,:), Budgets(i,:))
hold on
label = strcat('B_',int2str(i),'C_{1,',int2str(i),'}');
ylabel(label);

subplot(totalPlots,1,5);
j = j + 1;
plot(ControlTime(i,:), Periods(i,:))
hold on
label = strcat('P_',int2str(i),'C_{1,',int2str(i),'}');
ylabel(label);
input(:,1) = Budgets(1,:)
input(:,2) = Periods(1,:)
output(:,1) = SchedulingError(1,:)
output(:,2) = currentIdleTime(1,:)

HSFiddata = iddata(output, input, samplingTime)
na = [1 1;1 1]
nb = [1 1;1 1]
nc = [1 1]'
nk = [0 0;0 0]
%myModel = arx(HSFiddata, [na nb nk])
%myModel = armax(HSFiddata, [na nb nc nk])
sys = ssest(HSFiddata, 2, 'Ts', samplingTime, 'DisturbanceModel', 'none', 'Form', 'canonical')
%figure
%compare(HSFiddata, myModel,sys)

a = 1;
b = 1/h.*ones(1,h);
output = filter(b,a,output);
HSFiddata_f = iddata(output, input, samplingTime)
sys_2 = ssest(HSFiddata_f, 2, 'Ts', samplingTime, 'DisturbanceModel', 'none', 'Form', 'canonical')
%figure
%compare(HSFiddata_f, sys)

y_hat = sys.a * output' + sys.b * input'
y_hat_2 = sys_2.a * output' + sys_2.b * input'
%HSFiddata_model = iddata(y_hat', input, samplingTime)
sprintf('Original model R^2 = %f', rsquare(output, y_hat'))
sprintf('Filtered model R^2 = %f', rsquare(output, y_hat_2'))
%compare(HSFiddata_model, sys)