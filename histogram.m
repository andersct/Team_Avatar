function [ hist_mat, hist_vec ] = histogram( pts, file )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    hist_mat = zeros(16,16,16);
    hist_vec = zeros(1,4096);
    x_min = min(pts(1,1), pts(2,1));
    x_max = max(pts(1,1), pts(2,1));
    y_min = min(pts(1,2), pts(2,2));
    y_max = max(pts(1,2), pts(2,2));
    A = imread(file);
    for i=x_min:x_max
       for j=y_min:y_max
           RGB = A(int64(j),int64(i),:);
           RGB(:,:,1) = idivide(RGB(:,:,1), 16, 'floor')+1;
           RGB(:,:,2) = idivide(RGB(:,:,2), 16, 'floor')+1;
           RGB(:,:,3) = idivide(RGB(:,:,3), 16, 'floor')+1;
           hist_mat(RGB(:,:,1), RGB(:,:,2), RGB(:,:,3)) = hist_mat(RGB(:,:,1), RGB(:,:,2), RGB(:,:,3)) + 1;
       end
    end
    ind = 1;
    for i=1:16
        for j=1:16
           for k=1:16
               hist_vec(ind) = hist_mat(i,j,k);
               ind = ind + 1;
           end
        end
    end
end