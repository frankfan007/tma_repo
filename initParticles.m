%%  Hasan Hüseyin Sönmez - 04.10.2018
%   initialize particles

%%  measurement driven initialization:
%   Particle filter initialization in non-linear non-Gaussian radar target
%   tracking Jian et al. (2007)

%%  other initialization schemes can be implemented, i.e. Metropolis-Hastings algorithm.

function x_init = initParticles(own, model)

knot    = 0.5144;
Np      = model.N;
% Rsigma = 2000;
% Ssigma = 2*knot;
% Csigma = pi/sqrt(12);
%%  measurement driven initialization: 

%% ------------------------------------
R_in = model.Rinit;
C_in = model.Cinit;
S_in = model.Sinit;
Rs = (R_in(2)-R_in(1))*rand(1,Np);                  % uniformly distributed range
Cs = (C_in(2)-C_in(1))*rand(1,Np);                  % uniformly distributed course
Ss = (S_in(2)-S_in(1))*rand(1,Np);                  % uniformly distributed speed

Theta1 = model.B0*pi/180;
x = Rs.*sin(Theta1) + own(1);
y = Rs.*cos(Theta1) + own(3);
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