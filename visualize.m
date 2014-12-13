function visualize( pictureDataFixed, index , binSize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[hist_mat, ~] = histogram(pictureDataFixed{index,1}, ...
    pictureDataFixed{index,3} , binSize);
visPlot = figure;
subVisPlot = subplot(1,2,1);
plotColorHistogram(hist_mat, visPlot, subVisPlot);

x = pictureDataFixed{index}(:,1);
y = pictureDataFixed{index}(:,2);

subplot(1,2,2); %figure;
imshow(pictureDataFixed{index,3});
title(sprintf('Image %.0f, %s', index, pictureDataFixed{index,3}));
%[x, y] = ginput(2)

hold on;
%actually get color
[r, g, b] = colorTextToRgb(colorToText(pictureDataFixed{index,2}));
h(1) = plot([x(1), x(1)], [y(1), y(2)], 'Color', [r, g, b], 'LineWidth', 2);
h(2) = plot([x(2), x(2)], [y(1), y(2)], 'Color', [r, g, b], 'LineWidth', 2);
h(3) = plot([x(1), x(2)], [y(1), y(1)], 'Color', [r, g, b], 'LineWidth', 2);
h(4) = plot([x(1), x(2)], [y(2), y(2)], 'Color', [r, g, b], 'LineWidth', 2);
hold off;

end

