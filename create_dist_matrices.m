load(data_fname);
for k=1:length(distances)
    dist_str = char(distances(k));
    if strcmp(dist_str,'eucl')
        % Euclidean
        D = dist_matrix(x(1:n,:),x(1:n,:));
        save(sprintf('%s_dists_%s_%d.mat',dist_str,data_fname,n),'D');
    elseif strcmp(dist_str,'trans')
        % Transformation
        load(sprintf('eucl_dists_%s_%d.mat',data_fname,n));
        Deucl = D;
        D = trans_dist(x(1:n,:),Deucl(1:n,1:n),a,b,nn,p_range);
        save(sprintf('%s_dists_%s_%d.mat',dist_str,data_fname,n),'D','p_range');
    elseif strcmp(dist_str,'tang')
        % Tangent distances
        load(sprintf('eucl_dists_%s_%d.mat',data_fname,n));
        Deucl = D;
        D = tangent_distances(x(1:n,:),Deucl(1:n,1:n),a,b,p_range,conv_var,nn,...
            sprintf('%s_dists_%s_%d.mat',dist_str,data_fname,n));
    elseif strcmp(dist_str,'flip')
        % Low-quality distance
        D = flip_twice(x(1:n,:),a,b,intervals);
        save(sprintf('%s_dists_%s_%d.mat',dist_str,data_fname,n),'D');
    end
end