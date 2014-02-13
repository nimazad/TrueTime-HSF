clc
close all
alpha_floor = floor(alpha);
for i=min(alpha_floor):max(alpha_floor)
   indx = find(alpha_floor==i); 
   mu_mean(i) = mean(mu(indx));
   beta_mean(i) = mean(beta(indx));
   x1_mean(i) = mean(x1(indx));
   x2_mean(i) = mean(x2(indx));
end

%totalPlots = 2;
%subplot(totalPlots,1,1);

plot_indx = min(alpha_floor):max(alpha_floor);
plot(plot_indx, mu_mean(plot_indx),'r')
hold on
plot(plot_indx, beta_mean(plot_indx))
xlabel('\alpha')


figure
plot(plot_indx, x1_mean(plot_indx),'.-k')
hold on
plot(plot_indx, x2_mean(plot_indx),'r')
xlabel('\alpha')
ylabel('x_1 and x_2')

return
%%
%subplot(totalPlots,1,2);
figure
for i=min(P):max(P)
   indx = find(P==i); 
   mu_mean(i) = floor(mean(mu(indx)));
   beta_mean(i) = floor(mean(beta(indx)));
   x1_mean(i) = mean(x1(indx));
   x2_mean(i) = mean(x2(indx));
end
plot_indx = min(P):max(P);
plot(plot_indx, mu_mean(plot_indx),'r')
hold on
plot(plot_indx, beta_mean(plot_indx),'.-k')
xlabel('P')

figure
plot(plot_indx, x1_mean(plot_indx),'.-k')
hold on
plot(plot_indx, x2_mean(plot_indx),'r')
xlabel('P')
ylabel('x_1 and x_2')
