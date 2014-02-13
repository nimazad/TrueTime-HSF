Header;
simTime = 4*simTime/10;
simTime = 50;
identification = 0;
Adaptive = 0;
changeAlpha = 0;
operating_period = 40;
changeP = 0;
operating_bandwidth = 20;
sim('HSF.mdl', simTime)
serverID = 1;
%%
 return
Parameters;
% disp(x2);
% disp(x3);
% disp(beta);
% disp(samplePoints);
% return

input(:,1) = alpha;
input(:,2) = P;
output(:,1) = x1;
output(:,2) = x2;
output(:,3) = x3;
w = 100.*currentLoad(serverID,[2:end])./samplingTime;
filtered = 0;
if filtered
        a = 1;
        b = 1/h.*ones(1,h);
        output = filter(b,a,output) ;    
end

input_upperBound(1) = 1;
input_upperBound(2) = (2*operating_period-5);
input_lowerBound(1) = 0;
input_lowerBound(2) = 5;
output_upperBound(1) = 0;
output_upperBound(2) = 0;
output_lowerBound(1) = 0;
output_lowerBound(2) = 0;
plot_input_output;
max(x2)
%(22500-sum(beta))/simTime
%plot_alpha_P;
%HSFiddata = iddata(output, input, samplingTime);
%na = ones(2,2); nb = ones(2,2); nk =zeros(2,2);
%m_arx = arx(HSFiddata, [na nb nk]);
%advice(HSFiddata)