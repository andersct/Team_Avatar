load('boxes.mat');
train_x = zeros(length(pictureDataFixed), 262144);
train_t = zeros(length(pictureDataFixed), 1);

for i=1:length(pictureDataFixed)-1
    [hist_mat, hist_vec] = histogram(pictureDataFixed{i,1}, pictureDataFixed{i,3});
    train_x(i,:) = hist_vec;
    train_t(i) = pictureDataFixed{i,2};
end

% save data with compression flag
save(sprintf('data.mat'),'train_x','train_t','-v7.3');