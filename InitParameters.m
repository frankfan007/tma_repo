%%  Hasan H�seyin S�nmez - 17.09.2018
%   parameter file
%   target state x:= [x vx y vz]'


function model = InitParameters(ScenarioFile)

load(ScenarioFile)

model.dT        = 1;           % sampling interval (can be changed for asynchronous case)
% model.K         = 90;           % number of scans
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
model.sigma_w   = diag([0.5*pi/180]);                   % measurement noise std (in rad)
model.sigma_v   = 6.4e-10;                              % process noise intensity
% model.Qk        = model.sigma_v*diag([50 .5 50 .5].^2);
model.Qk        = model.sigma_v*kron(eye(model.PDim),[(model.dT^3)/3 (model.dT^2)/2; (model.dT^2)/2 model.dT]);
model.R         = 1*model.sigma_w*model.sigma_w';      % mesurement error covariance

%%  Target motion parameters:
model.sigma_vel = 5;            % velocity standard deviation
model.w_std     = 1*pi/180;     % for CT model
model.bt        = model.sigma_vel*[(model.dT^2)/2; model.dT];
model.B2        = [kron([eye(2), zeros(2,1)],model.bt); 0 0 model.w_std*model.dT];

%%  Particle Filter parameters
model.N         = 3e3;          % number of particles
model.Nthr      = model.N*.1;    % resampling threshold

%%  initialization parameters
model.Rinit     = [100 25000];
model.Cinit     = [0 2*pi];
model.Sinit     = [5*model.knots 30*model.knots];
model.Binit     = [model.B0-3 model.B0+3];              % +-3 deg around initial bearing

%%  Clutter parameters
model.range_cz  = [-pi/2, pi/2];    % clutter range
model.pdf_cz    = 1/prod(model.range_cz(:,2) - model.range_cz(:,1)); % clutter spatial distribution is uniform
model.Lambda    = 0;                % average clutter (will be varied)
model.pD        = 1;                % probability of detection (will be varied)-state dependent parameterization

% %%  Target definition
% model.knots     = 0.5144;
% model.xRange    = 7000;                % target initial range (meters)
% model.xSpeed    = 15*model.knots;             % initial speed
% model.xCourse   = 90;
% model.B0        = 225;                  % initial bearing
% 
% %%  Observer definition
% model.oSpeed    = 6*model.knots;
% model.oCourse   = 180;
% 
% %%  Observer parameters
% model.manStart  = [15];               % starting index of ownship maneuver
% model.manEnd    = [16];               % ending index of ownship maneuver
% model.TurnTo    = [270];

