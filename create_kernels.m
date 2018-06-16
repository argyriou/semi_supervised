load(data_fname);
for k=1:length(distances)
    dist_str = char(distances(k));
    load(sprintf('%s_dists_%s_%d.mat',dist_str,data_fname,n));
    [K2,flag] = create_D_knn_kernels(D,ks,1,0);
    for i=1:Nk
        Ki = squeeze(K2(i,:,:));
        save(sprintf('kernel_%s_%s_%d',dist_str,data_fname,i),'Ki');
    end
end
clear K2;
clear Ki;