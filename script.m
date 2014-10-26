load('data.mat');
perm = randperm(830);
red_train_t = train_t(perm(1:700));
test_x = train_x(perm(701:end), :);
red_test_t = train_t(perm(701:end));
train_x_split = train_x(perm(1:700), :);


num_in_test = 0;
num_in_train = 0;
for i=1:700
   if (red_train_t(i) ~= 6)
       red_train_t(i) = -1; 
   else
       red_train_t(i) = 1;
       num_in_train = num_in_train + 1;
   end
end

for i=1:130
   if (red_test_t(i) ~= 6)
       red_test_t(i) = -1;
   else
       red_test_t(i) = 1;
       num_in_test = num_in_test + 1;
   end
end

red_train_t = train_t(perm(1:700));
red_test_t = train_t(perm(701:end));

classifier = train(red_train_t, sparse(train_x_split));
predict(red_test_t, sparse(test_x), classifier);