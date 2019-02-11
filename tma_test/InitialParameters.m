function param=InitialParameters
km2m=1000;
%time
param.dt=10; %sec
param.totaltime=3000; %sec
param.NS=param.totaltime/param.dt;  

%%  Own
% Initial Own Pos
param.ownX=0; %m
param.ownY=0; %m
% Course
param.ownCourse=0; %degree
param.ownManevTime=[310;param.totaltime];  %sec
param.ownturnRate=2; %degree/sec
%Speed
param.ownSpeed=3;  %m/s
param.ownSpeedManevTime=[480;param.totaltime];  %sec
param.ownAccelaration=2;
% bad sector
param.ownArea=[120;-120]; 

%% Target
%Initial Target Pos
param.tarX=49.49*km2m; %m
param.tarY=49.49*km2m; %m
% Course 
param.tarCourse=240;  %degree
param.tarManevTime= [240;480;param.totaltime];  %sec
param.tarTurnRate=[2;2];%degree/sec
% Speed
param.tarSpeed=5;  %m/s
param.tarSpeedManevTime= [540;param.totaltime];  %sec
param.tarAccelaration=[2;2]; %m/sec^2
%random bozulacak data sayýsý
param.Num_Data=50; 
%Speed Noise
param.SpeedNoise_var=1;

%% Measurement Par
param.sigmaR=50; %m
param.sigmaphi=1.5; %degree
param.MonteCarlo=100; %monte carlo 
param.Quantization_Interval=1; %degree 
param.sigma_v=0.01; %m/s^2
param.Q=param.sigma_v^2*kron(eye(2),[(param.dt^4)/4 (param.dt^3)/2; (param.dt^3)/2 param.dt^2]); %white noise acceleration
%parallax
param.parallax=0; %parallax etkisi
param.deltax=0; %m
end