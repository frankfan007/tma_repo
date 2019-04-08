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

Ns      = size(xk_prev,2);                              % number of particles

% Initialization for the regularized particle filter. 
% d = model.xDim; % dimension of the state vector 
% c = 4; % volume of unit hypersphere in d-dimensional space 
% h = (8 * c^(-1) * (d + 4) * (2 * sqrt(pi))^d)^(1 / (d + 4)) * Ns^(-1 / (d + 4)); % bandwidth of regularized filter 

%%  prediction
Xki     = SampleParticles(xk_prev, Uk, model);          % predicted particles
Wki     = SampleWeights(Xki, wk_prev, zk, own, model);  % predicted weights
wk_pred = Wki/sum(Wki);                                 % normalized weights

xhat    = Xki*wk_pred;

%% resampling (should be another function)- implement alternative resampling strategies
Neff = 1/(sum(wk_pred.^2)+eps)
if isnan(Neff)
    wk_pred = ones(1,Ns)/Ns;
end
% Neff = -sum(wk_pred.*log(wk_pred)./log(Ns));             % entropy of weights
if Neff <= model.Nthr || isnan(Neff)
    %%  Regularization step
    %   first calculate the empirical covariance
%     Sk = (Xki-xhat)*(Xki-xhat)'./Ns;            % estimation covariance
%     Dk = chol(Sk,'lower');                      % factorize the covariance matrix
    
    %% update
    xk_new = Resampling(Xki, wk_pred, model);               % updated particles
    wk_new = ones(1,Ns)/Ns;                                 % new particles (uniform)
    
%     x_dom(:,1) = min(Xki,[],2) - std(Xki,0,2);
%     x_dom(:,Ns) = max(Xki,[],2) + std(Xki,0,2);
%     dx = (x_dom(:,Ns) - x_dom(:,1)) / (Ns - 1); 
%     for i = 2 : Ns - 1 
%         x_dom(:,i) = x_dom(:,i-1) + dx; 
%     end
%     x = inv(Dk)*(x_dom-Xki);
%     Kopt = 
else
    xk_new = Xki;
    wk_new = wk_pred;
end




end