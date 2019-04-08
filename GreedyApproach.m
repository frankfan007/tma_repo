function xk_new = GreedyApproach(xki, wk_pred, tau, Ns)


Wt = sum(wk_pred);
w_norm = wk_pred/Wt;
[Wsigma, sigma] = sort(w_norm, 'descend');          % sigma is the ordering index
Vr = cumsum(Wsigma);
r = find(Vr>=tau);                                  % r above the threshold tau
k = r(1);                                           % minimum of r above the threshold
Vk = sum(Wsigma(1:k));                              % biggest weighted particles
Ksigma = round(Ns*Wsigma(1:k)./Vk);                 %  numbers of replication
Kt = sum(Ksigma);
xk_new = [];
for i = 1:k
    xk_new = [xk_new, repmat(xki(:,sigma(i)),1,Ksigma(i))];
end

if Kt > Ns
    xk_new = xk_new(:,1:Ns);
elseif Kt < Ns
    xk_new = [repmat(xki(:,sigma(1)),1, Ns-Kt), xk_new];
end

end