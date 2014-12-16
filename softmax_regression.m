addpath('softmax/');

load('datasvm_16.mat');
load('synthData_16.mat');

N = length(train_t);
perm = randperm(N);
split = 1400;

%{
without synthetic data
train_x = train_x(perm,:);
train_t = train_t(perm);

new_train_x = train_x(1:split, :);
new_train_t = train_t(1:split);
new_test_x = train_x(split+1:end, :);
new_test_t = train_t(split+1:end);
%}

%{
%with synthetic data

new_train_x = [train_x(1:788,:); train_x(1201:1419,:)];
new_train_t = [train_t(1:788); train_t(1201:1419)];
new_test_x = train_x(789:1200, :);
new_test_t = train_t(789:1200);

new_train_x = [new_train_x; synth_train_x];
new_train_t = [new_train_t; synth_train_t];
%}

%{
%synth train
new_train_x = synth_train_x;
new_train_t = synth_train_t;
new_test_x = train_x;
new_test_t = train_t;
%}

lambda = 1e-4;
numcolors = 6;
inputsize = length(train_x(1,:));

addpath minFunc/
options.Method = 'lbfgs'; % Here, we use L-BFGS to optimize our cost
                          % function. Generally, for minFunc to work, you
                          % need a function pointer with two outputs: the
                          % function value and the gradient. In our problem,
                          % sparseAutoencoderCost.m satisfies this.
options.maxIter = 400;	  % Maximum number of iterations of L-BFGS to run 
options.display = 'on';

new_train_x = new_train_x';
new_train_t = new_train_t';
softmaxModel = softmaxTrain(inputsize, numcolors, lambda, new_train_x, new_train_t,options);
new_test_x = new_test_x';
[pred] = softmaxPredict(softmaxModel, new_test_x);

fprintf('Test Accuracy: %f%%\n', 100*mean(pred(:) == new_test_t(:)));
