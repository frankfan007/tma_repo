%%  Hasan Hüseyin Sönmez - 27.09.2018
%   Resampling function


function [xk_new, wk_new] = Resampling(xki, wk_pred, model)

Ns = model.N;       % number of particles
wk_new = ones(Ns,1)/Ns;                                   % new particles (uniform)

%% Greedy Approach
% tau = .8;           % 0 < tau < 1
% xk_new = GreedyApproach(xki, wk_pred, tau, Ns);

%% MSV approach (deterministic)
% xk_new = MSVresampling(xki, wk_pred, Ns);

% resampling with replacement (Multinomial)
% idx = randsample(length(wk_pred), Ns, true, wk_pred);   % uniform resampling w.r.t. normalized weights.
% xk_new  = xki(:,idx);                                   % updated particles

% systematic resampling
xk_new = Systematic(xki, wk_pred, Ns);

end