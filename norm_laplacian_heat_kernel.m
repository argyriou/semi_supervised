function [K, flag] = norm_laplacian_heat_kernel(A, beta)

% Computes the normalised Laplacian heat kernel

[m,m] = size(A);
d = sum(A)+eps;
L = spdiags(d',0,m,m)-A;
D = spdiags(1./sqrt(d)',0,m,m);
L = D*L*D;

% opts.disp = 0;
% opts.maxit = 100;
%beta = 0.5/eigs(L,1,'lr',opts);
if (~beta)
    beta = 0.5/max(eig(full(L)));
end
%K = expm(-beta*L);
K = speye(m);
P = speye(m);
for k=1:5
    P = L*P;
    K = K + P*((-beta)^k/factorial(k));
end
%while (eigs(K,1,'sr',opts)<0)
while (min(eig(full(K))) < 0)
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