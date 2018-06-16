function [K, flag] = laplacian_heat_kernel(A)

% Computes the Laplacian heat kernel

[m,m] = size(A);
d = sum(A);
L = spdiags(d',0,m,m)-A;
    
opts.disp = 0;
opts.maxit = 70;
beta = 0.5/eigs(L,1,'la',opts);
%K = expm(-beta*L);
K = speye(m);
P = speye(m);
for k=1:5
    P = L*P;
    K = K + P*((-beta)^k/factorial(k));
end

while (eigs(K,1,'sa',opts)<0)
    k = k + 1;
    P = L*P;
    K = K + P*((-beta)^k/factorial(k));
end
    
if (find(abs(K-K')>1e-9))
    disp(sprintf('non-symmetric heat kernel -- max. disparity %.2g', max(max(abs(K-K')))));
    flag = 1;
else
    flag = 0;
end

K = full(K);