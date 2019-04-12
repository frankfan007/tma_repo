%%  Filter Initialization - 12.04.2019

%%  Inputs:
%               * model         : structer containing model parameters
%               * own1          : initial ownship state
%%  Output:
%               * Tracks        : struct that contains
%                       * .X    : initial estimatet target state
%                       * .P    : estimated state covariance
%                       * .Particles: initial particles, cell array
%                       * .Wk   : initial weights

function Tracks = initializeFilter(model, own1)

Xki     = initParticles(own1, model);               % initial particles
Wki     = ones(model.N,1)/model.N;                  % initial, uniform weights

%%  output variable initialization
Tracks.X    = cell(model.K, 1);                 % estimated state variable
Tracks.X{1} = Xki*Wki;                          % initial target state
Tracks.P{1} = Wki'.*(Xki-Xki*Wki)*(Xki-Xki*Wki)';               % initial state covariance
Tracks.Particles{1} = Xki;
Tracks.Wk{1} = Wki;                             % initial weights

end