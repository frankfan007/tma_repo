
model2 = model;
model2.zDim = 2;
for i = 1:length(Result.X)
    Xk_est = Result.X{i};
    Zk = Measures.Z{i};
    own = GTruth.Ownship(:,k);
    zk_est  = MeasFcn(Xk_est, own, model2, false);       % predicted measurements, without noise
    zk_err(:,i) = abs(Zk - zk_est);
end

figure, 
subplot 121, plot(zk_err(1,:),'*-'), title('absolute angle error')
subplot 122, plot(zk_err(2,:),'*-'), title('absolute range error')