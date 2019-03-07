function xk_new = Systematic(xki, wk_pred, Ns)

xk_new = zeros(size(xki));

CSW = cumsum(wk_pred);      % cumulative sample weights
u1  = (1/Ns)*rand;
jj  = 1:Ns;
u  = u1 + (jj-1)/Ns;
i   = 1;
for j = 1:Ns
    while u(j) > CSW(i)
        i = i+1;
    end
    xk_new(:,j) = xki(:,i);
end