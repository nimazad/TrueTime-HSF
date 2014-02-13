function simulateModel(model, input, simTime)
    y(1,:) = [0 0 0 0];
    for i=2:simTime
        y(i,:) = model.a*y(i-1,:)'+ model.b*input;
    end
    figure
    totalPlots = 2;
    plotNO = 1;
    subplot(totalPlots,1,plotNO);
    plot([1:simTime], y(:,1))
    hold on
    xlabel('time');ylabel('x_1');
    
    plotNO = plotNO +1;
    subplot(totalPlots,1,plotNO);
    plot([1:simTime], y(:,2))
    hold on
    xlabel('time');ylabel('x_2');
end