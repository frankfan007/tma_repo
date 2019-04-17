%%  Hasan Hüseyin Sönmez - 14.09.2018

% First Particle filter implementation for bearings-only tracking problem

clc; clearvars; close all;

% rng('default')
% s = rng(1,'twister');
% rng(s)
MC = 1;           % number of Monte Carlo runs

for mc = 1:MC
    mc
    model           = InitParameters('Scenario1.mat');                  % initialize all parameters.
    GTruth          = GenTruth(model);                                  % generate ground truth target and observer trajectory
    Measures(mc)    = GenMeas(GTruth, model);                           % offline data generation
    
    %%  particle, weight, state initialization
    PFtracks        = struct([]);                                       % empty list
    for k = 2:model.K                                                   % total number of scans
        %     refresh;
        k;
        zk = Measures(mc).Z{k};                                         % current measurement
        own = GTruth.Ownship(:,k);                                      % previous ownship position (only)
        PFtracks = BootstrapPF(k, PFtracks, zk, own, model);            % apply particle filter
    end     % simulation
    
    PFResult(mc) = PFtracks;
end

% PlotResult(PFResult, GTruth, MC)
EvaluatePF(GTruth, PFResult, model, MC)


