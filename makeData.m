load('boxes.mat');
N = length(pictureDataFixed);
M = 262144;
train_x = zeros(N, M);
train_t = zeros(N, 1);

total = zeros(1,M);
for i=1:length(pictureDataFixed)-1
    [hist_mat, hist_vec] = histogram(pictureDataFixed{i,1}, pictureDataFixed{i,3});
    total = total + hist_vec;
    
    
    
    train_x(i,:) = hist_vec/sum(hist_vec);
    train_t(i) = pictureDataFixed{i,2};
end

train_x = bsxfun(@minus, train_x, mean(train_x));
var = sum(train_x.^2)/(N-1);
train_x = bsxfun(@rdivide, train_x, var.^0.5);
train_x(isnan(train_x)) = 0;

% save data with compression flag
save(sprintf('data.mat'),'train_x','train_t','-v7.3');