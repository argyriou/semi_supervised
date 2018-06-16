function W2 = symmetrize(W)

% symmetrize by selecting larger

T = W';
M = W-T;
f = find(M<0);
W2 = W;
if (length(f))
    W2(f) = T(f);
end