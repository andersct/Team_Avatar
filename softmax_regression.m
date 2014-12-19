addpath('softmax/');

load('datasvm_16.mat');
load('synthData_16.mat');

N = length(train_t);

train_x_block1 = [train_x(1:197,:); train_x(1856:end,:)];
train_x_block2 = [train_x(198:394,:); train_x(1637:1855,:)];
train_x_block3 = [train_x(395:591,:); train_x(1420:1638,:)];
train_x_block4 = [train_x(592:788,:); train_x(1201:1419,:)];
train_x_block5 = train_x(789:1200,:);

train_t_block1 = [train_t(1:197); train_t(1856:end)];
train_t_block2 = [train_t(198:394); train_t(1637:1855)];
train_t_block3 = [train_t(395:591); train_t(1420:1638)];
train_t_block4 = [train_t(592:788); train_t(1201:1419)];
train_t_block5 = train_t(789:1200);

%
% without synthetic data : to cross validate, switch out each block as test,
% run 5 times
% new_train_x = [train_x_block2; train_x_block3; train_x_block4; train_x_block5];
% new_train_t = [train_t_block2; train_t_block3; train_t_block4; train_t_block5];
% 
% new_test_x = train_x_block1;
% new_test_t = train_t_block1;
%}

%
%with synthetic data

new_train_x = [synth_train_x; ...
            train_x_block2; train_x_block3; train_x_block4; train_x_block5];
new_train_t = [synth_train_t; ...
            train_t_block2; train_t_block3; train_t_block4; train_t_block5];

new_test_x = train_x_block1;
new_test_t = train_t_block1;
%}


% synth train
% new_train_x = synth_train_x;
% new_train_t = synth_train_t;
% new_test_x = train_x;
% new_test_t = train_t;
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


[pred] = softmaxPredict(softmaxModel, new_train_x);
fprintf('Train Accuracy: %f%%\n', 100*mean(pred(:) == new_train_t(:)));

[pred] = softmaxPredict(softmaxModel, new_test_x);
fprintf('Test Accuracy: %f%%\n', 100*mean(pred(:) == new_test_t(:)));

