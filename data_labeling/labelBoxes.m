% pictureData{i,:} = [ x y ] , colors

figure;

dataDir = '/Users/CyrusAnderson/Documents/Team_Avatar/new_pics/tommy_pics/third300/';%'/afs/umich.edu/user/a/n/andersct/Public/difficult_buoy/'; %pwd + /
saveDir = '/Users/CyrusAnderson/Documents/Team_Avatar/Negatives/HaarTraining/';
pics = dir(sprintf('%s*.png',dataDir));
numPics = length(pics);
%numPics = 450; %set this to break into small segments
pictureData = cell(numPics, 2);


%set i's start value if breaking into small segments
for i=1:numPics
    i
    name =  pics(i).name;
    imshow([dataDir, name]);
    
    numBoxes = str2num(input('How many boxes would you like to mark this evening? ','s'));
    pictureData{i,1} = zeros(numBoxes, 2);
    pictureData{i,2} = zeros(numBoxes,1);
    
    hold on;
    
    numBoxCounter = 1;
    while numBoxCounter <= numBoxes
        
        % get two coordinates
        [x, y] = ginput(2);
        
        [color, text] = getColor();
        [r, g, b] = colorTextToRgb(text);
        h(1) = plot([x(1), x(1)], [y(1), y(2)], 'Color', [r, g, b], 'LineWidth', 2);
        h(2) = plot([x(2), x(2)], [y(1), y(2)], 'Color', [r, g, b], 'LineWidth', 2);
        h(3) = plot([x(1), x(2)], [y(1), y(1)], 'Color', [r, g, b], 'LineWidth', 2);
        h(4) = plot([x(1), x(2)], [y(2), y(2)], 'Color', [r, g, b], 'LineWidth', 2);
        
        if confirmAction() == 'y'
            % save
            pictureData{i,1}(2*numBoxCounter-1:2*numBoxCounter,1) = x;
            pictureData{i,1}(2*numBoxCounter-1:2*numBoxCounter,2) = y;
            pictureData{i,2}(numBoxCounter) = color;
            pictureData{i,3} = name(1:end-3);
            numBoxCounter = numBoxCounter+1;
        else
            % do this box over again
            delete(h);
        end
    end
    
    hold off;
    
end
close; % the figure
save(sprintf('%sboxes.mat',saveDir),'pictureData');





    