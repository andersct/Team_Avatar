function haarTrainingFormat(pictureData, dataDir, savePath)
%haarTrainingFormat converts labeled boxes to haarTraining positive format
%   pictureData
%   pictureData{i,1} = [x column, y column]
%   pictureData{i,2} = label vector
%   pictureData{i,3} = png image name

% haarTraining format:
% filename number_of_objects topLx topLy w h ..repeat for num
% TODO remember to remove the newline at the very end???

fileID = fopen(savePath,'w');
numImages = length(pictureData);
for i=1:numImages
    numObjects = length(pictureData{i, 2});
    if numObjects < 1
        continue;
    end
    locations = zeros(4*numObjects,1);
    points = pictureData{i, 1};
    for j=1:numObjects
        x_min = min(points(2*j-1,1), points(2*j,1));
        x_max = max(points(2*j-1,1), points(2*j,1));
        y_min = min(points(2*j-1,2), points(2*j,2));
        y_max = max(points(2*j-1,2), points(2*j,2));
        locations(4*j-3:4*j) = [x_min; y_min; x_max-x_min; y_max-y_min];
    end
    file = [dataDir, pictureData{i,3}, 'png'];
    locFormat = repmat('%.0f ', 1, 4*numObjects);
    locFormat(end:end+1) = '\n';
    fprintf(fileID, ['%s %.0f ', locFormat], file, numObjects, locations);
end
fclose(fileID);


end

