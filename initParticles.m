%%  Hasan Hüseyin Sönmez - 04.10.2018
%   initialize particles

%%  measurement driven initialization:
%   Particle filter initialization in non-linear non-Gaussian radar target
%   tracking Jian et al. (2007)

%%  other initialization schemes can be implemented, i.e. Metropolis-Hastings algorithm.

function x_init = initParticles(m, Q, own, Np, model)

%%  measurement driven initialization: 

%% random initialization around a given point
x_init = zeros(model.xDim, Np);
Qsqrt = sqrt(diag(Q));                            % square-root of process noise
for i = 1:Np
    x_init(:,i) = m + Qsqrt.*randn(model.xDim,1);
end

end