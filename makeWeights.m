weight_vec = zeros(2074+7114,1);

for i=1:2074
    weight_vec(i) = 1;
end
for i=2075:9188
    weight_vec(i) = 0.2;
end

save(sprintf('svmweights_synth.mat'),'weight_vec_synth','-v7.3');