function plot_model_data(model, input, output, simTime, samplePoints)
    y_hat = model.a * output' + model.b * input';
    totalPlots = 2;
    xmin = 0;
    xmax = simTime;
    %%
    subplot(totalPlots,1,1);
    plot(samplePoints, output(:,1))
    hold on
    plot(samplePoints, y_hat(1,:), 'r')
    label = strcat('x_1');
    ylabel(label);
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    axis([xmin xmax min(output(:,1)) max(output(:,1))])

    subplot(totalPlots,1,2);
    plot(samplePoints, output(:,2))
    hold on
    plot(samplePoints, y_hat(2,:), 'r')
    hold on
    label = strcat('x_2');
    ylabel(label);
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    axis([xmin xmax min(output(:,2)) max(output(:,2))])

end