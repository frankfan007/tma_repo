%%  Hasan Hüseyin Sönmez - 27.09.2018
%   Sampling weights from the likelihood
%   or different sampling strategies

%%  Inputs:
%               xki     : current particles
%               zk      : current measurements
%               model   : model parameters
%

function Wki = SampleWeights(xki, wk_prev, zk, model)

wki = computeLikelihood(zk, xki, model)+eps;	% likelihood value as the predicted weight
Wki = wki.*wk_prev/sum(wki);                    % normalized weights


end