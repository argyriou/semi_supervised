function [K, flag] = norm_laplacian_kernel(A)

% Computes the normalised Laplacian pseudoinverse kernel

d = sum(A);
L = diag(d)-A;
D = diag(1./sqrt(d));
L = D*L*D;
K = pinv(L);
if (find(abs(K-K')>1e-9))
    disp(sprintf('non-symmetric pseudoinverse -- max. disparity %.2g', max(max(abs(K-K')))));
    flag = 1;
else
    flag = 0;
end