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

%%  target initial state(s)
xinit = cat(2,[8000; 3.6*sin(-130*pi/180); 0; 3.6*cos(-130*pi/180)]);
oinit = [0; 2.57*sin(140*pi/180); 0; 2.57*cos(140*pi/180)];       % 5 knots, 140 deg

%   birth and death times of each target
nbirths     = 1;       % number of total targets
tbirth(:)   = 1;       % birth times of each target
tdeath(:)   = K;    % death times of each target

for tnum = 1:nbirths   % for each target
    targetstate = xinit(:,tnum);        % target initial state
    ownstate = oinit;
    for k = tbirth(tnum):min(tdeath(tnum),K)
        targetstate = MarkovTransition(targetstate, model, false);      % transition of the state
        if k < K/2
            ownstate = MarkovTransition(ownstate, model, false);        % noiseless state transition
        else
            % bodoslama leg üretimi...
            ownstate =[ownstate(1); 2.57*sin(20*pi/180); ownstate(3); 2.57*cos(20*pi/180)];
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