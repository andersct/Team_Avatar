function [d_sph, h_sph, d_tall, h_tall] = getHeightFeature(pictureData)
    d_tall = [];
    h_tall = [];
    d_sph = [];
    h_sph = [];
    for i = 1:size(pictureData,1)
        d = pictureData{i,5};
        h = pictureData{i,6};
        numBuoys = size(d,1)/2;
        for j = 1:numBuoys
            if pictureData{i,4}(j) == 1
                d_tall = [d_tall d(j)];
                h_tall = [h_tall h(j)];
            end
            if pictureData{i,4}(j) == 2
                d_sph = [d_sph d(j)];
                h_sph = [h_sph h(j)];
            end
        end
    end
end