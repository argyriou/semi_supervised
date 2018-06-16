function D = flip_twice(x,a,b,intervals)

% Flips image around x-axis and then around y-axis
% and computes distance matrix

[m,d] = size(x);
for i = 1:m
    z(i,:,:) = reshape(x(i,:),a,b);
end

for i=1:m
    for j=1:m
        diff = sum((x(i,:)-x(j,:)).^2);
        for theta = -pi:pi/intervals:pi
            p = [0;0;1;1;theta;0;0];
            rz = transform_im(squeeze(z(i,:,:)),p);
            diff1 = sum((reshape(rz,1,d)-x(j,:)).^2);
            diff = min([diff1,diff]);
        end
        D(i,j) = diff;
    end
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