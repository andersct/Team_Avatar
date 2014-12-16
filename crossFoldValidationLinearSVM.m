addpath('libsvm-3.20/matlab');  % add LIBSVM to the path
addpath('libsvm-3.20/libsvm-weights-3.18/matlab');  % add LIBSVM to the path

load('datasvm_16.mat');
load('synthData_16.mat');
weights = [0, 0.001, 0.01, 0.1, 0.2, 0.5];
best_w = 0.001;
best_acc = 0;
best_C = 0;
C_vals = [0.0001, 0.001, 0.01, 0.1, 1, 10, 100];
acc_arr = zeros(7,1);

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


for C=1:length(C_vals)
    C_vals(C)
    avg_acc = 0;

    train_x_split = [train_x_block1; train_x_block2; train_x_block3; synth_train_x];
    train_t_split = [train_t_block1; train_t_block2; train_t_block3; synth_train_t];

    num_in_train = length(train_t_block1) + length(train_t_block2) + length(train_t_block3);
    weight_vec = [ones(num_in_train,1); best_w*ones(length(synth_train_t),1)];

    params = ['-t 0 -h 0 -c ', num2str(C_vals(C))];
    classifier = svmtrain(weight_vec, train_t_split, sparse(train_x_split), params);
    [predicted_label, accuracy, ~] = svmpredict(train_t_block4, sparse(train_x_block4), classifier);

    avg_acc = avg_acc + accuracy(1);

    train_x_split = [train_x_block4; train_x_block2; train_x_block3; synth_train_x];
    train_t_split = [train_t_block4; train_t_block2; train_t_block3; synth_train_t];
    classifier = svmtrain(weight_vec, train_t_split, sparse(train_x_split), params);
    [predicted_label, accuracy, ~] = svmpredict(train_t_block1, sparse(train_x_block1), classifier);

    avg_acc = avg_acc + accuracy(1);

    train_x_split = [train_x_block1; train_x_block4; train_x_block3; synth_train_x];
    train_t_split = [train_t_block1; train_t_block4; train_t_block3; synth_train_t];
    classifier = svmtrain(weight_vec, train_t_split, sparse(train_x_split), params);
    [predicted_label, accuracy, ~] = svmpredict(train_t_block2, sparse(train_x_block2), classifier);

    avg_acc = avg_acc + accuracy(1);

    train_x_split = [train_x_block1; train_x_block2; train_x_block4; synth_train_x];
    train_t_split = [train_t_block1; train_t_block2; train_t_block4; synth_train_t];
    classifier = svmtrain(weight_vec, train_t_split, sparse(train_x_split), params);
    [predicted_label, accuracy, ~] = svmpredict(train_t_block3, sparse(train_x_block3), classifier);

    avg_acc = (avg_acc + accuracy(1))/4
    acc_arr(C) = avg_acc;
    if (avg_acc > best_acc)
        best_acc = avg_acc
        best_C = C_vals(C)
    end
end

best_C
best_w
best_acc
train_x_split = [train_x_block1; train_x_block2; train_x_block3; train_x_block4; synth_train_x];
train_t_split = [train_t_block1; train_t_block2; train_t_block3; train_t_block4; synth_train_t];
num_in_train = length(train_t_block1) + length(train_t_block2) + length(train_t_block3) + length(train_t_block4);
weight_vec = [ones(num_in_train,1); best_w*ones(length(synth_train_t),1)];
params = ['-t 0 -h 0 -c ', best_C];
classifier = svmtrain(weight_vec, train_t_split, sparse(train_x_split), params);
[predicted_label, accuracy, ~] = svmpredict(train_t_block5, sparse(train_x_block5), classifier);
save(sprintf('linearSVMValidation.mat'),'acc_arr','best_acc','best_w','best_C','best_g','-v7.3');
