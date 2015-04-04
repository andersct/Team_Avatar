function cascadePositiveFormatFilter(pictureData, dataDir, savePath, idx, type)
%cascadePositiveFormatFilter converts labeled boxes to haarTraining positive format
%   pictureData
%   pictureData{i,1} = [x column, y column]
%   pictureData{i,2} = color label vector
%   pictureData{i,3} = png image name
%   pictureData{i,4} = buoy type vector

% dataDir : relative path from repo
% idx : index of feature to be filtered on
% type : value of the given feature

% skips rows for which none of the labels' types match the given type
% these types are single valued for the given idx feature
% adds a newline at the end

% cascade positive format:
% filename number_of_objects topLx topLy w h ..repeat for num

fileID = fopen(savePath,'w');
numImages = length(pictureData);
for i=1:numImages
    matches_indices = find(pictureData{i, idx} == type);
    numObjects = length(matches_indices);
    if numObjects < 1
        continue;
    end
    locations = zeros(4*numObjects,1);
    points = pictureData{i, 1};
    for k=1:numObjects
        j = matches_indices(k);
        x_min = min(points(2*j-1,1), points(2*j,1));
        x_max = max(points(2*j-1,1), points(2*j,1));
        y_min = min(points(2*j-1,2), points(2*j,2));
        y_max = max(points(2*j-1,2), points(2*j,2));
        locations(4*k-3:4*k) = [x_min; y_min; x_max-x_min; y_max-y_min];
    end
    % all stuffs in pics/
    file = [dataDir, pictureData{i,3}, 'png'];
    locFormat = repmat('%.0f ', 1, 4*numObjects);
    locFormat(end:end+1) = '\n';
    fprintf(fileID, ['%s %.0f ', locFormat], file, numObjects, locations);
end
fclose(fileID);


end

