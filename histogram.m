function [ hist ] = histogram( pts, file )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    hist = zeros(255,255,255);
    x_min = min(pts(1,1), pts(2,1));
    x_max = max(pts(1,1), pts(2,1));
    y_min = min(pts(1,2), pts(2,2));
    y_max = max(pts(1,2), pts(2,2));
    A = imread(file);
    for i=x_min:x_max
       for j=y_min:y_max
           RGB = A(int64(j),int64(i),:);
           hist(RGB(1), RGB(2), RGB(3)) = hist(RGB(1), RGB(2), RGB(3)) + 1;
       end
    end
end

