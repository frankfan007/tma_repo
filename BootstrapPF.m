%%  Hasan Hüseyin Sönmez - 17.09.2018
%   Bootstrap type Particle filter
%   with sequential importance sampling & resampling (uniform)

%%  Input:  
%           * particles from previous cycle (xk_prev)
%           * new measurements (zk)
%           * PF parameter file (PFparams)
%%  Output:
%           * particles of the new cycle (xk_new).
%           * new particle weights (wk_new).


function [xhat, xk_new, wk_new] = BootstrapPF(xk_prev, wk_prev, zk, Uk, own, model)

N      = size(xk_prev,2);                              % number of particles

%%  prediction
Xki     = SampleParticles(xk_prev, Uk, model);          % predicted particles
Wki     = SampleWeights(Xki, wk_prev, zk, own, model);  % predicted weights
wk_pred = Wki/sum(Wki);                                 % normalized weights

xhat    = Xki*wk_pred;

%% resampling (should be another function)- implement alternative resampling strategies
Neff = 1/(sum(wk_pred.^2))
% Neff = -sum(wk_pred.*log(wk_pred)./log(Ns));             % entropy of weights
if isnan(Neff)
    wk_pred = ones(N,1)/N;
end

if Neff <= model.Nthr
    %% regularization
    Sk = wk_pred'.*(Xki-xhat)*(Xki-xhat)';
    %% update
    xk_new = Resampling(Xki, wk_pred, model);               % updated particles
    wk_new = ones(N,1)/N;                                   % new particles (uniform)
    xk_new = Regularization(xk_new, Sk, N);                 % Regularization
else
    xk_new = Xki;
    wk_new = wk_pred;
end




end