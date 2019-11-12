%%  Hasan Hüseyin Sönmez - 04.10.2018
%   initialize particles

%%  measurement driven initialization:
%   Particle filter initialization in non-linear non-Gaussian radar target
%   tracking Jian et al. (2007)

%%  other initialization schemes can be implemented, i.e. Metropolis-Hastings algorithm.

function x_init = initParticles(own, model)

Np      = model.N;

%% ------------------------------------
R_in    = model.Rinit;
C_in    = model.Cinit;
S_in    = model.Sinit;
B_in    = model.Binit;
Rs      = (R_in(2)-R_in(1))*rand(1,Np);                  % uniformly distributed range
Cs      = (C_in(2)-C_in(1))*rand(1,Np);                  % uniformly distributed course
Ss      = (S_in(2)-S_in(1))*rand(1,Np);                  % uniformly distributed speed
Bs      = (B_in(2)-B_in(1))*rand(1,Np)+B_in(1);          % uniformly distributed initial bearing
% Bs = mod(Bs,360);

% Theta1 = model.B0*pi/180;
Theta1  = Bs*pi/180;
x       = Rs.*sin(Theta1) + own(1);
y       = Rs.*cos(Theta1) + own(3);
vx      = Ss.*sin(Cs);
vy      = Ss.*cos(Cs);
x_init  = [x; vx; y; vy];


end