dataDir = '/afs/umich.edu/user/b/j/bjocelyn/eecs445/Team_Avatar/';%'/afs/umich.edu/user/a/n/andersct/Public/difficult_buoy/'; %pwd + /

greenFolder = 'synth_data/green/';
whiteFolder = 'synth_data/white/';
redFolder = 'synth_data/red/';

greenPics = dir(sprintf('%s*.png',[dataDir, greenFolder]));
whitePics = dir(sprintf('%s*.png',[dataDir, whiteFolder]));
redPics = dir(sprintf('%s*.png',[dataDir, redFolder]));

synthPicsData = cell(length(greenPics) + length(whitePics) + length(redPics), 3);
ind = 1;

for i=1:length(greenPics)
      synthPicsData{ind,1}(1:2,1) = [1,100];
      synthPicsData{ind,1}(1:2,2) = [1,100];
      synthPicsData{ind,2} = 2;
      synthPicsData{ind,3} = [greenFolder, greenPics(i).name];
      ind = ind + 1;
end

for i=1:length(whitePics)
      synthPicsData{ind,1}(1:2,1) = [1,1];
      synthPicsData{ind,1}(1:2,2) = [100,100];
      synthPicsData{ind,2} = 3;
      synthPicsData{ind,3} = [whiteFolder, whitePics(i).name];
      ind = ind + 1;
end

for i=1:length(redPics)
      synthPicsData{ind,1}(1:2,1) = [1,1];
      synthPicsData{ind,1}(1:2,2) = [100,100];
      synthPicsData{ind,2} = 1;
      synthPicsData{ind,3} = [redFolder, redPics(i).name];
      ind = ind + 1;
end

save(sprintf('%ssynthBoxes.mat',dataDir),'synthPicsData');