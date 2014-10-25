num_buoys = 0;

for k=1:5
    if (k==1) load('boxes_cyrus.mat'); end
    if (k==2) load('boxes_jocelyn0.mat'); end
    if (k==3) load('boxes_jocelyn1.mat'); end
    if (k==4) load('boxes_tommy.mat'); end
    if (k==5) load('boxes_michael.mat'); end
        
    for i=1:length(pictureData)
        for j=1:length(pictureData{i,2,:})
            num_buoys = num_buoys + 1;
        end
    end
end

pictureDataFixed = cell(num_buoys, 3);
ind = 1;

for k=1:5
    if (k==1) load('boxes_cyrus.mat'); end
    if (k==2) load('boxes_jocelyn0.mat'); end
    if (k==3) load('boxes_jocelyn1.mat'); end
    if (k==4) load('boxes_tommy.mat'); end
    if (k==5) load('boxes_michael.mat'); end
    for i=1:length(pictureData)-1
       for j=1:length(pictureData{i,2})
          pictureDataFixed{ind,1}(1:2,1) = int64(pictureData{i,1}(2*j-1:2*j,1));
          pictureDataFixed{ind,1}(1:2,2) = int64(pictureData{i,1}(2*j-1:2*j,2));
          pictureDataFixed{ind,2} = pictureData{i,2}(j);
          pictureDataFixed{ind,3} = [pictureData{i,3}, 'png'];
          ind = ind + 1;
       end
    end
end

save(sprintf('%sboxes.mat', '/afs/umich.edu/user/b/j/bjocelyn/eecs445/Team_Avatar/'),'pictureDataFixed');
