%%  Hasan Hüseyin Sönmez - 14.09.2018

% First Particle filter implementation for bearings-only tracking problem

clc; clearvars; close all;

% rng('default')
% s = rng(1,'twister');
% rng(s)
MC = 1;           % number of Monte Carlo runs

for mc = 1:MC
    mc
    model           = InitParameters('Scenario3.mat');                  % initialize all parameters.
    GTruth          = GenTruth(model);                                  % generate ground truth target and observer trajectory
    Measures(mc)    = GenMeas(GTruth, model);                           % offline data generation
    
    %%  particle, weight, state initialization
    own             = GTruth.Ownship(:,1);
    PFResult        = initializeFilter(model, own);
    for k = 2:model.K                                                   % total number of scans
        %     refresh;
        k
        zk = Measures(mc).Z{k};                                         % current measurement
        own = GTruth.Ownship(:,k);                                      % previous ownship state
        PFResult = BootstrapPF(k, PFResult, zk, own, model);            % apply particle filter
    end     % simulation
    
end

% PlotResult(PFResult, GTruth, MC)
EvaluatePF(GTruth, PFResult, model, MC)


