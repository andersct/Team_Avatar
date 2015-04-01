function cutoutToCascadePositiveFormat(dataDir, savePath)
%haarTrainingFormat converts labeled boxes to haarTraining positive format
%   pictureData
%   pictureData{i,1} = [x column, y column]
%   pictureData{i,2} = label vector
%   pictureData{i,3} = png image name

% haarTraining format:
% filename number_of_objects topLx topLy w h ..repeat for num
% TODO remember to remove the newline at the very end???

image_finder = [dataDir, '*.png'];
fprintf('Loading images with: %s\n', image_finder);
images = dir(image_finder);

fileID = fopen(savePath,'w');
num_images = length(images);
for i=1:num_images
    image_name = [dataDir, images(i).name];
    info = imfinfo(image_name);
    
    format_string = '%s %.0f %.0f %.0f %.0f %.0f\n';
    if i == num_images
        format_string = format_string(1:end-2);
    end
    
    % >name_of_file number_of_objects x y width height\n
    fprintf(fileID, format_string, image_name, 1, ...
        0, 0, info.Width, info.Height);
end
fclose(fileID);

end

