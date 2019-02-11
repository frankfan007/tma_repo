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
    m_init      = [5100; -1.5; 500; -1.5];%GTruth.X{1};%model.m_init(zk_1);
    own         = GTruth.Ownship(:,1);
    
    Xki     = initParticles(m_init, model.P_init, own, model.N, model);
    Wki     = ones(model.N,1)/model.N;              % initial, uniform weights
    %%  output variable initialization
    Result(mc).X    = cell(model.K, 1);             % estimated state variable  
    Result(mc).X{1} = Xki*Wki;                      % initial target state
    Result(mc).P{1} = Xki*Xki'./model.N;            % initial state covariance
    
    zvec(1) = zk_1;
    for k = 1:model.K       % total number of scans
        %     refresh;
        zk = Measures.Z{k};                                 % current measurement
        zvec(k) = zk;
        own = GTruth.Ownship(:,k);                        % previous ownship state
        if k < model.K
            Uk = model.S(GTruth.Ownship(:,k+1), own);             % control input
        else
            Uk = 0;
        end
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
            scatter(GTruth.X{k}(1,:),GTruth.X{k}(3,:),200,'bx')   % ground truth position of the target
            scatter(xhat(1,:),xhat(3,:),200,'xr')
        else
            scatter(GTruth.X{k}(1,:),GTruth.X{k}(3,:),200,'b.')   % ground truth position of the target
            scatter(xhat(1,:),xhat(3,:),200,'.r')
        end
        hold on
        
%             scatter(xhat(1,:),xhat(3,:),200,'xr')                           % scatter particles on the ground truth
%             scatter(Xki(1,:),Xki(3,:),'g.')
%         scatter(Result.X{k}(1,:),Result.X{k}(3,:),'filled','or')    % estimation result
        
    end     % simulation
    plot(GTruth.Ownship(1,:), GTruth.Ownship(3,:),'k-')
    legend('Ground Truth', 'Ownship')
end

% figure, plot(zvec)

