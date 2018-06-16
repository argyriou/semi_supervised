data_str = sprintf('%s_n%d_mu%d',data_fname,n,round(-log10(mu)));
dist_full_str = '';
for k=1:length(distances)
    dist_full_str = sprintf('%s_%s',dist_full_str,char(distances(k)));
end
fid = fopen(sprintf('results_%s%s',data_str,dist_full_str),'w');
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
    fprintf(fid,'	    Minimum over range		Convex combination\n');
    fprintf(fid,'	 mean   std. dev.           	mean 	std. dev.\n');
    fprintf(fid,'MSE\t%.5g\t%.5g\t\t%.5g\t%.5g\n',mmse,smse,mcmse,scmse);
    fprintf(fid,'miscl.\t%.5g\t%.5g\t\t%.5g\t%.5g\n',mmisclass, smisclass,mcmisclass,scmisclass);
    fprintf(fid,'Qm\t%.3g\t%.3g\t\t%.3g\t%.3g\n\n',mSm,sSm,mcSm,scSm);
    fprintf(fid,'\n Lambdas \n');
    fprintf(fid,sprintf('%s \n',dist_full_str));
    fprintf(fid,'Mean\t');
    for i = 1:length(mlambdas)
        fprintf(fid,'%.5g ',mlambdas(i));
    end
    fprintf(fid,'\nStd\t');
    for i = 1:length(slambdas)
        fprintf(fid,'%.5g ',slambdas(i));
    end
    fprintf(fid,'\n\n');
    % plot the learned lambdas
    figure;
    hold on;
    for k = 1:length(distances)
        plot((k-1)*Nk+1:k*Nk,mlambdas((k-1)*Nk+1:k*Nk));
    end
    fprintf(fid,'\n\n');
end
