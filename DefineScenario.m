%%  Scenario Definitions

Sname = 'scenario_3.mat';

model.dT        = 1;
model.K         = 900/model.dT;

% %%  Target definition
model.knots     = 0.5144;               % knots to m/s
model.kyd2m     = 914.4;                % kyd to meters
model.xRange    = 7*model.kyd2m;        % target initial range (meters)
model.xSpeed    = 15*model.knots;       % initial speed
model.xCourse   = 255;
model.B0        = 45;                  % initial bearing
% 
% %%  Observer definition
model.oSpeed    = 4.5*model.knots;
model.oCourse   = 30;
% 
% %%  Observer parameters
model.TurnRate  = 1;                    % deg/s
model.manStart  = [300/model.dT];               % starting time of ownship maneuver

model.TurnTo    = [305];
model.turnAmount = [model.TurnTo(1) - model.oCourse ];
model.manEnd    = model.manStart + abs(model.turnAmount/model.TurnRate)/model.dT;               % ending time of ownship maneuver


save(Sname, 'model')