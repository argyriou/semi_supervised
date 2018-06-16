function [mse,misclass,Sm,Sm_err,Sm_norm] = laplacian_tests(yl,yu,kernels,omegas,mus,annot,txt,class,plot_fl,logx,pathname)

% run tests with laplacian kernels for various mus
% mu: regularization parameter
% kernels : n x m x m

[n,m,m] = size(kernels);
if (~class)
    misclass=[];
end
l = length(yl);

for i=1:n
    Kij = squeeze(kernels(i,:,:));
    for j=1:length(mus)
        mu = mus(j);
        a = kernel_regression(Kij(1:l,1:l),yl,mu);
        f = a*Kij(1:l,l+1:m);
        mse(j,i) = sum((f'-yu).^2)/length(yu);
        if (class)
            misclass(j,i) = sum(abs(sign(f')-yu))/2/length(yu);
        end
        Sm(j,i) = mu*a*yl; 
        Sm_err(j,i) = mu^2*a*a';
        Sm_norm(j,i) = Sm(j,i) - Sm_err(j,i);
        f_lu(j,i,:) = a*Kij(1:l,:);
    end
end

if plot_fl
    for j=1:length(mus)
        figure;
        hold on;
        plot(omegas,Sm(j,:));
        plot(omegas,mse(j,:),':r');
        set(gca,'YScale','log');
        if (logx)
            set(gca,'XScale','log');
        end
        if (class)
            plot(omegas,misclass(j,:),'--g');
            legend('minimum of functional','test error','misclassification error');
        else
            legend('minimum of functional','test error');
        end
        title(sprintf('%s = %.3g\t\t%s','\mu',mus(j),txt));
        fname = sprintf('%dpts_%s_square_mu%d',m,annot,round(-log10(mus(j))));
        saveas(gcf,fname);
    end
hold off;
end
save(sprintf('%s/%dpts_%s_square',pathname,m,annot),'mse','misclass','Sm','Sm_err','Sm_norm','omegas','mus','f_lu');