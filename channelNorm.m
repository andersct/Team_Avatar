function [ im ] = channelNorm( im )
%UNTITLED2 Summary of this function goes here
%   im : RGB double image
% bottom 25% corresponds to [.75, 1]*M

[M, N, ~] = size(im);

% Find sums for each RGB channel
channels = zeros(3,1);
for i=floor(.75*M):M
    for j=1:N
        channels = channels + squeeze(im(i,j,:));
    end
end
channels = channels/(N*ceil(.25*M));

% Standardize
im = bsxfun(@rdivide,255*im,reshape(channels,1,1,3));

end

