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
color(1,:) = [63,0,0]; %red
color(2,:) = [0,63,0]; %green
color(3,:) = [63,63,63]; 
color(4,:) = [0,0,63];
color(5,:) = [63,63,0];
color(6,:) = [0,0,0];
cor = 0;
resrgb = zeros(130,3);
rescolor = zeros(130,1);
[s,k] = size(test_x_split);
for i=1:s
    [x,y] = max(test_x_split(i,:));
    a(1) = y/(64*64);
    a(2) = mod(y,(64*64)) / 64;
    a(3) = mod(y,64);
    for j = 1:6
        d(j) = (a - color(j,:)')'*(a-color(j,:)');
    end;
    [resind,rescolor(i)] = min(d);
    if (rescolor(i) == test_t_split(i)) 
        cor = cor+1;
    end;
    resrgb(i,:) = a';
end;
cor/130
