function PlotResult(Result, GTruth)

Xgt     = cell2mat(GTruth.X');
Xest    = cell2mat(Result.X');
Own     = GTruth.Ownship;

figure,
plot(Own(1,1), Own(3,1),'ko'), hold on
plot(Own(1,2:end-1), Own(3,2:end-1),'k-')
plot(Own(1,end), Own(3,end),'kx')
scatter(Xgt(1,1), Xgt(3,1), 'bo')
scatter(Xgt(1,2:end-1), Xgt(3,2:end-1), 200, 'b.')
scatter(Xgt(1,end), Xgt(3,end), 'bx')

% first point
plot(Xest(1,:), Xest(3,:),'r.-');
% Part = Result.Particles{1};
% h = scatter(Part(1,:), Part(3,:),'.g');
% % 
% for i = 2:size(Xgt,2)
%     refreshdata
%     drawnow
%     pause(0.5)
%     delete(h);
%     Parti = Result.Particles{i};
%     h = scatter(Parti(1,:), Parti(3,:),'.g');
%     scatter(Xest(1,i), Xest(3,i),200, 'r.');
% end

hold off

end