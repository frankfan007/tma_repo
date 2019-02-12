%%  Hasan Hüseyin Sönmez - 17.09.2018
%   parameter file
%   target state x:= [x vx y vz]'


function model = InitParameters

model.dT        = 60;           % sampling interval (can be changed for asynchronous case)
model.K         = 30;           % number of scans
model.Motion    = 'CV';         % motion model 'CT','CA','CV'
model.xDim      = 4;            % state vector dimension is specified according to motion model
                                % 4: 2-D CV, 6: 2-D CA, 6: 3-D CV, 
                                % 9: 3-D CA, 5: 2-D CT
model.zDim      = 1;            % measurement vector dimension is specified according to the measurement model.
                                % 1: Bearings, 2: 2-D, 3: 3-D problems
model.PDim      = 2;            % problem dimension: 2-D or 3-D
model.vDim      = model.xDim;   % process noise vector size
model.wDim      = model.zDim;   % measurement noise vector size

%%  Noise parameters
model.sigma_w   = diag([1.5*pi/180]);                 % measurement noise std (in rad)
model.sigma_v   = 1e-6;                              % process noise intensity
model.Qk        = model.sigma_v*kron(eye(model.PDim),[(model.dT^3)/3 (model.dT^2)/2; (model.dT^2)/2 model.dT]);
model.R         = model.sigma_w*model.sigma_w';     % mesurement error covariance

%%  Target motion parameters:
model.sigma_vel = 5;            % velocity standard deviation
model.w_std     = 1*pi/180;     % for CT model
model.bt        = model.sigma_vel*[(model.dT^2)/2; model.dT];
model.B2        = [kron([eye(2), zeros(2,1)],model.bt); 0 0 model.w_std*model.dT];

%%  Particle Filter parameters
model.N         = 10000;         % number of particles
model.Nthr      = model.N*.3;    % resampling threshold

%%  initialization parameters
r_init    = 5e3;          % expected target range (meters)
model.stdtheta  = pi/sqrt(12);  % standard deviation of the range
model.stds      = 1.02;         % standard deviation of velocity components (m/s)

model.m_init    = @(theta1) [r_init*sin(theta1*pi/180); ...
                             1.02*sin(theta1*pi/180+pi);...
                             r_init*cos(theta1*pi/180); ...
                             1.02*cos(theta1*pi/180+pi)];
model.P_init    = diag([100 .5*sin(pi/sqrt(12)) 100 .5*cos(pi/sqrt(12))]).^2;

%%  Clutter parameters
model.range_cz  = [-pi/2, pi/2];    % clutter range
model.pdf_cz    = 1/prod(model.range_cz(:,2) - model.range_cz(:,1)); % clutter spatial distribution is uniform
model.Lambda    = 0;                % average clutter (will be varied)
model.pD        = 1;                % probability of detection (will be varied)-state dependent parameterization

%%  Observer parameters
model.manStart  = 13;               % starting index of ownship maneuver
model.manEnd    = 17;               % ending index of ownship maneuver
model.obs_w     = (120/300)*pi/180; % ownship turn rate
model.S = @(xOk, xOk_1) [   xOk(1) - xOk_1(1) - model.dT*xOk_1(2); ...
                            xOk(2) - xOk_1(2);
                            xOk(3) - xOk_1(3) - model.dT*xOk_1(4); ...
                            xOk(4) - xOk_1(4) ];

