%%  Hasan H�seyin S�nmez - 17.09.2018
%   Bootstrap type Particle filter
%   with sequential importance sampling & resampling (uniform)

%%  Input:  
%           * particles from previous cycle (xk_prev)
%           * new measurements (zk)
%           * PF parameter file (PFparams)
%%  Output:
%           * particles of the new cycle (xk_new).
%           * new particle weights (wk_new).


function [xhat, xk_new, wk_new] = BootstrapPF(xk_prev, wk_prev, zk, Uk, model)

Ns      = size(xk_prev,2);                              % number of particles

%%  prediction
Xki     = SampleParticles(xk_prev, Uk, model);          % predicted particles
Wki     = SampleWeights(Xki, wk_prev, zk, model);       % predicted weights
wk_pred = Wki/sum(Wki);                                 % normalized weights

xhat    = Xki*wk_pred;

%% update

%% resampling (should be another function)- implement alternative resampling strategies
Neff = 1/sum(wk_pred.^2)
if Neff <= model.Nthr
    xk_new = Resampling(Xki, wk_pred, model);               % updated particles
    wk_new = ones(1,Ns)/Ns;                                 % new particles (uniform)
else
    xk_new = Xki;
    wk_new = wk_pred;
end


end