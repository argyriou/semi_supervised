function [lambdas,Sm] = minimax_sq(K, mu, y, iters, tol_lambda, tol_g, recycle, lambdas0)

% Best convex combination of kernels for square loss 
% through iterative optimization wrt c and lambda
% K : n x m x m array of n kernel matrices

if (abs(sum(sum(lambdas0))-1) > eps)
    disp('Lambdas should sum to 1');
    return;
end
[n,m,m] = size(K);
lambdas = lambdas0;
Sm = inf;
j = 0;

for t=1:iters
    if ~recycle
        active = find(lambdas);
        if (length(active)==n)
            break;
        end
    end
    Kt = squeeze(sum(repmat(lambdas,[1,m,m]).*K,1));
    
    Sm_prev = Sm;
    Sm = mu*y'*inv(Kt+ mu*eye(m))*y;
    if (abs(Sm-Sm_prev)/Sm < tol_g & j==n-1)
        break;
    end    
    
    ch = -inv(Kt+mu*eye(m))*y;
    g = ch'*Kt*ch;
    if recycle
        candidates = [1:n];
    else
        candidates = setdiff([1:n],active);
    end
    found = false;
    for j=candidates(randperm(length(candidates)))
        Kj = squeeze(K(j,:,:));
        if (ch'*Kj*ch > g)
            found = true;
            break;
        end
    end

    if (~found)         % Optimum reached (no kernel can improve)
        break;
    end
    
    % Search for lambda minimizing phi
    l_prev = inf;
    l = 0.5;
    while (abs(l-l_prev) > tol_lambda)
        tempi = inv(l*Kj+(1-l)*Kt+mu*eye(m));
        cKl = -2*mu*tempi*y;
        temp = (Kt-Kj)*cKl;
        dphi = cKl'*temp/(4*mu);
        ddphi = temp'*tempi*temp/(2*mu);
        l_prev = l;
        l = l-dphi/ddphi;
        if (l>=1)
            l=1;
            break;
        elseif (l<=0)
            l=0;
            break;
        end
    end
    
    % update kernel
    lambdas = l*[zeros(j-1,1);1;zeros(n-j,1)] + (1-l)*lambdas;
    
    %     % DEBUG
    %     figure;
    %     hold on;
    %     for l=0:0.005:1
    %         plot(l,-y'*inv(l*Kj+(1-l)*Kt+mu*eye(m))*y);
    %     end
    %     % END DEBUG
    templ(t,:) = lambdas';  
    tempS(t) = Sm;
end

%save('foo','templ','tempS');
disp(sprintf('Ended after %d iterations\n',t));