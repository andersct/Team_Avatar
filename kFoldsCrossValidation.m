function minHyperparams = kFoldsCrossValidation(modelTrain, modelTest, ...
    data, labels, kfolds, hyperparams)

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

[N, M] = size(data);
K = size(hyperparams,2);
validateError = zeros(1,K);

% set up the K validation sets
foldSize = floor(N/kfolds);
foldSet = zeros(N-foldSize, M, kfolds);
foldLabel = zeros(N-foldSize, kfolds);
validateSet = zeros(foldSize, M, kfolds);
validateLabel = zeros(foldSize, kfolds);

% the first
foldSet(:,:,1) = data(foldSize+1:end,:);
foldLabel(:,1) = labels(foldSize+1:end);
validateSet(:,:,1) = data(1:foldSize,:);
validateLabel(:,1) = labels(1:foldSize);

% the end
foldSet(:,:,kfolds) = data(1:foldSize*(kfolds-1),:);
foldLabel(:,kfolds) = labels(1:end-foldSize);
validateSet(:,:,kfolds) = data(N-foldSize+1:end,:);
validateLabel(:,kfolds) = labels(N-foldSize+1:end);

% the middle
for i=2:kfolds-1    
    foldSet(:,:,i) = [data(1:foldSize*(i-1),:); data(foldSize*i+1:end,:)];
    foldLabel(:,i) = [labels(1:foldSize*(i-1)); labels(foldSize*i+1:end)];
    validateLabel(:,i) = labels(foldSize*(i-1)+1 : foldSize*i);
    validateSet(:,:,i) = data(foldSize*(i-1)+1 : foldSize*i,:);
end

% get values over each combination of hyperparameters
% for i=1:K
%     params = modelTrain(data(1:trainSplit,:), labels(1:trainSplit), hyperparams(:,i));
%     validateError(i) = modelTest(params, data(trainSplit+1:end,:), labels(trainSplit+1:end));
% end

% parallel
parfor i=1:K
    sum = 0;
    for j=1:kfolds
        params = modelTrain(foldSet(:,:,j), foldLabel(:,j), hyperparams(:,j));
        [~, validateError(i)] = modelTest(params, validateSet(:,:,j), validateLabel(:,j));
        sum = sum + validateError(i);
    end
    validateError(i) = sum/kfolds;
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
