Header;
identification = 1;
Adaptive = 0;
Evaluate = 0;
newSimulation = 1;
order = 2;
min_bandwidth = 45;
max_bandwidth = 80;
bandwidth_var = max_bandwidth-min_bandwidth;
operating_bandwidth = min_bandwidth + bandwidth_var/2;
min_period = 40;
max_period = 300;
period_var = (max_period-min_period);
operating_period = min_period + period_var/2;

%% changing period
changeP = 1;
changeAlpha = 0;

sim('HSF.mdl', simTime)
Parameters;
input_period(:,1)  = alpha - operating_bandwidth;
input_period(:,2)  =  P - operating_period;
output_period(:,1) = x1;
output_period(:,2) = x2;

HSFiddata_period = iddata(output_period, input_period, samplingTime);
%m1 = ID_ARX(HSFiddata_period);
%validateModel('P changing data', m1, input, output)
% input = input_period;
% output = output_period;
% w=50;
% plot_input_output
% return
%% changing bandwidth
changeP = 0;
changeAlpha = 1;

sim('HSF.mdl', simTime)
Parameters;
input_bandwidth(:,1)  = alpha - operating_bandwidth;
input_bandwidth(:,2)  =  P - operating_period;
output_bandwidth(:,1) = x1;
output_bandwidth(:,2) = x2;

HSFiddata_bandwidth = iddata(output_bandwidth, input_bandwidth, samplingTime);
%m2 = ID_ARX(HSFiddata_bandwidth);
%validateModel('alpha changing data', m2, input, output)
merged_iddata = merge(HSFiddata_period, HSFiddata_bandwidth);
merged_input =[input_period; input_bandwidth];
merged_output = [output_period; output_bandwidth];
m = ID_ARX(merged_iddata, 2);
m2 = ID_ssset(merged_iddata, 2, samplingTime);
validateModel('merged data', m, merged_input, merged_output)
validateModel('period changing data', m, input_period, output_period)
validateModel('bandwidth changing data', m, input_bandwidth, output_bandwidth)
%figure
%plot_model_data(m, merged_input,merged_output, simTime, [samplePoints samplePoints(end)+samplePoints])
%figure
%plot_model_data(m, input_bandwidth,output_bandwidth, simTime, samplePoints)
%% changing both
changeP = 1;
changeAlpha = 1;

sim('HSF.mdl', simTime)
Parameters;
input(:,1)  = alpha - operating_bandwidth;
input(:,2)  =  P - operating_period;
output(:,1) = x1;
output(:,2) = x2;
validateModel('both changing data', m, input, output)
HSFiddata_both = iddata(output, input, samplingTime);
m3 = ID_ARX(HSFiddata_both, 2);
%m4 = ID_ssset(HSFiddata_both, 2, samplingTime);
validateModel('ARX model from both changing data', m3, input, output);
%validateModel('ssset model from both changing data', m4, input, output);
save('ID_System', 'm', 'm2')
plot_feasible_range(merged_output)
plot_feasible_range(output)
plot_feasible_range(m.a * output' + m.b * input')