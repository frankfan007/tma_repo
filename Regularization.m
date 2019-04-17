function xk_new = Regularization(Xki, Sk, N)

nx = size(Xki, 1);          % state dimension
A = (4/(nx+2))^(1/(4+nx));
bw = A*(N^(-1/(4+nx)));

Dk = chol(Sk,'lower');

Gamma = randn(size(Xki));
xk_new = Xki + bw*Dk*Gamma;


end