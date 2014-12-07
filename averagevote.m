clear;
load('data.mat');
perm = randperm(2074);
split = 1500;
train_t_split = train_t(perm(1:split));
train_x_split = train_x(perm(1:split),:);
test_x_split = train_x(perm(split:end),:);
test_t_split = train_t(perm(split:end));
a = zeros(3,1);
color = zeros(6,3);
color(1,:) = [64,1,1];
color(2,:) = [1,64,1];
color(3,:) = [64,64,64];
color(4,:) = [1,1,64];
color(5,:) = [64,64,1];
color(6,:) = [1,1,1];
cor = 0;
[s,k] = size(test_t_split);
rescolor = zeros(s,1);
for i=1:s
    [x,y] = max(test_x_split(i,:));
    ind = 1;
    a = zeros(3,1);
    count = 0;
    for rc = 1:64
        for gc = 1:64
            for bc = 1:64
                a(1) = a(1) + test_x_split(i,ind)*rc;
                a(2) = a(2) + test_x_split(i,ind)*gc;
                a(3) = a(3) + test_x_split(i,ind)*bc;
                count = count + test_x_split(i,ind);
                ind = ind + 1;
            end;
        end;
    end;
    a = a/count;
    for j = 1:6
        d(j) = (a - color(j,:)')'*(a-color(j,:)');
    end;
    [resind,rescolor(i)] = min(d);
    if (rescolor(i) == test_t_split(i)) 
        cor = cor+1;
    end;
end;
cor/s
