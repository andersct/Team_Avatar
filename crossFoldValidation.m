addpath('libsvm-3.20/matlab');  % add LIBSVM to the path
addpath('libsvm-3.20/libsvm-weights-3.18/matlab');  % add LIBSVM to the path

load('datasvm_16.mat');
load('synthData_16.mat');
gamma = [0.00013, 0.00014, 0.00015, .00016, 0.00017, 0.00018, 0.00019];
weights = [0, 0.001, 0.01, 0.1, 0.2, 0.5];
best_g = 0.00013;
best_w = 0;
best_acc = 0;

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


for g=1:length(gamma)
    for w=1:length(weights)
        gamma(g)
        weights(w)
        avg_acc = 0;

        train_x_split = [train_x_block1; train_x_block2; train_x_block3; synth_train_x];
        train_t_split = [train_t_block1; train_t_block2; train_t_block3; synth_train_t];

        num_in_train = length(train_t_block1) + length(train_t_block2) + length(train_t_block3);
        weight_vec = [ones(num_in_train,1); weights(w)*ones(7114,1)];

        params = ['-t 3 -h 0 -g ', num2str(gamma(g))];
        classifier = svmtrain(weight_vec, train_t_split, sparse(train_x_split), params);
        [predicted_label, accuracy, ~] = svmpredict(train_t_block4, sparse(train_x_block4), classifier);

        avg_acc = avg_acc + accuracy(1);

        train_x_split = [train_x_block4; train_x_block2; train_x_block3; synth_train_x];
        train_t_split = [train_t_block4; train_t_block2; train_t_block3; synth_train_t];
        params = ['-t 3 -h 0 -g ', num2str(gamma(g))];
        classifier = svmtrain(weight_vec, train_t_split, sparse(train_x_split), params);
        [predicted_label, accuracy, ~] = svmpredict(train_t_block1, sparse(train_x_block1), classifier);

        avg_acc = avg_acc + accuracy(1);

        train_x_split = [train_x_block1; train_x_block4; train_x_block3; synth_train_x];
        train_t_split = [train_t_block1; train_t_block4; train_t_block3; synth_train_t];
        params = ['-t 3 -h 0 -g ', num2str(gamma(g))];
        classifier = svmtrain(weight_vec, train_t_split, sparse(train_x_split), params);
        [predicted_label, accuracy, ~] = svmpredict(train_t_block2, sparse(train_x_block2), classifier);

        avg_acc = avg_acc + accuracy(1);

        train_x_split = [train_x_block1; train_x_block2; train_x_block4; synth_train_x];
        train_t_split = [train_t_block1; train_t_block2; train_t_block4; synth_train_t];
        params = ['-t 3 -h 0 -g ', num2str(gamma(g))];
        classifier = svmtrain(weight_vec, train_t_split, sparse(train_x_split), params);
        [predicted_label, accuracy, ~] = svmpredict(train_t_block3, sparse(train_x_block3), classifier);

        avg_acc = (avg_acc + accuracy(1))/4

        if (avg_acc > best_acc)
            best_acc = avg_acc
            best_g = gamma(g)
            best_w = weights(w)
        end
    end
end

best_g
best_w
train_x_split = [train_x_block1; train_x_block2; train_x_block3; train_x_block4; synth_train_x];
train_t_split = [train_t_block1; train_t_block2; train_t_block3; train_t_block4; synth_train_t];
num_in_train = length(train_t_block1) + length(train_t_block2) + length(train_t_block3) + length(train_t_block4);
weight_vec = [ones(num_in_train,1); best_w*ones(7114,1)];
params = ['-t 3 -h 0 -g ', num2str(best_g)];
classifier = svmtrain(weight_vec, train_t_split, sparse(train_x_split), params);
[predicted_label, accuracy, ~] = svmpredict(train_t_block5, sparse(train_x_block5), classifier);
