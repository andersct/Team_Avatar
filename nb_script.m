load('datanb.mat');
N = length(train_t);
split = 1700;
perm = randperm(N);
train_x = train_x(perm,:);
train_t = train_t(perm);
test_x = train_x(split+1:end, :);
test_t = train_t(split+1:end);
train_x_split = train_x(1:split, :);
train_t_split = train_t(1:split);

nb = fitNaiveBayes(train_x_split, train_t_split, 'Distribution', 'mn');
pred = predict(nb,test_x);

error = 0;
test_examples = length(test_t);
for i=1:test_examples
   if (pred(i) ~= test_t(i))
       error = error + 1;
   end
end
error = error / test_examples
