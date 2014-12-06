function minHyperparams = holdOutValidation(modelTrain, modelTest, ...
    data, labels, split, hyperparams)

% modelTrain    : function as
%               : [params, ~] = modelTrain(trainData, trainLabels, hyperparams)
%               :
% modelTest     : function as 
%               : [error, ~] = modelTest(params, testData, testLabels)
%               : 
% params        : parameters found by training
% data          : data on which to train/validate
%               : as N x M = examples x features
% labels        : N x 1 labeled data
% split         : fraction of data to hold out for validation
% hyperparams   : all the combinations of hyperparams to test, by column

N = size(data,1);
trainSplit = floor(N*split);
K = size(hyperparams,2);
validateError = zeros(1,K);

% get values over each combination of hyperparameters
% for i=1:K
%     params = modelTrain(data(1:trainSplit,:), labels(1:trainSplit), hyperparams(:,i));
%     validateError(i) = modelTest(params, data(trainSplit+1:end,:), labels(trainSplit+1:end));
% end

% parallel
dataSet = data(1:trainSplit,:);
dataLabelSet = labels(1:trainSplit);
validateSet = data(trainSplit+1:end,:);
validateLabelSet = labels(trainSplit+1:end);
parfor i=1:K
    params = modelTrain(dataSet, dataLabelSet, hyperparams(:,i));
    [~, validateError(i)] = modelTest(params, validateSet, validateLabelSet);
end

% find *all* hyperparams that minimize validation error (hence the 2 steps)
minError = min(validateError);
minIndex = find(validateError == minError);

% now choose among those with your own criteria - your code below:
% my criteria: minimize eta:
[~, minOfMinsIndex] = min(hyperparams(1,minIndex));
minOfMins = minIndex(minOfMinsIndex);
minHyperparams = hyperparams(:,minOfMins);

end