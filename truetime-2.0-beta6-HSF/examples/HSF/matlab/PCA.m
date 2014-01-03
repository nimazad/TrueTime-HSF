clc
close all
%% Filter Data
%range = find(output(:,5)<400);%All QoS
%data = output(range,:);
%%
data = [output(:,2) output(:,5) output(:,7) output(:,8) output(:,9)];
stdr = std(data)
[r c] = size(data);
sr = data./repmat(stdr,r,1);
[coefs,scores,variances,t2] = princomp(sr);
coefs;
percent_explained = 100*variances/sum(variances);
figure
pareto(percent_explained)
xlabel('Principal Component')
ylabel('Variance Explained (%)')
figure
%biplot(coefs(:,1:2),'Scores',scores(:,1:2),'VarLabels',{'S1-Cost' 'All-Cost' 'Server Period' 'Controller Period' 'Change Frequency' 'Control/Server' 'Change/Control' 'change/server'});
biplot(coefs(:,1:2),'Scores',scores(:,1:2),'VarLabels',{ 'All-MissRatio' 'Period std' 'Task Utilization' 'Server Priority' 'Task Priority' });
%biplot(coefs(:,1:2),'Scores',scores(:,1:2),'VarLabels',{ 'S1 MissRatio' 'All-MissRatio' 'Control/Server' });
%figure
%biplot(coefs(:,1:3),'Scores',scores(:,1:3),'VarLabels',{'S1-QoS' 'All-QoS' 'Server Period' 'Controller Period' 'Change Frequency' 'Control/Server' 'Change/Control' 'change/server'});
return
%%
figure
plot(scores(:,1),scores(:,2),'+')
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
gname%(names)
%%
plot(output(:,5)./output(:,3), output(:,1).*100, '*');

%% PCA and plot
close all
clc
[pc,score,latent,tsquare] = princomp(sr);
figure
biplot(pc(:,1:2),'Scores',score(:,1:2),'VarLabels',{ 'Resource' 'CN' 'CL' 'O' 'Ag' 'Existing'  });
figure
biplot(pc(:,1:3),'Scores',score(:,1:3),'VarLabels',{'Resource' 'CN' 'CL' 'O' 'Ag' 'Existing' });