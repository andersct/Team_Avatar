load('data.mat');
perm = randperm(830);
test_x = train_x(perm(701:end), :);
test_t = train_t(perm(701:end));
train_x_split = train_x(perm(1:700), :);
train_t_split = train_t(perm(1:700));

% for binary classification
%for i=1:130
%    if (test_t(i) ~= 6)
%        test_t(i) = 0;
%    else
%        test_t(i) = 1;
%    end
%end
%for i=1:700
%    if (train_t_split(i) ~= 6)
%        train_t_split(i) = 0;
%    else
%        train_t_split(i) = 1;
%    end
%end
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
