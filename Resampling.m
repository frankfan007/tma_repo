%%  Hasan Hüseyin Sönmez - 27.09.2018
%   Resampling function


function xk_new = Resampling(xki, wk_pred, model)

Ns = model.N;       % number of particles

% resampling with replacement
% idx = randsample(length(wk_pred), Ns, true, wk_pred);   % uniform resampling w.r.t. normalized weights.
% xk_new  = xki(:,idx);                                   % updated particles

% systematic resampling
xk_new = Systematic(xki, wk_pred, Ns);

end