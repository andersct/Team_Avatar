weight_vec = zeros(2074,1);

for i=1:830
    weight_vec(i) = 1;
end
for i=831:2074
    weight_vec(i) = 0.01;
end

save(sprintf('svmweights.mat'),'weight_vec','-v7.3');