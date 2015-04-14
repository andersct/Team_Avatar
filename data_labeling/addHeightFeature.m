function pictureData = addHeightFeature(pictureData)
    imHeight = 482;
    for i = 1:size(pictureData,1)
        points = pictureData{i,1};
        numBuoys = size(points,1)/2;
        pictureData{i,5} = zeros(numBuoys,1); % y1
        pictureData{i,6} = zeros(numBuoys,1); % y2 - y1
        for j = 1:numBuoys
            pictureData{i,5}(j) = imHeight - points(2*j,2);
            pictureData{i,6}(j) = points(2*j,2) - points(2*j-1,2);
        end
    end
end
