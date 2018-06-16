function [K, flag] = laplacian_kernel(A)

% Computes the Laplacian pseudoinverse kernel

D = diag(sum(A));
L = D-A;
K = pinv(L);
if (find(abs(K-K')>1e-9))
    disp(sprintf('non-symmetric pseudoinverse -- max. disparity %.2g', max(max(abs(K-K')))));
    flag = 1;
else
    flag = 0;
end