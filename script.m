load('buoy_data/boxes_jocelyn0.mat');
name = ['pics/' pictureData{1,3} 'png']
pictureData{1,1,:};
[hist_mat, hist_vec] = histogram(pictureData{1,1}, name);