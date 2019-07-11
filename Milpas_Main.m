%%  Hasan Hüseyin Sönmez - 14.09.2018

% First Particle filter implementation for bearings-only tracking problem

clc; clearvars; 
% rng('default')

load Senaryo1Kosum1_M.mat;
MC = 1;

for mc = 1:MC
    mc
    model           = InitParameters('Scenario3.mat');                  % initialize all parameters.
    
    model.K = length(pMilpas.bearing)-200;
    model.B0 = pMilpas.bearing(1);
    
    %%  particle, weight, state initialization
    PFtracks        = struct([]);                                       % empty list
    for k = 2:model.K                                                   % total number of scans
        %     refresh
        k;
        zk = (pi/180)*pMilpas.bearing(k);                               % current measurement
        own = [pOwnship.X(k), pOwnship.S(k)*sind(pOwnship.C(k)), pOwnship.Y(k), pOwnship.S(k)*cosd(pOwnship.C(k))]';                    % previous ownship position (only)
        PFtracks = BootstrapPF(k, PFtracks, zk, own, model);            % apply particle filter
    end     % simulation
    
    PFResult(mc) = PFtracks;
end

close all;
% PlotResult(PFResult, pOwnship, pTargetGPS, MC)
EvaluatePF(pOwnship, pTargetGPS, PFResult, model, MC)


