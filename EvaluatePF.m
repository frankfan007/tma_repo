function EvaluatePF(pOwnship, pTargetGPS, Result, model, MC)


Cgt = atan2d(pTargetGPS.X(2)-pTargetGPS.X(1) , pTargetGPS.Y(2)-pTargetGPS.Y(1)) ;
XGrT = [pTargetGPS.X(1:model.K)'; pTargetGPS.S(1:model.K)'.*sind(Cgt); ...
        pTargetGPS.Y(1:model.K)'; pTargetGPS.S(1:model.K)'.*cosd(Cgt)];

Own  = [pOwnship.X(1:model.K)'; pOwnship.S(1:model.K)'.*sind(pOwnship.C(1:model.K)');...
        pOwnship.Y(1:model.K)'; pOwnship.S(1:model.K)'.*cosd(pOwnship.C(1:model.K)')];

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
TrueCourse  = atan2d(XGrT(2,:),XGrT(4,:));
Cmargins    = [TrueCourse-2; TrueCourse+2];                         % +,- 1 deg

%% plotting
figure,
subplot 311, title('Range'), plot(TrueRange),  hold on, plot(Rmargins(1,:),'k--'), plot(Rmargins(2,:),'k--'),
plot(mean(EstiRange,1),'r'), legend('True Range', 'Range Margins 10%', 'Estimated Range'), hold off
subplot 312, title('Speed'), plot(TrueSpeed),  hold on, plot(Smargins(1,:),'k--'), plot(Smargins(2,:),'k--'),
plot(mean(EstiSpeed,1),'r'), legend('True Speed', 'Speed Margins +,-1', 'Estimated Speed'), hold off
subplot 313, title('Course'), plot(TrueCourse), hold on, plot(Cmargins(1,:),'k--'), plot(Cmargins(2,:),'k--'),
plot(mean(EstCourse,1),'r'), legend('True Course', 'Range Margins +,- 2^o', 'Estimated Course'), ylim([TrueCourse(1)-10 TrueCourse(1)+10])
hold off


%%  RMS Errors
figure,
subplot 411, plot(RMSE(1,:)), title('Position Error - X')
subplot 412, plot(RMSE(3,:)), title('Position Error - Y')
subplot 413, plot(RMSE(2,:)), title('Velocity Error - X')
subplot 414, plot(RMSE(4,:)), title('Velocity Error - Y')

PlotResult(Result, pOwnship, pTargetGPS, MC)

%% Monte Carlo results
Rstd = std(EstiRange);
Cstd = std(EstCourse);
Sstd = std(EstiSpeed);

figure,
subplot 311, plot(Rstd), title('Range std')
subplot 312, plot(Cstd), title('Course std')
subplot 313, plot(Sstd), title('Speed std')


for i = 1:size(EstiRange,2)
    Rsuccess_idx(i) = length(find(Rmargins(1,i) <= EstiRange(:,i) & Rmargins(2,i) >= EstiRange(:,i)));
    Csuccess_idx(i) = length(find(Cmargins(1,i) <= EstCourse(:,i) & Cmargins(2,i) >= EstCourse(:,i)));
    Ssuccess_idx(i) = length(find(Smargins(1,i) <= EstiSpeed(:,i) & Smargins(2,i) >= EstiSpeed(:,i)));
end

figure
subplot 311, plot(Rsuccess_idx), title('#of runs in Range margins')
subplot 312, plot(Csuccess_idx), title('#of runs in Course margins')
subplot 313, plot(Ssuccess_idx), title('#of runs in Speed margins')


end