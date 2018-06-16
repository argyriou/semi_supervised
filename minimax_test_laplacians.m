function [lambdas,Sm,misclass,mse,Sm_err,Sm_norm] = minimax_test_laplacians(yl, yu, mu, iters, ...
    tol_lambda, tol_g, recycle, lambdas0, K)

% K : n x m x m kernels

if (abs(sum(sum(lambdas0))-1)>eps)
    disp('Lambdas should sum to 1');
    return;
end
l = length(yl);
u = length(yu);

[lambdas,Sm] = minimax_sq(K(:,1:l,1:l), mu, yl, iters, tol_lambda, tol_g, recycle, lambdas0);
Kopt = squeeze(sum(repmat(lambdas,[1,l+u,l+u]).*K,1));
a = kernel_regression(Kopt(1:l,1:l),yl,mu);
f = a*Kopt(1:l,l+1:l+u);
Sm_err = mu^2*a*a';
Sm_norm = Sm-Sm_err;
        
misclass = length(find(sign(f')-yu))/length(yu);
disp(sprintf('%f error\n',misclass));
mse = sum((f'-yu).^2)/length(yu);