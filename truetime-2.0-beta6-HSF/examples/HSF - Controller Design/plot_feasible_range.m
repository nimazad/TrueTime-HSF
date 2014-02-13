function plot_feasible_range(output)
    figure
    totalPlots = 1;
    plotNO = 1;
    subplot(totalPlots,1,plotNO);
    plot(output(:,2), output(:,1),'.')
    hold on
    xlabel('x_2');ylabel('x_1');
end