function errorplot(Result)
subplot(2,2,1);
plot(Result.RMSE_pos);hold on
xlabel('K');
ylabel('RMSE position');
legend('CMKF','EKF');
subplot(2,2,2);
plot(Result.RMSE_vel);hold on
xlabel('K');
ylabel('RMSE velocity');
legend('CMKF','EKF');
subplot(2,2,3);
plot(Result.ANEES);hold on
xlabel('K');
ylabel('ANEES');
legend('CMKF','EKF');
subplot(2,2,4);
plot(Result.LNEES);hold on
xlabel('K');
ylabel('LNEES');
legend('CMKF','EKF');
end