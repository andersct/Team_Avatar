function visualize( pictureDataFixed, index )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[hist_mat, ~] = histogram(pictureDataFixed{index,1}, pictureDataFixed{index,3});
plotColorHistogram(hist_mat);

x = pictureDataFixed{index}(:,1);
y = pictureDataFixed{index}(:,2);

figure;
imshow(pictureDataFixed{index,3});
%[x, y] = ginput(2)

hold on;
%actually get color
[r, g, b] = colorTextToRgb('white');
h(1) = plot([x(1), x(1)], [y(1), y(2)], 'Color', [r, g, b], 'LineWidth', 2);
h(2) = plot([x(2), x(2)], [y(1), y(2)], 'Color', [r, g, b], 'LineWidth', 2);
h(3) = plot([x(1), x(2)], [y(1), y(1)], 'Color', [r, g, b], 'LineWidth', 2);
h(4) = plot([x(1), x(2)], [y(2), y(2)], 'Color', [r, g, b], 'LineWidth', 2);

end

