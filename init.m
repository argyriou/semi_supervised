ks = [1:10];
Nk = 10;
mu = 1e-5;              % regularization parameter
trials = 30;            

% For transformation & tangent distances
a = 16;
b = 16;
nn = 20;
conv_var = 0;

p_range = [-2            2
    -2            2
    0.9          1.1
    0.9          1.1
    -0.2          0.2
    -0.1          0.1
    0            1 ];

% For low-quality transform
intervals = 20;