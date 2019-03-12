clc; clearvars; close all;

%%  performance evaluation script
load('sim1.mat')

MC      = length(Result);
Xtruth  = cell2mat(GTruth.X');               % true target states
Own     = GTruth.Ownship;                   % ownship states
Theta   = cell2mat(Measures(1).Theta);      % true bearings

for mc = 1:MC
    Xhat = cell2mat(Result(mc).X');
    Phat = reshape(cell2mat(Result(mc).P'),[4,4,60]);
    Error = Xhat - Xtruth;
    for i = 1:model.K
        NEES(mc,i) = Error(:,i)'*inv(Phat(:,:,i))*Error(:,i)/model.K;
    end
end

ANEES = sum(NEES,1)/MC;
LogANEES = log(ANEES);

figure,
subplot(211), plot(ANEES)
% subplot(212), plot(LogANEES)