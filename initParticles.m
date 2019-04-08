%%  Hasan Hüseyin Sönmez - 04.10.2018
%   initialize particles

%%  measurement driven initialization:
%   Particle filter initialization in non-linear non-Gaussian radar target
%   tracking Jian et al. (2007)

%%  other initialization schemes can be implemented, i.e. Metropolis-Hastings algorithm.

function x_init = initParticles(R_in, C_in, S_in, own, Theta1, Np, model)

knot = 0.5144;
Rsigma = 2000;
Ssigma = 2*knot;
Csigma = pi/sqrt(12);
%%  measurement driven initialization: 

%% ------------------------------------
Rs = normrnd(R_in, Rsigma, 1,Np);
Ss = normrnd(S_in, Ssigma, 1,Np);
Cs = normrnd(C_in, Csigma, 1,Np);
% Rs = (R_in(2)-R_in(1))*rand(1,Np);                  % uniformly distributed range
% Cs = (C_in(2)-C_in(1))*rand(1,Np);                  % uniformly distributed course
% Ss = (S_in(2)-S_in(1))*rand(1,Np);                  % uniformly distributed speed

x = Rs.*sin(Theta1);
y = Rs.*cos(Theta1);
vx = Ss.*sin(Cs);
vy = Ss.*cos(Cs);
x_init = [x; vx; y; vy];
% %% random initialization around a given point
% x_init = zeros(model.xDim, Np);
% Qsqrt = sqrt(diag(Q));                            % square-root of process noise
% for i = 1:Np
%     x_init(:,i) = m(:,i) + Qsqrt.*randn(model.xDim,1);
% end

end