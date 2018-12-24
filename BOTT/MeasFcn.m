%%  Hasan Hüseyin Sönmez - 17.09.2018
%   generating/selecting mesurement model
%   measurement model can be linear (a matrix) or non-linear (a function)

%%   possible choices:
%           * bearings measurements,
%           * cartesian measurements

function Zk = MeasFcn(Xk, ModelParams, IsNoisy)


ProblemDim  = ModelParams.PDim;         % problem dimension 2-D or 3-D cartesian
sigma_w     = ModelParams.sigma_w;      % measurement noise std
wDim        = ModelParams.wDim;         % measurement noise dimension


switch ProblemDim
    case 3
        %% Do be defined...
    case 2
        % four-quadrant inverse tangent, Zk in (-pi,pi)
        if ModelParams.zDim == 1
            h = @(x) atan2(x(1,:),x(3,:));
        elseif ModelParams.zDim == 2
            h = @(x) [atan2(x(1,:),x(3,:)); sqrt(x(1,:).^2 + x(3,:).^2) ];
        end
end
z = h(Xk);        % transformed measurements
if IsNoisy
    Zk = z + sigma_w*randn(wDim, 1);
else
    Zk = z;
end
%% ------------------------
% revise...
% if Zk <= -pi
%     Zk = 2*pi + Zk;
% elseif Zk > pi
%     Zk = Zk - 2*pi;
% else
%     Zk = Zk;
% end
% -------------------------


end