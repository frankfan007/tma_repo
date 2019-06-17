%%  Hasan Hüseyin Sönmez - 27.09.2018
%   Sampling weights from the likelihood
%   or different sampling strategies

%%  Inputs:
%               xki     : current particles
%               zk      : current measurements
%               model   : model parameters
%

function [Wki, Likelihood] = SampleWeights(xki, wki_prev, zk, own, model)

Likelihood  = computeLikelihood(zk, xki, own, model)'+eps;        % likelihood value as the predicted weight
Wki         = Likelihood.*wki_prev;


end