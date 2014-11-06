addpath('liblinear-1.94_mac/matlab');  % add LIBLINEAR to the path

load('data.mat');
N = numel(train_t);
split = 830;
perm = randperm(N);
red_train_t = train_t(perm(1:split));
test_x = train_x(perm(split+1:end), :);
red_test_t = train_t(perm(split+1:end));
train_x_split = train_x(perm(1:split), :);

% red_train_t = train_t(1:split);
% red_test_t = train_t(split+1:end);
% train_x_split = train_x(1:split, :);
% test_x = train_x(split+1:end, :);



%% Binary
% 
% color = 5;
% disp(['Testing color: ', colorToText(color)]);
% 
% num_in_test = 0;
% num_in_train = 0;
% for i=1:split
%    if (red_train_t(i) ~= color)
%        red_train_t(i) = -1; 
%    else
%        red_train_t(i) = 1;
%        num_in_train = num_in_train + 1;
%    end
% end
% 
% for i=1:N-split
%    if (red_test_t(i) ~= color)
%        red_test_t(i) = -1;
%    else
%        red_test_t(i) = 1;
%        num_in_test = num_in_test + 1;
%    end
% end

%% Multiclass

disp('Multiclass');


%red_train_t = train_t(perm(1:split));
%red_test_t = train_t(perm(split+1:end));

red_train_t = train_t(1:split);
red_test_t = train_t(split+1:end);

%% GOGOGOGO

classifier = train(red_train_t, sparse(train_x_split));
% debug
predict(red_train_t, sparse(train_x_split), classifier);
[predicted_label, accuracy, ~] = ...
    predict(red_test_t, sparse(test_x), classifier);


% output indices with errors
disp('Misclassified examples: ');
indices = find(abs(predicted_label - red_test_t) ~= 0) + split





