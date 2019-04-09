%%  Hasan H�seyin S�nmez - 14.09.2018

% First Particle filter implementation for bearings-only tracking problem

clc; clearvars; close all;

% rng('default')
MC = 10;           % number of Monte Carlo runs

for mc = 1:MC
    mc
    model       = InitParameters;               % initialize all parameters.
    GTruth      = GenTruth(model);              % generate ground truth target and observer trajectory
    Measures(mc)    = GenMeas(GTruth, model);   % offline data generation
    
    %%  particle, weight, state initialization
    zk_1        = Measures(mc).Z{1};            % first measurement
    R           = 10000;                        % (meters) particle initial range
    Course      = pi + zk_1;                    % radians
    Speed       = 4;                            % knots
    own         = GTruth.Ownship(:,1);
    
    Xki     = initParticles(R, Course, Speed, own, zk_1, model.N, model);     % initial particles
    Wki     = ones(model.N,1)/model.N;              % initial, uniform weights
    %%  output variable initialization
    Result(mc).X    = cell(model.K, 1);             % estimated state variable  
    Result(mc).X{1} = Xki*Wki;                      % initial target state
    Result(mc).P{1} = Xki*Xki'./model.N;            % initial state covariance
    Result(mc).Particles{1} = Xki; 
    
    zvec(:,1) = zk_1;
    for k = 2:model.K       % total number of scans
        %     refresh;
        zk = Measures(mc).Z{k};                         % current measurement
        zvec(:,k) = zk;
        own = GTruth.Ownship(:,k);                  % previous ownship state
        Uk = 0;                                     % control input, not used for now
        [xhat, xk_new, wk_new] = BootstrapPF(Xki, Wki,zk, Uk, own, model);
        
        %% update variables for next cycle
        Xki     = xk_new;
        zk_1    = zk;
        
        %%  collect the estimation results
        P   = (xk_new-xhat)*(xk_new-xhat)'./(model.N);          % estimation covariance
        Result(mc).X{k} = xhat;                                 % corresponds to sum(xk*wk)
        Result(mc).P{k} = P;                                    % estimated state covariance
        Result(mc).Particles{k} = Xki;                          % save particles if necessary
        
    end     % simulation
    
end

% save('sim1.mat','Result','GTruth','Measures','model')
% PlotResult(Result(mc), GTruth)
