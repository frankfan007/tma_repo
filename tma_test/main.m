clc;clear;
close all;

global FIELDNOTSET
FIELDNOTSET=-4.5678;

param=InitialParameters;
N=2; %karþýlaþtýrýlacak filtre sayýsý
%% 
% groundtruth Ownship parameters
[pOGth.X,pOGth.Y,pOGth.Course,pOGth.Speed,pOGth.Time]=motion(param.ownX,param.ownY,param.ownCourse,param.ownSpeed,param.NS,param.dt,param.ownManevTime,param.ownSpeedManevTime,param.ownturnRate,param.ownAccelaration);

% groundtruth Target parameters
[pTGth.X,pTGth.Y,pTGth.Course,pTGth.Speed,pTGth.time]=motion(param.tarX,param.tarY,param.tarCourse,param.tarSpeed,param.NS,param.dt,param.tarManevTime,param.tarSpeedManevTime,param.tarTurnRate,param.tarAccelaration); 

% [pTGth.Speed,pTGth.X,pTGth.Y]=speedNoise(pTGth,param); %with speed noise

%%  monte carlo simulations  
for k=1:1:param.MonteCarlo
    
    % measured range and bearing with noise
    [pTarget]=mea(pOGth,pTGth,param,FIELDNOTSET);  
    
    %data gelmemesi durumu
    %[pTarget.NoisyRange,pTarget.NoisyRelBearing]=data_corruption(pTarget.NoisyRange,pTarget.NoisyRelBearing,param,FIELDNOTSET);
    %zaman gecikmesi
    %[pTGth.time]=timedelay(pTarget,pOGth);
   % delta_filter=pTGth.time
    [pFilter(1).State(:,:,k),pFilter(1).Cov(:,:,:,k)]=Filter_CMKF(pTarget.NoisyRange,pTarget.NoisyRelBearing,param.NS,param.dt,param.sigmaR,param.sigmaphi,param.Q);
    
    [pFilter(2).State(:,:,k),pFilter(2).Cov(:,:,:,k)]=Filter_EKF(pTarget.NoisyRange,pTarget.NoisyRelBearing,param.NS,param.dt,param.sigmaR,param.sigmaphi,param.Q);

end

%% evaluation 
for n=1:N
    [Result(n).RMSE_pos,Result(n).RMSE_vel,Result(n).ANEES,Result(n).LNEES]=evaluation(pTGth,pOGth,pFilter(n),param);
    errorplot(Result(n));
end

  measurementplot(pOGth,pTGth,pTarget);