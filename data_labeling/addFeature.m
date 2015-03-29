function addFeature(pictureData, dataDir, saveDir, index, fn, varargin)
%ADDFEATURE Summary of this function goes here
%   Adds another feature entry at to pictureData and saves it.
%   Optional args: start, stop indices of data in pictureData. 
%   Saves files in savePath file as:
%
%
%   pictureData format:
%   pictureData{i,1} = [x column, y column]
%   pictureData{i,2} = label vector
%   pictureData{i,3} = png image name
%   ...
%   pictureData{i, index} = added feature vector
%
%   Starts at i = start
%   fn() called for each labeled item in the picture to get feature vector

numvarargs = length(varargin);
if numvarargs > 2
    error('addFeature:TooManyInputs', ...
        'requires at most 2 optional inputs');
end

optargs = {1, -1};
optargs(1:numvarargs) = varargin;
[start, stop] = optargs{:};

numImages = length(pictureData);
if -1 == stop
    stop = numImages;
elseif stop > numImages
    stop = numImages;   
end

for i=start:stop
    numObjects = length(pictureData{i, 2});
    if numObjects < 1
        continue;
    end
    im = imread([dataDir, pictureData{i, 3}, 'png'], 'png');
    points = pictureData{i, 1};
    label = cell(numObjects, 1);
    j = 1;
    while j <= numObjects
        
        % visualize the labeled object
        imshow(im);
        hold on;
        [r, g, b] = colorTextToRgb(pictureData{i, 2}(j));
        x = points(2*j-1 : 2*j,1);
        y = points(2*j-1 : 2*j,2);
        h(1) = plot([x(1), x(1)], [y(1), y(2)], 'Color', [r, g, b], 'LineWidth', 2);
        h(2) = plot([x(2), x(2)], [y(1), y(2)], 'Color', [r, g, b], 'LineWidth', 2);
        h(3) = plot([x(1), x(2)], [y(1), y(1)], 'Color', [r, g, b], 'LineWidth', 2);
        h(4) = plot([x(1), x(2)], [y(2), y(2)], 'Color', [r, g, b], 'LineWidth', 2);
        hold off;
        
        % get label
        temp = fn();
        disp(temp);

		%{
        if confirmAction('Save ^? y/n: ') == 'y'
            label{j} = temp;
            j = j+1;
        else
            % nothing
        end
		%}

		label{j} = temp;
        j = j+1;
    end
    pictureData{i, index} = cell2mat(label);
end
save(sprintf('%sboxes.mat',saveDir),'pictureData');

end
