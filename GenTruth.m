%%  Hasan Hüseyin Sönmez - 29.09.2018
%   Generate Ground truth data

%%  Input   :
%               model   : the model parameters for ground truth data.
%%  Output  :
%               GTData  : ground truth data of target states/trajectory

function GTruth = GenTruth(model)

K = model.K;                                % number of scans

GTruth.X            = cell(K,1);            % ground truth target states
GTruth.Ownship      = zeros(model.xDim, K); % ownship trajectory

%%  observer initial state
obs_pos_init = [0 0]';              % x and y
obs_vel_init = [model.oSpeed model.oCourse]';         % speed (m/s) and course (deg)
oinit(1) = obs_pos_init(1);
oinit(2) = obs_vel_init(1)*sin(obs_vel_init(2)*pi/180);
oinit(3) = obs_pos_init(2);
oinit(4) = obs_vel_init(1)*cos(obs_vel_init(2)*pi/180);
oinit = oinit';

%%  target initial state(s)
x_init_range    = model.xRange;                     % initial range to ownship
x_init_speed    = model.xSpeed;                     % initial speed (m/s)
x_init_course   = model.xCourse;                    % target course
x_init_bear     = model.B0;                         % initial target bearing to ownship
xinit(1) = x_init_range*sin(x_init_bear*pi/180) + oinit(1);
xinit(2) = x_init_speed*sin(x_init_course*pi/180);
xinit(3) = x_init_range*cos(x_init_bear*pi/180) + oinit(3);
xinit(4) = x_init_speed*cos(x_init_course*pi/180);
xinit = xinit';

%   birth and death times of each target
nbirths     = 1;        % number of total targets
tbirth(:)   = 1;        % birth times of each target
tdeath(:)   = K;        % death times of each target

GTruth.Ownship(:,1) = oinit;
GTruth.X{1}         = xinit;

manCourse = model.TurnTo;               % maneuver to this course
for tnum = 1:nbirths    % for each target
    targetstate = xinit(:,tnum);        % target initial state
    ownstate = oinit;
    i = 1;
    for k = tbirth(tnum)+1:min(tdeath(tnum),K)
        targetstate = MarkovTransition(targetstate, model, false);      % transition of the state
        %% observer maneuver
        if k >= model.manStart(i) && k <= model.manEnd(i)
%             TotalTurn = model.TurnTo - model.oCourse;
%             model.obs_w = (TotalTurn/((model.manEnd(i)-model.manStart(i))))*pi/180;
            ownstate =[ownstate(1); model.oSpeed*sin(manCourse*pi/180); ownstate(3); model.oSpeed*cos(manCourse*pi/180)];
            % coordinated turn leg
            ownstate = MarkovTransition(ownstate, model, false);  % noiseless state transition
            if k == model.manEnd(i) && i < length(model.manStart)
                i = i + 1;
            end
        else
%             ownstate =[ownstate(1); 2.57*sin(20*pi/180); ownstate(3); 2.57*cos(20*pi/180)];
            ownstate = MarkovTransition(ownstate, model, false);
        end
        GTruth.Ownship(:,k) = ownstate;
        GTruth.X{k} = [GTruth.X{k}, targetstate];
    end
end

%% keep them for measurement generation
GTruth.TotalTracks = nbirths;
GTruth.tbirth = tbirth;
GTruth.tdeath = tdeath;

end