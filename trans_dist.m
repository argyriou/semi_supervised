function [D,pmax] = trans_dist(x,euclD,a,b,k,p_range)

% Distances of invariant transforms between images of digits
% euclD : dist_matrix(x,x)
% Considers only k closest Euclidean neighbors for each image 
% p_range : 7-by-2 parameter vector

[m,d] = size(x);
D = inf*ones(m,m);

[S,kI] = sort(euclD);
kI = kI(2:k+1,:);
kJ = repmat(1:m,k,1);

c = [(a-1)/2;(b-1)/2];
p1 = p_range(:,1);
p2 = p_range(:,2);
p0 = (p1+p2)/2;
options = optimset('Display','off','GradObj','on');
[I,J] = meshgrid(1:a,1:b);
II = reshape(I,1,d);
JJ = reshape(J,1,d);        

% nested fn
    function [fval,grad] = tfun(p)
        cth = cos(p(5));
        sth = sin(p(5));
        R = [cth, -sth; sth, cth];
        T = [p(3), p(6); 0, p(4)];
        t = [p(1);p(2)];

        rz = zeros(1,d);
        orig = R*T*([II;JJ]-repmat(c,1,d))+repmat(t+c,1,d);
        orig = round(orig);
        orig1 = orig(1,:);
        orig2 = orig(2,:);
        valid = intersect(find(1<=orig1 & orig1<=a),find(1<=orig2 & orig2<=b));
        ind = sub2ind([a,b],orig(1,valid),orig(2,valid));
        ind0 = sub2ind([a,b],II(valid),JJ(valid));
        rz(ind0) = zi(ind) + p(7)*(zx(ind0).^2+zy(ind0).^2);
        fval = sum((rz-xj).^2);

        if nargout > 1
            xloc = orig(1,valid);
            yloc = orig(2,valid);
            g1 = zx(ind);
            g2 = zy(ind);
            g3 = cth*(xloc-c(1)).*zx(ind)-sth*(xloc-c(1)).*zy(ind);
            g4 = sth*(yloc-c(2)).*zx(ind)+cth*(yloc-c(2)).*zy(ind);
            dT = [-sth,cth;-cth,-sth]*T*orig(:,valid);
            g5 = dT(1,:).*zx(ind)+dT(2,:).*zy(ind);
            g6 = cth*(yloc-c(2)).*zx(ind)-sth*(yloc-c(2)).*zy(ind);
            g7 = zx(ind0).^2+zy(ind0).^2;
            temp = rz(ind0)-xj(ind0);
            grad = [sum(temp.*g1), sum(temp.*g2), sum(temp.*g3), sum(temp.*g4), sum(temp.*g5), sum(temp.*g6), sum(temp.*g7)];
        end
    end
% end of nested fn

for i = 1:m*k
    %    if (kI(i) < kJ(i))
    zi = reshape(x(kI(i),:),a,b);
    xj = x(kJ(i),:);
    [zy,zx] = gradient(zi);
    [p0, D(kI(i),kJ(i))] = fmincon(@tfun,p0,[],[],[],[],p1,p2,[],options);
    pmax(i,:) = p0';
end

for i=1:m
    for j=i+1:m
        D(i,j) = min([D(i,j),D(j,i)]);
        D(j,i) = D(i,j);
    end
end
for i=1:m
    D(i,i) = 0;
end
end