function autoAddNegativeBuoyType(pictureData, saveDir)
%AUTOADDNEGATIVEBUOYTYPE Sets buoy type of negatives.
%   Detailed explanation goes here

negativeLabel = buoyTypeToLabel('negative');
index = 4;
numImages = length(pictureData);
for i=1:numImages
    numObjects = length(pictureData{i, 2});
    if numObjects < 1
        continue;
    end
    pictureData{i, index} = repmat(negativeLabel, [numObjects,1]);
end
save(sprintf('%sboxes.mat',saveDir),'pictureData');


end

