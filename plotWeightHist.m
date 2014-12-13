function plotWeightHist(w, binsPerSide, visPlot, subVisPlot)
% 1x4096 : 16^3 bins

% undoes vectorization of histogram.m
% over i,j,k : hist_vec(ind) = hist_mat(i,j,k)

% using stats from all real training data
load 'train_x_un_stats.mat';

w = w.*sqrt(vars);
%w = w + means;
w = abs(w)*1000;

hist_mat = zeros(binsPerSide,binsPerSide,binsPerSide);
ind = 1;
for i=1:binsPerSide
    for j=1:binsPerSide
        for k=1:binsPerSide
            hist_mat(i,j,k) = w(ind);
            ind = ind+1;
        end
    end
end

plotColorHistogram(hist_mat, visPlot, subVisPlot);

end