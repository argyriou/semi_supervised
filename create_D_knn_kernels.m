function [K,flag] = create_D_knn_kernels(D,ks,normalised,beta)

% Creates Laplacian kernels using kNN matrices

[m,m] = size(D);
n = length(ks);
for i = 1:n
    A = knn_D(D,ks(i));
    switch normalised 
        case 0
            [K(i,:,:),flag] = laplacian_kernel(A);
        case 1
            [K(i,:,:),flag] = norm_laplacian_kernel(A);
        case 2
            [K(i,:,:),flag] = laplacian_heat_kernel(A,beta);
        case 3
            [K(i,:,:),flag] = norm_laplacian_heat_kernel(A,beta);
    end
end
