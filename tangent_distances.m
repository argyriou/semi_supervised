function D = tangent_distances(images,euclD,a,b,p_range,conv_var,k,filename)

% Tangent distances (squared) matrix from a-by-b images
% See T. Hastie and P. Simard, Models and Metrics for Handwritten Character
% Recognition, 1998.
% p_range : 7-by-2 parameter bounds vector

[n,d] = size(images);
if (d~=a*b)
    error('Dimensions do not match');
end

% consider only k Euclidean neighbors
[S,kI] = sort(euclD);
kI = kI(2:k+1,:);
kJ = repmat(1:n,k,1);

x0 = (a-1)/2;
y0 = (b-1)/2;
[x,y] = meshgrid(1:a,1:b);

% tangent plane   
for i=1:n 
    F = reshape(images(i,:),a,b);
    if (~conv_var)
        [Fy,Fx] = gradient(F);
    else
        G = -(1/conv_var)^2*exp(-0.5/conv_var*(x.^2+y.^2)); 
        Fx = conv2(F,G.*x);
        Fy = conv2(F,G.*y);
    end
    T(i,:,1) = reshape(Fx,d,1);
    T(i,:,2) = reshape(Fy,d,1);
    T(i,:,3) = reshape((x-x0).*Fx,d,1);
    T(i,:,4) = reshape((y-y0).*Fy,d,1);
    T(i,:,5) = reshape((y-y0).*Fx-(x-x0).*Fy,d,1);
    T(i,:,6) = reshape((y-y0).*Fx+(x-x0).*Fy,d,1);
    T(i,:,7) = reshape(Fx.^2+Fy.^2,d,1);
end

% Constrained least squares
p1 = [p_range(:,1);p_range(:,1)];
p2 = [p_range(:,2);p_range(:,2)];
options = optimset('Display','off');
D = inf*ones(n,n);
T34 = squeeze(T(:,:,3)+T(:,:,4));
for i=1:n*k
    xx = images(kI(i),:)-images(kJ(i),:) + T34(kJ(i),:)-T34(kI(i),:);
    tt = [squeeze(T(kJ(i),:,:)),-squeeze(T(kI(i),:,:))];
    [p,D(kI(i),kJ(i))] = lsqlin(tt,xx',[],[],[],[],p1,p2,[],options);
end

for i=1:n
    for j=i+1:n
        D(i,j) = min([D(i,j),D(j,i)]);
        D(j,i) = D(i,j);
    end
end
for i=1:n
    D(i,i) = 0;
end

if (nargin==8)
    save(filename,'D','p_range','conv_var');
end
