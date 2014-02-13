serverID = 1;
samplePoints = ControlTime(serverID,[2:end]);
beta = currentIdleTime(serverID,[2:end]);
mu = SchedulingError(serverID,[2:end]);
B = Budgets(serverID,[2:end]);
P = Periods(serverID,[2:end]);
Al = currentAssigned(serverID,[2:end]);
re = currentReleases(serverID,[2:end]);
alpha = B./P;
alpha = alpha.*100;
periodPerSampling = samplingTime./P;
% x1=beta;
% x2=mu;
% return

useful_budget = B-(beta+mu);

rho = -0.0013/2;
Omega = rho.*(P - 1) + .2988;
normalBeta = beta./samplingTime;
normalMu = mu./samplingTime;
x1 = normalBeta-normalMu;%f_alpha(normalBeta, normalMu);
x1 = 100.*x1;
x2 = DeadlineMisses(serverID,[2:end]) + currentInvocations(serverID,[2:end]);%f_p(normalBeta, normalMu, Omega);
% x2 = 100.*x2;
x3 = Omega+normalBeta;
x3 = x3.*100;