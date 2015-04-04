function createNegatives(pictureData, dataDir, saveDir, initalLabel)
%CREATENEGATIVES Summary of this function goes here
%   Converts labeled cutouts in images to their own labeled negative images
%   Saves files in savePath file as:
%
%   [filename]
%   [filename]
%   [filename]
%       ...
%
%   with names neg-[label].png, starting from initial label (a count)
%
%   pictureData format:
%   pictureData{i,1} = [x column, y column]
%   pictureData{i,2} = label vector
%   pictureData{i,3} = png image name

% for each image
% if objects < 1 continue
% load image in
% save off each patch

numImages = length(pictureData);
label = initalLabel;
for i=1:numImages
    fprintf('checking image %g\n', i);
    numObjects = length(pictureData{i, 2});
    if numObjects < 1 || all(pictureData{i, 4} ~= 2);
        continue;
    end
    im = imread([dataDir, pictureData{i, 3}, 'png'], 'png');
    points = pictureData{i, 1};
    for j=1:numObjects
        if pictureData{i, 4}(j) ~= 2
            continue;
        end
        x_min = round(min(points(2*j-1,1), points(2*j,1)));
        x_max = round(max(points(2*j-1,1), points(2*j,1)));
        y_min = round(min(points(2*j-1,2), points(2*j,2)));
        y_max = round(max(points(2*j-1,2), points(2*j,2)));
        imwrite(im(y_min:y_max, x_min:x_max, :), ...
            [saveDir, 'sphere', sprintf('%g', label), '.png']);
        label = label+1;
    end
end


end




