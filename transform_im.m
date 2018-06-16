function rz = transform_im(z,p)

% transforms 2-d image z by an affine transform + thickness (Hastie & Simard)
% p : parameter vector
% (x-translation, y-translation, x-scale, y-scale, rotation, shear, thickness)

[m,n] = size(z);
c = [(m-1)/2;(n-1)/2];
R = [cos(p(5)), -sin(p(5)); sin(p(5)), cos(p(5))];
T = [p(3), p(6); 0, p(4)];
t = [p(1);p(2)];

rz = zeros(1,m*n);
[zy,zx] = gradient(z);
[I,J] = meshgrid(1:m,1:n);
II = reshape(I,1,m*n);
JJ = reshape(J,1,m*n);
orig = R*T*([II;JJ]-repmat(c,1,m*n))+repmat(t+c,1,m*n); 
orig = round(orig);
orig1 = orig(1,:);
orig2 = orig(2,:);
valid = intersect(find(1<=orig1 & orig1<=m),find(1<=orig2 & orig2<=n));
ind = sub2ind([m,n],orig(1,valid),orig(2,valid));
ind0 = sub2ind([m,n],II(valid),JJ(valid));
rz(ind0) = z(ind) + p(7)*(zx(ind0).^2+zy(ind0).^2);
rz = reshape(rz,m,n);