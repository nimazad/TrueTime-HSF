Header;
identification = 1;
Adaptive = 0;
Evaluate = 0;
%% changing period
changeP = 1;
changeAlpha = 0;
min_bandwidth = 58;
max_bandwidth = 58;
bandwidth_var = max_bandwidth-min_bandwidth;
operating_bandwidth = min_bandwidth + bandwidth_var/2;
min_period = 10;
max_period = 100;
period_var = (max_period-min_period);
operating_period = min_period + period_var/2;

sim('HSF.mdl', simTime)
Parameters;
input_period(:,1)  = alpha - operating_bandwidth;
input_period(:,2)  =  P - operating_period;
output_period(:,1) = x1;
output_period(:,2) = x2;
output_period(:,3) = x3;

HSFiddata_period = iddata(output_period, input_period, samplingTime);
%m1 = ID_ARX(HSFiddata_period);
%validateModel('P changing data', m1, input, output)
% input = input_period;
% output = output_period;
% w=50;
% plot_input_output
 %return
%% changing bandwidth
changeP = 0;
changeAlpha = 1;
min_bandwidth = 45;
max_bandwidth = 80;
bandwidth_var = max_bandwidth-min_bandwidth;
operating_bandwidth = min_bandwidth + bandwidth_var/2;
min_period = 20;
max_period = 20;
period_var = (max_period-min_period);
operating_period = min_period + period_var/2;

sim('HSF.mdl', simTime)
Parameters;
input_bandwidth(:,1)  = alpha - operating_bandwidth;
input_bandwidth(:,2)  =  P - operating_period;
output_bandwidth(:,1) = x1;
output_bandwidth(:,2) = x2;
output_bandwidth(:,3) = x3;

HSFiddata_bandwidth = iddata(output_bandwidth, input_bandwidth, samplingTime);
%m2 = ID_ARX(HSFiddata_bandwidth);
%validateModel('alpha changing data', m2, input, output)
merged_iddata = merge(HSFiddata_period, HSFiddata_bandwidth);
merged_input =[input_period; input_bandwidth];
merged_output = [output_period; output_bandwidth];
m = ID_ARX(merged_iddata, 3);
validateModel('merged data', m, merged_input, merged_output)
validateModel('period changing data', m, input_period, output_period)
validateModel('bandwidth changing data', m, input_bandwidth, output_bandwidth)

%% changing both
changeP = 1;
changeAlpha = 1;
min_bandwidth = 45;
max_bandwidth = 80;
bandwidth_var = max_bandwidth-min_bandwidth;
operating_bandwidth = min_bandwidth + bandwidth_var/2;
min_period = 10;
max_period = 100;
period_var = (max_period-min_period);
operating_period = min_period + period_var/2;

sim('HSF.mdl', simTime)
Parameters;
input(:,1)  = alpha - operating_bandwidth;
input(:,2)  =  P - operating_period;
output(:,1) = x1;
output(:,2) = x2;
output(:,3) = x3;
validateModel('both changing data', m, input, output)
save('ID_System', 'm')