function [ hist_mat, hist_vec ] = histogram( pts, file, binSize, normFcn)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    hist_mat = zeros(binSize,binSize,binSize);
    hist_vec = zeros(1,binSize*binSize*binSize);
    x_min = min(pts(1,1), pts(2,1));
    x_max = max(pts(1,1), pts(2,1));
    y_min = min(pts(1,2), pts(2,2));
    y_max = max(pts(1,2), pts(2,2));
    A = imread(file);
    if nargin < 4
        A = normFcn(A);
    end
    for i=x_min:x_max
       for j=y_min:y_max
           RGB = A(int64(j),int64(i),:);
           RGB(:,:,1) = idivide(RGB(:,:,1), 256/binSize, 'floor')+1;
           RGB(:,:,2) = idivide(RGB(:,:,2), 256/binSize, 'floor')+1;
           RGB(:,:,3) = idivide(RGB(:,:,3), 256/binSize, 'floor')+1;
           hist_mat(RGB(:,:,1), RGB(:,:,2), RGB(:,:,3)) = hist_mat(RGB(:,:,1), RGB(:,:,2), RGB(:,:,3)) + 1;
       end
    end
    ind = 1;
    for i=1:binSize
        for j=1:binSize
           for k=1:binSize
               hist_vec(ind) = hist_mat(i,j,k);
               ind = ind + 1;
           end
        end
    end
end