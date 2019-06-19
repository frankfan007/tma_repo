function EvaluatePF(pOwnship, pTargetGPS, Result, model, MC)

XGrT = [pTargetGPS.X; pTargetGPS.Speed.*sind(pTargetGPS.Course); ...
        pTargetGPS.Y; pTargetGPS.Speed.*cosd(pTargetGPS.Course)];

Own  = [pOwnship.X; pOwnship.Speed.*sind(pOwnship.Course);...
        pOwnship.Y; pOwnship.Speed.*cosd(pOwnship.Course)];

for mc = 1:MC
%     XGrT = cell2mat(GTruth.X');                 % GT target states
%     Own = GTruth.Ownship;                       % ownship states
    Xest = cell2mat(Result(mc).X');             % estimated target states
    EstiRange(mc,:) = sqrt(sum((Xest([1,3],:) - Own([1,3],:)).^2,1));
    EstiSpeed(mc,:) = sqrt(sum(Xest([2,4],:).^2,1));
    EstCourse(mc,:) = atan2d(Xest(2,:),Xest(4,:));
    
    SqError(:,:,mc) = (XGrT-Xest).^2;
end

RMSE = sqrt(mean(SqError,3));

TrueRange   = sqrt(sum((XGrT([1,3],:) - Own([1,3],:)).^2,1));
Rmargins    = [TrueRange-.1*TrueRange; TrueRange+.1*TrueRange];     % +,- 10%
TrueSpeed   = sqrt(sum(XGrT([2,4],:).^2,1));            
Smargins    = [TrueSpeed-.1*TrueSpeed; TrueSpeed+.1*TrueSpeed];     % +,- 10%
TrueCourse  = model.xCourse*ones(1,model.K);
Cmargins    = [TrueCourse-2; TrueCourse+2];                         % +,- 1 deg


% idx = find(EstCourse<0);
% EstCourse(idx) = EstCourse(idx)+360;



%% plotting
figure,
subplot 311, title('Range'), plot(TrueRange),  hold on, plot(Rmargins(1,:),'k--'), plot(Rmargins(2,:),'k--'),
plot(mean(EstiRange,1),'r'), legend('True Range', 'Range Margins 10%', 'Estimated Range'), hold off
subplot 312, title('Speed'), plot(TrueSpeed),  hold on, plot(Smargins(1,:),'k--'), plot(Smargins(2,:),'k--'),
plot(mean(EstiSpeed,1),'r'), legend('True Speed', 'Speed Margins +,-1', 'Estimated Speed'), hold off
subplot 313, title('Course'), plot(TrueCourse), hold on, plot(Cmargins(1,:),'k--'), plot(Cmargins(2,:),'k--'),
plot(mean(EstCourse,1),'r'), legend('True Course', 'Range Margins +,- 2^o', 'Estimated Course'), ylim([model.xCourse-10 model.xCourse+10])
hold off


%%  RMS Errors
figure,
subplot 411, plot(RMSE(1,:)), title('Position Error - X')
subplot 412, plot(RMSE(3,:)), title('Position Error - Y')
subplot 413, plot(RMSE(2,:)), title('Velocity Error - X')
subplot 414, plot(RMSE(4,:)), title('Velocity Error - Y')

PlotResult(Result, pOwnship, pTargetGPS, MC)
