%%  Hasan H�seyin S�nmez - 04.10.2018
%   function implements the markov density
%   the Markov density has the density is f_v( x - f(x) ).

%%   Function inputs:
%                   * xk    : actual measurements
%                   * model : model parameters.
%                   * xki   : predicted particles.
%       Output: single target likelihood

function x_new = MarkovDensity(model, xki, varargin)

switch length(varargin)
    case 2
        Q   = varargin{1};
        Uk  = varargin{2};
    case 1
        Q   = model.Qk;
        Uk  = varargin{1};
    case 0
        Q   = model.Qk;
        Uk  = zeros(model.xDim, 1);
end
    
x_new = zeros(size(xki));
for i = 1:size(xki,2)
    xk_hat      = MarkovTransition(xki(:,i), model, true);     % predicted particle state, with noise, f(x)
    x_new(:,i)  = (xk_hat - Uk);
end


end