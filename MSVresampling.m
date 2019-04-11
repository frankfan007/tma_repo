function xk_new = MSVresampling(xki, wk_pred, Ns)

xk_new = zeros(size(xki));
wk_pred = wk_pred/sum(wk_pred);         % normalize the weights (just in case)

n = 0;
Nmt = floor(Ns*wk_pred);
w_res = wk_pred - Nmt./Ns;          % weight residual
L = sum(Nmt);
[~, idx] = sort(w_res,'descend');
Nmt(idx(1:Ns-L)) = Nmt(idx(1:Ns-L)) + 1;
for m = 1:Ns
    for h = 1:Nmt(m)
        n = n+1;
        xk_new(:,n) = xki(:,m);
    end
end

end