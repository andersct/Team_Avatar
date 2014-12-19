load('boxes.mat');
load('synthBoxes.mat');
N = length(pictureDataFixed);
N_synth = length(synthPicsData);
binSize = 16;
M = binSize*binSize*binSize;
train_x = zeros(N, M);
train_t = zeros(N, 1);
synth_train_x = zeros(length(synthPicsData), M);
synth_train_t = zeros(length(synthPicsData), 1);

for i=1:length(pictureDataFixed)
    [hist_mat, hist_vec] = histogram(pictureDataFixed{i,1}, pictureDataFixed{i,3}, binSize, @channelNorm);
    
    % scaling to unit length
    train_x(i,:) = hist_vec;
    train_t(i) = pictureDataFixed{i,2};
end
%{
% standardization
train_x = bsxfun(@minus, train_x, mean(train_x));
var = sum(train_x.^2)/(N-1);
train_x = bsxfun(@rdivide, train_x, var.^0.5);
train_x(isnan(train_x)) = 0;
%}

for i=1:length(synthPicsData)
    [hist_mat, hist_vec] = histogram(synthPicsData{i,1}, synthPicsData{i,3}, binSize, @channelNorm);
    
    % scaling to unit length
    synth_train_x(i,:) = hist_vec;
    synth_train_t(i) = synthPicsData{i,2};
end
%{
synth_train_x = bsxfun(@minus, synth_train_x, mean(synth_train_x));
var = sum(synth_train_x.^2)/(N_synth-1);
synth_train_x = bsxfun(@rdivide, synth_train_x, var.^0.5);
synth_train_x(isnan(synth_train_x)) = 0;
%}

save(sprintf('dataChannelnb.mat'),'train_x','train_t','-v7.3');
save(sprintf('synthPixelData_nb.mat'),'synth_train_x','synth_train_t','-v7.3');