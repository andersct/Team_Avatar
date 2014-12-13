%addpath('liblinear-1.94/matlab');  % add LIBLINEAR to the path
addpath('libsvm-3.20/matlab');  % add LIBSVM to the path
addpath('libsvm-3.20/libsvm-weights-3.18/matlab');  % add LIBSVM to the path

%addpath('libsvm-3.20_mac/matlab');  % add LIBSVM to the path
%addpath('libsvm-3.20_mac/libsvm-weights-3.18/matlab');  % add LIBSVM to the path


load('datasvm_16.mat');
load('synthData_16.mat');
N = length(train_t);
perm = randperm(N);
split = 1400;
num_in_test = 600;
%train_x = train_x(perm,:);
%train_t = train_t(perm);

% 3 for training, 1 for validation, 1 for testing. all real data
% each has some cloudy and some sunny data
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

train_x_split = [train_x_block1; train_x_block2; train_x_block3; train_x_block5];
red_train_t = [train_t_block1; train_t_block2; train_t_block3; train_t_block5];

[num_in_train,~] = size(train_x_split);
weight_vec = ones(length(train_x_split),1);
% comment this line to remove synthetic data
weight_vec = [ones(num_in_train,1); 0.2*ones(7114,1)];

test_x = train_x_block4;
red_test_t = train_t_block4;

% comment this line to remove synthetic data
train_x_split = [train_x_split; synth_train_x];
red_train_t = [red_train_t; synth_train_t];

isBinaryClassification = false; %edit here for portability

%% Binary

if isBinaryClassification
    
    color = 3;
    disp(['Testing color: ', colorToText(color)]);
    
    num_in_test = 0;
    num_in_train = 0;
    for i=1:split
        if (red_train_t(i) ~= color)
            red_train_t(i) = -1;
        else
            red_train_t(i) = 1;
            num_in_train = num_in_train + 1;
        end
    end
    
    for i=1:N-split
        if (red_test_t(i) ~= color)
            red_test_t(i) = -1;
        else
            red_test_t(i) = 1;
            num_in_test = num_in_test + 1;
        end
    end

end

%% Multiclass

if ~isBinaryClassification

    disp('Multiclass');
    
    
    %red_train_t = train_t(perm(1:split));
    %red_test_t = train_t(perm(split+1:end));
    
    %red_train_t = train_t(1:split);
    %red_test_t = train_t(split+1:end);
    % comment this line to remove synth data


end
%% GOGOGOGO
% 

classifier = svmtrain(weight_vec, red_train_t, sparse(train_x_split), '-t 3 -h 0 -g .00018');
% debug
svmpredict(red_train_t, sparse(train_x_split), classifier);
[predicted_label, accuracy, ~] = svmpredict(red_test_t, sparse(test_x), classifier);

%{
% output indices with errors - only makes sense for binary
disp('Misclassified examples: ');
indices = find(abs(predicted_label - red_test_t) ~= 0); % for actual indices, + split

if isBinaryClassification
    
    errorType = zeros(numel(indices),1);
    for i=1:numel(indices)
        if predicted_label(indices(i)) == 1
            errorType(i) = 1; % false positive
        else
            errorType(i) = 0; % false negative
        end
    end
    
    [indices+split, errorType];
    
else
    indices+split;

end




%}
