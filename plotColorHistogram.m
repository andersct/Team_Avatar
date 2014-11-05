function plotColorHistogram(hist)
%UNTITLED Summary of this function goes here
%   hist is an N x N x N matrix
%   N =< 256

N = size(hist,1);
multiple = 256/N;
scale = 100;

linearIndices = find(hist ~= 0);
[x, y, z] = ind2sub([N, N, N], linearIndices);
x = multiple*x;
y = multiple*y;
z = multiple*z;
figure;
scatter3(x,y,z,scale*hist(linearIndices),[x, y, z]/256, 'filled');
xlabel('R');
ylabel('G');
zlabel('B');
xlim([0, 256]);
ylim([0, 256]);
zlim([0, 256]);

end

