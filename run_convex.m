data_str = sprintf('%s_n%d_mu%d',data_fname,n,round(-log10(mu)));
load(data_fname);
load(index_fname);

for l=lab
    for i=1:trials
        ind = indexes(i,1:n);
        dist_full_str = '';
        for k=1:length(distances)
            dist_str = char(distances(k));
            for j=1:Nk
                load(sprintf('kernel_%s_%s_%d',dist_str,data_fname,j));
                jk = j+(k-1)*Nk;
                K(jk,:,:) = Ki(ind,ind);
                K(jk,:,:) = K(jk,:,:) / norm(squeeze(K(jk,1:l,1:l)),'fro');
            end
            dist_full_str = sprintf('%s_%s',dist_full_str,dist_str);
        end
        [mses,misclasses,Sms,Sms_err,Sms_norm] = laplacian_tests(y(ind(1:l)),y(ind(l+1:n)),K,ks,[l*mu],...
            sprintf('%s%s_knn_frol_%dlabeled%d',data_str,dist_full_str,l,i),...
            sprintf('%s %s knn frol %d labeled %d total',data_str,dist_full_str,l,n),1,0,1,test_dir);
        mse(i) = min(mses);
        misclass(i) = min(misclasses);
        Sm(i) = min(Sms);
        Sm_err(i) = min(Sms_err);
        Sm_norm(i) = min(Sms_norm);
        lambdas0 = ones(length(distances)*Nk,1)/length(distances)/Nk;
        lambdas0(Nk) = 1-sum(lambdas0(1:length(distances)*Nk-1));
        [lambdas(:,i),cSm(i),cmisclass(i),cmse(i),cSm_err(i),cSm_norm(i)] = ...
            minimax_test_laplacians(y(ind(1:l)), y(ind(l+1:n)),l*mu, 100, 1e-6, 1e-6, 1, lambdas0, K);
        clear K;
        clear ind;
    end
    mmse = mean(mse);
    mmisclass = mean(misclass);
    mSm = mean(Sm);
    mcSm = mean(cSm);
    mSm_err = mean(Sm_err);
    mcSm_err = mean(cSm_err);
    mSm_norm = mean(Sm_norm);
    mcSm_norm = mean(cSm_norm);
    mcmisclass = mean(cmisclass);
    mcmse = mean(cmse);
    mlambdas = mean(lambdas');
    smse = std(mse);
    smisclass = std(misclass);
    sSm = std(Sm);
    scSm = std(cSm);
    sSm_err = std(Sm_err);
    scSm_err = std(cSm_err);
    sSm_norm = std(Sm_norm);
    scSm_norm = std(cSm_norm);
    scmisclass = std(cmisclass);
    scmse = std(cmse);
    slambdas = std(lambdas');
    save(sprintf('%s/%s_averages%s_knn_frol_l%d',test_dir,data_str,dist_full_str,l),...
        'mmse','mmisclass','mSm','mcSm','mSm_err','mcSm_err','mSm_norm','mcSm_norm','mcmisclass','mcmse',...
        'mlambdas','smse','smisclass','sSm','scSm','sSm_err','scSm_err','sSm_norm','scSm_norm',...
        'scmisclass','scmse','slambdas');
end
clear lambdas;
