function PlotResult(Result, GTruth)

Xgt     = cell2mat(GTruth.X');
Xest    = cell2mat(Result.X');
Own     = GTruth.Ownship;

figure,
plot(Own(1,:), Own(3,:),'k-'), hold on
scatter(Xgt(1,1), Xgt(3,1), 'bo')
scatter(Xgt(1,2:end-1), Xgt(3,2:end-1), 200, 'b.')
scatter(Xgt(1,end), Xgt(3,end), 'bx')

% first point
scatter(Xest(1,1), Xest(3,1),'ro');
Part = Result.Particles{1};
h = scatter(Part(1,:), Part(3,:),'.g');

for i = 2:size(Xgt,2)
    refreshdata
    drawnow
    pause(0.5)
    delete(h);
    Parti = Result.Particles{i};
    h = scatter(Parti(1,:), Parti(3,:),'.g');
    scatter(Xest(1,i), Xest(3,i),200, 'r.');
end
% % rest of the points,
% scatter(Xest(1,2:end-1), Xest(3,2:end-1),200, 'r.')
% 
% legend('Ownship', 'Estimation', 'Ground Truth')
% % last point
% scatter(Xest(1,end), Xest(3,end),'rx')

hold off

end