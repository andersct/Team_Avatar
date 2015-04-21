datasets = {'jocelyn0', 'jocelyn1', 'michael', 'michael1', 'tommy', 'tommy1'};
d_sph = [];
h_sph = [];
d_tall = [];
h_tall = [];
for i = 1:length(datasets)
    dset = ['boxes_', datasets{i}, '_labeled'];
    load(dset);
    pictureData = addHeightFeature(pictureData);
    [ds, hs, dt, ht] = getHeightFeature(pictureData);
    d_sph = [d_sph ds];
    h_sph = [h_sph hs];
    d_tall = [d_tall dt];
    h_tall = [h_tall ht];
end

% find max value in each bin (0-30, 31-60 ... 241-270)
dranges = [-1 30:30:270];

h_sph_max = -1 * ones(length(dranges)-1,1);
h_sph_min = 645 * ones(length(dranges)-1,1);
for i = 1:length(d_sph)
    for j = 1:length(dranges-1)
        if d_sph(i) > dranges(j) && d_sph(i) <= dranges(j+1)
            h_sph_max(j) = max(h_sph_max(j), h_sph(i));
            h_sph_min(j) = min(h_sph_min(j), h_sph(i));
            break;
        end
    end
end

h_tall_max = -1 * ones(length(dranges)-1,1);
h_tall_min = 645 * ones(length(dranges)-1,1);
for i = 1:length(d_tall)
    for j = 1:length(dranges)
        if d_tall(i) > dranges(j) && d_tall(i) <= dranges(j+1)
            h_tall_max(j) = max(h_tall_max(j), h_tall(i));
            h_tall_min(j) = min(h_tall_min(j), h_tall(i));
            break;
        end
    end
end

% Impute missing values, manually.
h_tall_max(3) = mean(h_tall_max([2 4]));
h_tall_min(3) = mean(h_tall_max([2 4]));

% From right to left (d=270 -> 0):
% the next max dist should be at least as large as the current max dist.
for i = length(h_sph_max)-1:-1:2
    h_sph_max(i-1) = max(h_sph_max(i), h_sph_max(i-1));
    h_sph_min(i-1) = max(h_sph_min(i), h_sph_min(i-1));
    h_tall_max(i-1) = max(h_tall_max(i), h_tall_max(i-1));
    h_tall_min(i-1) = max(h_tall_min(i), h_tall_min(i-1));
end

ff_tall_min = 120; % fudge factor
for i = 1:length(h_sph_max)
    h_sph_max(i) = h_sph_max(i) + 40 - 4*(i-1);
    h_sph_min(i) = h_sph_min(i);
    h_tall_max(i) = h_tall_max(i) + 40 - 2*(i-1);
    if i ~= length(h_sph_max)
        h_tall_min(i) = h_tall_min(i) - ff_tall_min;
        ff_tall_min = ff_tall_min/1.5;
    end
end 

% plot height feature
plot(d_sph,h_sph,'b*',d_tall,h_tall,'r*');
hold on;
legend('Sphere Buoy', 'Nun Buoy');
title('Upper and Lower bounds for the Heights of Bounding Boxes at Varying Distances to the Camera')
xlabel('Distance from Bottom of Bounding Box to Bottom of Image (px)');
ylabel('Height of Bounding Box (px)');

 % fit linear model
linear_model_sph = polyfit(d_sph, h_sph, 1);
linear_model_tall = polyfit(d_tall, h_tall, 1);
h_sph_fit = polyval(linear_model_sph, d_sph);
h_tall_fit = polyval(linear_model_tall, d_tall);
plot(d_sph,h_sph_fit,'b-',d_tall,h_tall_fit,'r-');


% plot upper and lower bounds
stairs(dranges(1:end-1), h_tall_max, 'r');
stairs(dranges(1:end-1), h_tall_min, 'r');
stairs(dranges(1:end-1), h_sph_max, 'b');
stairs(dranges(1:end-1), h_sph_min, 'b');


