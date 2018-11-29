%%  Hasan Hüseyin Sönmez - 14.09.2018

% First RFS based filter implementation.

clc; clearvars; close all;

% rng('default')
MC = 100;           % number of Monte Carlo runs

for mc = 1:MC        % monte carlo simulations
    
    model       = InitParameters;               % initialize all parameters.
    GTruth      = GenTruth(model);              % generate ground truth target and observer trajectory
    Measures    = GenMeas(GTruth, model);       % offline data generation
    
    %%  particle, weight, state initialization
    zk_1    = Measures.Z{1};                % first measurement
    q_prev  = .1;                           % initial prob. of existence
    Wki     = ones(model.N,1)/model.N;      % initial, uniform weights
    model.m_init  = [zk_1(2)*sin(zk_1(1)) 0 zk_1(2)*cos(zk_1(1)) 0]';
    model.P_init  = diag([10000 4 10000 4]').^2;
    own = GTruth.Ownship(:,1);
    Xki = initParticles(model.m_init, model.P_init, own, model.N, model);
    
    %%  output variable initialization
    Result(mc).X = cell(model.K, 1);            % estimated state variable
    
    Result(mc).X{1} = Xki*Wki;                  % initial target state
    Result(mc).P{1} = Xki*Xki'./model.N;        % initial state covariance
    
    for k = 2:model.K       % total number of scans
        %     refresh;
        zk = Measures.Z{k};                                 % current measurement
        own = GTruth.Ownship(:,k);                          % new ownship state
        [xk_new, wk_new] = BootstrapPF(Xki, zk, model);
        
        %% update variables for next cycle
        Xki     = xk_new;
        zk_1    = zk;
        
        %%  collect the estimation results
        P   = xk_new*xk_new'./(model.N-1);                      % estimation covariance
        Result(mc).X{k} = xk_new*ones(model.N,1)/model.N;       % corresponds to sum(xk*wk)
        Result(mc).P{k} = P;                                    % estimated state covariance
        
        %%  plot
        %         scatter(GTruth.X{k}(1,:),GTruth.X{k}(3,:),'filled','bd')   % ground truth position of the target
        %         hold on
        %         %     scatter(xk_new(1,:),xk_new(3,:),'.r')                           % scatter particles on the ground truth
        %         scatter(Result.X{k}(1,:),Result.X{k}(3,:),'filled','ok')    % estimation result
        %         legend('Ground Truth', 'Estimation')
    end     % simulation
    
    
end     % monte carlo run

% for mc = 1:100
%     error               = GTruth.X{k} - Result(mc).X{k};
%     Result(mc).NEES(k)  = error'*pinv(P)*error;
%     NEES(mc,:)          = Result(mc).NEES(2:end);
% end
% ANEES       = mean(NEES,1);                       % average NEES
% stdOfNEES   = std(NEES,1);
% figure, plot(ANEES), title('ANEES of 100 Monte Carlo Runs')
% 
% hold on
% plot(ones(1,model.K),'--k')





