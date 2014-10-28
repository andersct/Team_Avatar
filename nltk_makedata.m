load('data.mat');
perm = randperm(830);
x_test = train_x(perm(701:end), :);
t_test = train_t(perm(701:end));
x_train = train_x(perm(1:700), :);
t_train = train_t(perm(1:700));

save ('nltk_data.mat','x_train','t_train','x_test','t_test')

exit;