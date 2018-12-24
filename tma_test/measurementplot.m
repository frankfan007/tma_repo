function measurementplot(pOGth,pTGth,pTarget)
figure
%ownship&target gth x-y postion
subplot(2,2,1);
label={'baþlangýç'};
plot(pOGth.X,pOGth.Y,'b*',pTGth.X,pTGth.Y,'r*');hold on;
text(pOGth.X(1),pOGth.Y(1),label);
text(pTGth.X(1),pTGth.Y(1),label);
title('Gth');
xlabel('X(m)');
ylabel('Y(m)');
legend('Own','Target');
axis equal

subplot(2,2,2);
plot(pTGth.time(2:end),pTarget.Absbearingrate(2:end)); %abs bearing rate
title('Abs Bearing Rate');
xlabel('Time(sec)');
ylabel('Bearing Rate(deg/sec)');
%Range Measuremen Plot
subplot(2,2,3);
plot(pTGth.time(2:end),pTarget.NoisyRange(2:end));
title('Range');
xlabel('Time(sec)');
ylabel('Range(m)');
%Relative Bearing Plot
subplot(2,2,4);
plot(pTGth.time,pTarget.RelBearingdegree,'b',pTGth.time,pTarget.QuantizedRelBearing,'k*',pTGth.time,pTarget.NoisyRelBearing,'r');
legend('Relative Bearing','Quantized Bearing','quantized+Noise');
title('Relative Bearing');
xlabel('Time(sec)');
ylabel('Relative Bearing(deg)');

% figure
% plot(pOGth.X,pOGth.Y,'*');hold on;
% plot(pTGth.X,pTGth.Y,'*');hold on;
% plot(pOGth.X(1),pOGth.Y(1),'k*',pTGth.X(1),pTGth.Y(1),'k*');
% legend('Own','Target');
% xlabel('X');
% ylabel('Y');
% axis equal

