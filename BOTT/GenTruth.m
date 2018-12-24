%%  Hasan H�seyin S�nmez - 29.09.2018
%   Generate Ground truth data

%%  Input   :
%               model   : the model parameters for ground truth data.
%%  Output  :
%               GTData  : ground truth data of target states/trajectory

function GTruth = GenTruth(model)

K = model.K;                                % number of scans

GTruth.X            = cell(K,1);            % ground truth target states
GTruth.Ownship      = zeros(model.xDim, K); % ownship trajectory

%%  target initial state(s)
obs_pos_init = [0 0]';              % x and y
obs_vel_init = [2.57 140]';         % speed (m/s) and course (deg)
oinit(1) = obs_pos_init(1);
oinit(2) = obs_vel_init(1)*sin(obs_vel_init(2)*pi/180);
oinit(3) = obs_pos_init(2);
oinit(4) = obs_vel_init(1)*cos(obs_vel_init(2)*pi/180);
oinit = oinit';

x_init_range    = 5e3;                  % initial range to ownship
x_init_speed    = 2.058;                % initial speed (m/s)
x_init_course   = -140;                 % target course
x_init_bear     = 80;                   % initial target bearing to ownship
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

for tnum = 1:nbirths    % for each target
    targetstate = xinit(:,tnum);        % target initial state
    ownstate = oinit;
    for k = tbirth(tnum)+1:min(tdeath(tnum),K)
        targetstate = MarkovTransition(targetstate, model, false);      % transition of the state
        if k >= model.manStart && k <= model.manEnd
            % coordinated turn leg
            ownstate = MarkovTransition(ownstate, model, false, 'CT');  % noiseless state transition
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