data_str = sprintf('%s_n%d_mu%d',data_fname,n,round(-log10(mu)));
dist_full_str = '';
for k=1:length(distances)
    dist_full_str = sprintf('%s_%s',dist_full_str,char(distances(k)));
end
fid = fopen(sprintf('results_table_%s%s',data_str,dist_full_str),'w');
weighting = 'knn';
normalization = 'frol';

fprintf(fid,'*************************\n*\t%s dataset\t*\n*************************\n\n',data_fname);
fprintf(fid,'-----------------------------------------\n mu = %.g \n-----------------------------------------\n\n',mu);
fprintf(fid,'-----------------------------------------\n %s weights, %s \n-----------------------------------------\n\n',weighting,normalization);
fprintf(fid,'%d points\n\n',n);
sstr = '';
mstr = '';
for l=lab
    fname = sprintf('%s/%s_averages%s_%s_%s_l%d',test_dir,data_str,dist_full_str,weighting,normalization,l);
    load(fname);        
    mstr = sprintf('%s & %.2f ',mstr,100*mcmisclass);
    sstr = sprintf('%s & %.2f ',sstr,100*scmisclass);
end
fprintf(fid,'%s \n %s \n\n',mstr,sstr);