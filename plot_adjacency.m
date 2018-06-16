for k=1:length(distances)
    dist_str = char(distances(k));
    load(sprintf('%s_dists_%s_%d.mat',dist_str,data_fname,n));
    A = knn_D(D,Nk);
    figure;
    spy(A([1:2:n,2:2:n],[1:2:n,2:2:n]))
    title(dist_str);
end