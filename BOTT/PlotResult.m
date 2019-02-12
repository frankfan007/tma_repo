function PlotResult(Result, GTruth)

NumOfPoints = length(Result.X);
for i = 1:NumOfPoints
    Xest(:,i) = Result.X{i};
    GT(:,i) = GTruth.X{i};
    Own(:,i) = GTruth.Ownship(:,i);
end
figure,
plot(Own(1,:), Own(3,:),'k-'), hold on
% first point
scatter(Xest(1,1), Xest(3,1), 'ro')
scatter(GT(1,1), GT(3,1), 'bo')
% rest of the points,
scatter(Xest(1,2:end-1), Xest(3,2:end-1),200, 'r.')
scatter(GT(1,2:end-1), GT(3,2:end-1), 200, 'b.')
legend('Ownship', 'Estimation', 'Ground Truth')
% last point
scatter(Xest(1,end), Xest(3,end),'rx')
scatter(GT(1,end), GT(3,end), 'bx')
hold off

end