function A = knn_D(D,k)

% Computes the adjacency matrix with k-NN

[m,m] = size(D);
[S,I] = sort(D);
I = I(1:k+1,:);
ind = sub2ind([m,m],I,repmat(1:m,k+1,1)); 
A = zeros(m,m);
A(ind) = 1;
A = symmetrize(A);      
A = sparse(A - eye(m));