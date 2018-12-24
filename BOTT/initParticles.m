%%  Hasan Hüseyin Sönmez - 04.10.2018
%   initialize particles

%%  otoher initialization schemes can be implemented, i.e. Metropolis-Hastings algorithm.

function x_init = initParticles(m, Q, own, Np, model)

x_init = zeros(model.xDim, Np);
Qsqrt = sqrt(diag(Q));                            % square-root of process noise
for i = 1:Np
    x_init(:,i) = m-own + Qsqrt.*randn(model.xDim,1);
end

end