function validateModel(modelName, model, input, output)
    y_hat = model.a * output' + model.b * input';
    [rsq rmse] = rsquare(output, y_hat');
    disp(sprintf('%s: R^2 = %f, RMSE = %f', modelName, rsq, rmse));
end