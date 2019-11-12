%%  Hasan Hüseyin Sönmez - 12.04.2019


%%  Input:
%           * k     : current time index
%           * Tracks: struct containing:
%                       * Particles,
%                       * Estimated state (weighted sum of particles)
%                       * Weights
%           * zk    : new measurements
%           * own   : current ownship state (4x1)
%           * model : struct for model and algorithm parameters
%%  Output:
%           * Tracks : struct updated with recent parameters


function Tracks = BootstrapPF(k, Tracks, zk, own, model)

if isempty(Tracks)
    %% initialization for first iteration
    Tracks = initializeFilter(model, own);
end

xk_prev     = Tracks.Particles{k-1};
wk_prev     = Tracks.Wk{k-1};
N           = model.N;                                          % number of particles
%%  prediction
Xki         = SampleParticles(xk_prev, model);                  % predicted particles
[Wki, ~]    = SampleWeights(Xki, wk_prev, zk, own, model);      % predicted weights
wk_pred     = Wki/sum(Wki);                                     % normalized weights

xhat        = Xki*wk_pred;
P           = wk_pred'.*(Xki-xhat)*(Xki-xhat)';                 % estimation covariance
%% resampling (should be another function)- implement alternative resampling strategies
Neff = 1/(sum(wk_pred.^2));
% Neff = -sum(wk_pred.*log(wk_pred)./log(Ns));             % entropy of weights

if Neff <= model.Nthr
    %% regularization
    Sk = wk_pred'.*(Xki-xhat)*(Xki-xhat)';
    %% update
    [xk_new, wk_new] = Resampling(Xki, wk_pred, model);     % updated particles
    xk_new = Regularization(xk_new, Sk, N);                 % Regularization
else
    xk_new = Xki;
    wk_new = wk_pred;
end

% zkhat = MeasFcn(xhat, own, model, true);
% Tracks.rk(k) = zk - zkhat;        % measurement residual

Tracks.X{k}         = xhat;
Tracks.Particles{k} = xk_new;
Tracks.Wk{k}        = wk_new;
Tracks.P{k}         = P;

end