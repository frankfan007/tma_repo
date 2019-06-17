%%  Hasan Hüseyin Sönmez - 14.09.2018

% First Particle filter implementation for bearings-only tracking problem

clc; clearvars; close all;

load data.mat;
MC = 1;

for mc = 1:MC
    mc
    model           = InitParameters('Scenario3.mat');                  % initialize all parameters.
    
    model.K = length(pMilpas.bearing);
    model.B0 = pMilpas.bearing(1)*pi/180;
    %%  particle, weight, state initialization
    PFtracks        = struct([]);                                       % empty list
    for k = 2:model.K                                                   % total number of scans
        %     refresh
        k;
        zk = (pi/180)*pMilpas.bearing(k);                               % current measurement
        own = [pOwnship.X(k), pOwnship.Speed(k)*sind(pOwnship.Course(k)), pOwnship.Y(k), pOwnship.Speed(k)*cosd(pOwnship.Course(k))]';                    % previous ownship position (only)
        PFtracks = BootstrapPF(k, PFtracks, zk, own, model);            % apply particle filter
    end     % simulation
    
    PFResult(mc) = PFtracks;
end

PlotResult(PFtracks, pOwnship, pTargetGPS, MC)
% EvaluatePF(GTruth, PFResult, model, MC)


