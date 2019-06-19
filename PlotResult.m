function PlotResult(PFResult, GTown, GTx, MC)

% Own     = GTruth.Ownship;
% Xgt     = cell2mat(GTruth.X');
Xest = zeros(4,length(PFResult(1).X),MC);
for mc = 1:MC
    Xest(:,:,mc) = cell2mat(PFResult(mc).X');
end
Xest = mean(Xest,3);            % monte carlo mean


figure,
plot(GTown.X(1), GTown.Y(1),'ko'), hold on
plot(GTown.X(2:end-1), GTown.Y(2:end-1),'k-')
plot(GTown.X(end), GTown.Y(end),'kx')
scatter(GTx.X(1), GTx.Y(1), 'bo')
scatter(GTx.X(2:end-1), GTx.Y(2:end-1), 200, 'b.')
scatter(GTx.X(end), GTx.Y(end), 'bx')

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