%%  Hasan Hüseyin Sönmez - 14.09.2018

% First Particle filter implementation for bearings-only tracking problem

clc; clearvars;

% rng('default')
% s = rng(1,'twister');
% rng(s)
MC = 1;           % number of Monte Carlo runs

model           = InitParameters('september_data/scenario_12.mat');                  % initialize all parameters.
tic
for mc = 1:MC
    mc
    
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
toc

close all;

EvaluatePF(GTruth, PFResult, model, MC)
% save('september_data/Result_S12_full.mat','PFResult', 'model', 'GTruth', 'Measures')

