function D = dist_matrix(x,y)

% Computes matrix D_ij = ||x_i-y_j||^2

[n1,d] = size(x);
[n2,d] = size(y);
sqx = sum(x.^2,2);
sqy = sum(y.^2,2);
D = repmat(sqx,1,n2) + repmat(sqy',n1,1) - 2*x*y';