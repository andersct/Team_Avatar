function [labelDists, labels, classSize] = ...
    clusterSeparation(c1x, c1t, c2x, c2t)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[N, M] = size(c1x);
dist = zeros(N,1);

parfor i=1:N
    dist(i) = clusterDistance(c1x(i,:),c1t(i),c2x,c2t);
end

labels = unique(c1t);
labelDists = labels;
classSize = labels;
parfor i=1:numel(labels)
    indices = find(c1t == labels(i));
    classSize(i) = numel(indices);
    labelDists(i) = sum(dist(indices))/classSize(i);
end

end

