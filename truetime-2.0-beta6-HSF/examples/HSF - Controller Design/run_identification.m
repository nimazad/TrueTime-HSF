Header;
identification = 1;
Adaptive = 0;
Evaluate = 0;
newSimulation = 1;
order = 2;
if newSimulation
    sim('HSF.mdl', simTime)
    Parameters;
    input(:,1)  = alpha - bandwidth_operating;
    %input(:,1)  =  P - period_operating;
    input(:,2)  =  P - period_operating;
    output(:,1) = x1;
    output(:,2) = x2;
    input_upperBound(1) = (1-bandwidth_operating);
    input_upperBound(2) = (period_operating-10);
    input_lowerBound(1) = -input_upperBound(1);
    input_lowerBound(2) = -input_upperBound(2);
    output_upperBound(1) = 1;
    output_upperBound(2) = 1;
    output_lowerBound(1) = -1;
    output_lowerBound(2) = -1;
    
    save('simData', 'input', 'output');
else
    tmp = load('simData');
    input = tmp.input;
    output = tmp.output;
end

%plot_input_output;
%return;

HSFiddata = iddata(output, input, samplingTime);
%HSFiddata = detrend(HSFiddata)
A = [1 0;
     0 1];
B = [10 .1;
     10 .1];
C = [1 0;
     0 1];
D = zeros(2);
m = idss(A, B, C, D, 'Ts', samplingTime);
S = m.Structure;
S.c.Free = false;
m.Structure = S;
opt = ssestOptions('InitialState','estimate');
%opt.InitialState = 'Backcast';
sys_gray = ssest(HSFiddata, m, opt);
y_hat_gray = sys_gray.a * output' + sys_gray.b * input';
[rsq rmse] = rsquare(output, y_hat_gray');
disp(sprintf('Training data - gray model: R^2 = %f, RMSE = %f', rsq, rmse));

sys = ssest(HSFiddata, order, 'Ts', samplingTime, 'DisturbanceModel', 'none', 'Form', 'canonical');
y_hat = sys.a * output' + sys.b * input';
[rsq rmse] = rsquare(output, y_hat');
disp(sprintf('Training data -canonical: R^2 = %f, RMSE = %f', rsq, rmse));

na = ones(2,2); nb = ones(2,2); nk =zeros(2,2);
m_arx = arx(HSFiddata, [na nb nk]);
marx = idss(m_arx);
marx = ssform(marx, 'Form', 'free', 'Feedthrough', false, 'DisturbanceModel', 'none');
y_hat_arx = marx.a * output' + marx.b * input';
[rsq rmse] = rsquare(output, y_hat_arx');
disp(sprintf('Training data - gray model_arx: R^2 = %f, RMSE = %f', rsq, rmse));
save('ID_System', 'sys', 'marx')
return
for i=1:h
    a = 1;
    b = 1/i.*ones(1,i);
    output_filtered = filter(b,a,output);
    HSFiddata_filtered = iddata(output_filtered, input, samplingTime);
    sys_filtered = ssest(HSFiddata_filtered, order, 'Ts', samplingTime, 'DisturbanceModel', 'none', 'Form', 'canonical');
    y_hat_filtered = sys_filtered.a * output_filtered' + sys_filtered.b * input';
    [rsq_filtered(i) rmse_filtered(i)] = rsquare(output, y_hat_filtered');
    disp(sprintf('Training data - filter window size %d: R^2 = %f, RMSE = %f', i, rsq_filtered(i), rmse_filtered(i)));
end


windowSize = [1:h];
plot(windowSize, rsq, 'r')
hold on
plot(windowSize, rsq_filtered)


%%Test data
if Evaluate
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
end