function a = kernel_regression(Kij,y,mu)

[n,n] = size(Kij);
a = y'*inv(Kij+mu*eye(n));