%%  Hasan Hüseyin Sönmez - 27.09.2018
%   Sampling weights from the likelihood
%   or different sampling strategies

%%  Inputs:
%               xki     : current particles
%               zk      : current measurements
%               model   : model parameters
%

function Wki = SampleWeights(xki, wki_prev, zk, model)

Likelihood  = computeLikelihood(zk, xki, model)'+eps;        % likelihood value as the predicted weight
Wki_tilde   = Likelihood.*wki_prev;
Wki         = Wki_tilde/sum(Wki_tilde);                     % normalized weights


end