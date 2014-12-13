function plotWeightHist(w, binsPerSide)
% 1x4096 : 16^3 bins

% undoes vectorization of histogram.m
% over i,j,k : hist_vec(ind) = hist_mat(i,j,k)

% using stats from all real training data
load 'train_x_un_stats.mat';

w = w.*vars;
w = w + means;
w = w*100;

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

end