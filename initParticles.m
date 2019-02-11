%%  Hasan H�seyin S�nmez - 04.10.2018
%   initialize particles

%%  otoher initialization schemes can be implemented, i.e. Metropolis-Hastings algorithm.

function x_init = initParticles(m, Q, Np, model)

x_init = zeros(model.xDim, Np);
for i = 1:Np
    x_init(:,i) = MarkovDensity(model, m, Q);       % predicted particles
end

end