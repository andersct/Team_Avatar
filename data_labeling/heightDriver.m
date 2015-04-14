load('boxes_tommy_labeled');
pictureData = addHeightFeature(pictureData);
[d_sph, h_sph, d_tall, h_tall] = getHeightFeature(pictureData);

% plot height feature
plot(d_sph,h_sph,'b*',d_tall,h_tall,'r*');
hold on;
legend('Sphere', 'Tall');
xlabel('d');
ylabel('h');

% fit linear model
linear_model_sph = polyfit(d_sph, h_sph, 1);
linear_model_tall = polyfit(d_tall, h_tall, 1);
h_sph_fit = polyval(linear_model_sph, d_sph);
h_tall_fit = polyval(linear_model_tall, d_tall);

plot(d_sph,h_sph_fit,'b-',d_tall,h_tall_fit,'r-');