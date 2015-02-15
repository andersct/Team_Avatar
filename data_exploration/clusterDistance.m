function [ dist ] = clusterDistance(ex, et, clusterx, clustert)
%clusterDistance Calculates average distance of one example to a cluster
%   ex:         row of feature values
%   et:         label
%   clusterx:   rows of examples in cluster
%   clustert:   column of cluster labels
%   dist: average L2 norm

indices = find(clustert == et);
dist = sum((clusterx(indices,:)*ex').^2)/numel(indices);

end

