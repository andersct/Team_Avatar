function [ hist_mat ] = histogram( pts, file )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    hist_mat = zeros(64,64,64);
    x_min = min(pts(1,1), pts(2,1));
    x_max = max(pts(1,1), pts(2,1));
    y_min = min(pts(1,2), pts(2,2));
    y_max = max(pts(1,2), pts(2,2));
    A = imread(file);
    for i=x_min:x_max
       for j=y_min:y_max
           RGB = A(int64(j),int64(i),:);
           hist_mat(floor(RGB(:,:,1)/4), floor(RGB(:,:,2)/4), floor(RGB(:,:,3)/4)) = hist_mat(floor(RGB(:,:,1)/4), floor(RGB(:,:,2)/4), floor(RGB(:,:,3)/4)) + 1;
       end
    end
end

