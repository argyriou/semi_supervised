data_str = sprintf('%s_n%d_mu%d',data_fname,n,round(-log10(mu)));
dist_full_str = '';
for k=1:length(distances)
    dist_full_str = sprintf('%s_%s',dist_full_str,char(distances(k)));
end
fid = fopen(sprintf('results2_%s%s',data_str,dist_full_str),'w');
weighting = 'knn';
normalization = 'frol';

fprintf(fid,'*************************\n*\t%s dataset\t*\n*************************\n\n',data_fname);
fprintf(fid,'-----------------------------------------\n mu = %.g \n-----------------------------------------\n\n',mu);
fprintf(fid,'-----------------------------------------\n %s weights, %s \n-----------------------------------------\n\n',weighting,normalization);
fprintf(fid,'%d points\n\n',n);
for l=lab
    fprintf(fid,'%d + %d labeled\n',l/2,l/2);
    fname = sprintf('%s/%s_averages%s_%s_%s_l%d',test_dir,data_str,dist_full_str,...
        weighting,normalization,l);
    load(fname);

    fprintf(fid,'Convex combination error \t %.5g \n',mcmisclass);
    fprintf(fid,'%s \n',dist_full_str);
    fprintf(fid,'Error\t');
    errs = zeros(1,trials);
    for i=1:trials
        load(sprintf('%s/%dpts_%s%s_%s_%s_%dlabeled%d_square',test_dir,n,data_str,dist_full_str,...
            weighting,normalization,l,i));
        errs = errs + misclass/trials;
    end
    for i=1:length(distances)
        fprintf(fid,'%.5g ',min(errs(Nk*i-Nk+1:Nk*i)));
    end
    fprintf(fid,'\n');

    fprintf(fid,'Sum of lambdas\t');
    for i = 1:length(distances)
        fprintf(fid,'%.5g ',sum(mlambdas(Nk*i-Nk+1:Nk*i)));
    end
    fprintf(fid,'\n');
    fprintf(fid,'\n');
end
fprintf(fid,'\n\n');
