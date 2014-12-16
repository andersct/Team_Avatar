function [ im ] = pixelNorm( im )
%UNTITLED3 Summary of this function goes here
%   im : RGB double image
% bottom 25% corresponds to [.75, 1]*M

[M, N, ~] = size(im);

im = reshape( ...
    bsxfun(@rdivide,255*reshape(im,M*N,3),reshape(sum(im,3),M*N,1)), ...
    M, N, 3);

% for i=1:M
%     for j=1:N
%         im(i,j,:) = 255*im(i,j,:)/sum(im(i,j,:));
%     end
% end

end

