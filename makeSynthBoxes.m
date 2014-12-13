dataDir = '/afs/umich.edu/user/b/j/bjocelyn/eecs445/Team_Avatar/';%'/afs/umich.edu/user/a/n/andersct/Public/difficult_buoy/'; %pwd + /

green = 'synth_data/green/';
white = 'synth_data/white/';
red = 'synth_data/red/';
black = 'synth_data/black/';
blue = 'synth_data/blue/';
yellow = 'synth_data/yellow/';

greenPics = dir(sprintf('%s*.png',[dataDir, green]));
whitePics = dir(sprintf('%s*.png',[dataDir, white]));
redPics = dir(sprintf('%s*.png',[dataDir, red]));
blackPics = dir(sprintf('%s*.png',[dataDir, black]));
bluePics = dir(sprintf('%s*.png',[dataDir, blue]));
yellowPics = dir(sprintf('%s*.png',[dataDir, yellow]));

synthPicsData = cell(length(greenPics) + length(whitePics) + 1400 + length(blackPics) + length(bluePics) + length(yellowPics), 3);
ind = 1;

for i=1:length(greenPics)
      synthPicsData{ind,1}(1:2,1) = [1,100];
      synthPicsData{ind,1}(1:2,2) = [1,100];
      synthPicsData{ind,2} = 2;
      synthPicsData{ind,3} = [green, greenPics(i).name];
      ind = ind + 1;
end

for i=1:length(whitePics)
      synthPicsData{ind,1}(1:2,1) = [1,1];
      synthPicsData{ind,1}(1:2,2) = [100,100];
      synthPicsData{ind,2} = 3;
      synthPicsData{ind,3} = [white, whitePics(i).name];
      ind = ind + 1;
end

for i=1:1400
      synthPicsData{ind,1}(1:2,1) = [1,1];
      synthPicsData{ind,1}(1:2,2) = [100,100];
      synthPicsData{ind,2} = 1;
      synthPicsData{ind,3} = [red, redPics(i).name];
      ind = ind + 1;
end

for i=1:length(blackPics)
      synthPicsData{ind,1}(1:2,1) = [1,1];
      synthPicsData{ind,1}(1:2,2) = [100,100];
      synthPicsData{ind,2} = 1;
      synthPicsData{ind,3} = [black, blackPics(i).name];
      ind = ind + 1;
end

for i=1:length(bluePics)
      synthPicsData{ind,1}(1:2,1) = [1,1];
      synthPicsData{ind,1}(1:2,2) = [100,100];
      synthPicsData{ind,2} = 1;
      synthPicsData{ind,3} = [blue, bluePics(i).name];
      ind = ind + 1;
end

for i=1:length(yellowPics)
      synthPicsData{ind,1}(1:2,1) = [1,1];
      synthPicsData{ind,1}(1:2,2) = [100,100];
      synthPicsData{ind,2} = 1;
      synthPicsData{ind,3} = [yellow, yellowPics(i).name];
      ind = ind + 1;
end

save(sprintf('%ssynthBoxes.mat',dataDir),'synthPicsData');