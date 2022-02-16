function mse = ClusteringCost(x, dataTrainStandardized,data,mu,sig)
global net
a=round(x(1));
XTrain = dataTrainStandardized(1:end-a);
YTrain = dataTrainStandardized(a+1:end);

numFeatures = 1;
numResponses = 1;
numHiddenUnits =round(x(4));
layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];
 
options = trainingOptions('adam', ...
    'MaxEpochs',round(x(5)), ...
    'GradientThreshold',1, ...
    'InitialLearnRate',x(2), ...%
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',250, ...
    'LearnRateDropFactor',x(3), ...%
    'Verbose',0, ...
    'Plots','none');
net = trainNetwork(XTrain,YTrain,layers,options);
[net,YPred] = predictAndUpdateState(net,YTrain(end-a+1));
YPred=(YTrain,YPred);
numTimeStepsTest =length(Ypred);
for i = numTimeStepsTest+1:numTimeStepsTest+11
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-a+1),'ExecutionEnvironment','cpu');
end
YPred = YPred(end-11:end);
YPred = sig.*YPred + mu;
YTest =data(end-11:end);
mse = sqrt(sum((YPred-YTest).^2)) ./ 12

end