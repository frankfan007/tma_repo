function xk_new = Regularization(Xki, Sk, N)

nx = size(Xki, 1);          % state dimension
A = (4/(nx+2))^(1/(4+nx));
bw = A*(N^(-1/(4+nx)));

[Dk, p] = chol(Sk,'lower');

if p == 0
    Gamma = randn(size(Xki));
    xk_new = Xki + bw*Dk*Gamma;
else
    xk_new = Xki;
end


end