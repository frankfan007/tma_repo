

XGrT = cell2mat(GTruth.X');
i = 0;
for mc = [1,2,3,4,5,6,7,9,10]
    i = i+1;
    XEst = cell2mat(Result(mc).X');
    SqErr(:,:,i) = (XGrT - XEst).^2;
end

RMSE = sqrt(mean(SqErr,3));
figure,
subplot 411, plot(RMSE(1,:))
subplot 412, plot(RMSE(3,:))
subplot 413, plot(RMSE(2,:))
subplot 414, plot(RMSE(4,:))