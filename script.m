load('buoy_data/boxes_jocelyn0.mat');
name = ['jocelyn_pics_init/' pictureData{1,3} 'png'];
pictureData{1,1,:};
hist = histogram(pictureData{1,1}, name);