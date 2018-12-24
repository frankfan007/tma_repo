%%  Hasan Hüseyin Sönmez - 14.09.2018

% First Particle filter implementation for bearings-only tracking problem

clc; clearvars; close all;

% rng('default')
MC = 1;           % number of Monte Carlo runs

for mc = 1:MC
    
    model       = InitParameters;               % initialize all parameters.
    GTruth      = GenTruth(model);              % generate ground truth target and observer trajectory
    Measures    = GenMeas(GTruth, model);       % offline data generation
    
    %%  particle, weight, state initialization
    zk_1        = Measures.Z{1};                % first measurement
    m_init  = model.m_init(zk_1);
%     model.P_init  = diag([4000 2 4000 2]').^2;
    own = GTruth.Ownship(:,1);
    
    Xki = initParticles(m_init, model.P_init, own, model.N, model);
    Wki  = ones(model.N,1)/model.N;             % initial, uniform weights
    %%  output variable initialization
    Result(mc).X = cell(model.K, 1);            % estimated state variable  
    Result(mc).X{1} = Xki*Wki;                  % initial target state
    Result(mc).P{1} = Xki*Xki'./model.N;        % initial state covariance
    
    zvec(1) = zk_1;
    for k = 2:model.K       % total number of scans
        %     refresh;
        zk = Measures.Z{k};                                 % current measurement
        zvec(k) = zk;
        own = GTruth.Ownship(:,k-1);                        % previous ownship state
        Uk = model.S(own, GTruth.Ownship(:,k));             % control input
        [xhat, xk_new, wk_new] = BootstrapPF(Xki, Wki,zk, Uk, model);
        
        %% update variables for next cycle
        Xki     = xk_new;
        zk_1    = zk;
        
        %%  collect the estimation results
        P   = xk_new*xk_new'./(model.N-1);                      % estimation covariance
        Result(mc).X{k} = xhat;                                 % corresponds to sum(xk*wk)
        Result(mc).P{k} = P;                                    % estimated state covariance
        
        %%  plot
        if k == model.K
            scatter(GTruth.X{k}(1,:),GTruth.X{k}(3,:),'bx')   % ground truth position of the target
        else
            scatter(GTruth.X{k}(1,:),GTruth.X{k}(3,:),'b.')   % ground truth position of the target
        end
        hold on
        
            scatter(xhat(1,:),xhat(3,:),'.r')                           % scatter particles on the ground truth
%         scatter(Result.X{k}(1,:),Result.X{k}(3,:),'filled','or')    % estimation result
        
    end     % simulation
    plot(GTruth.Ownship(1,:), GTruth.Ownship(3,:),'k-')
    legend('Ground Truth', 'Ownship')
end

% figure, plot(zvec)

