function PlotResult(PFResult, GTruth, MC)

Own     = GTruth.Ownship;
Xgt     = cell2mat(GTruth.X');
Xest = zeros(4,length(PFResult(1).X),MC);
for mc = 1:MC
    Xest(:,:,mc) = cell2mat(PFResult(mc).X');
    Pest(:,:,:,mc) = reshape(cell2mat(PFResult(mc).P), 4,4, size(PFResult(mc).P,2));
end
Xest = mean(Xest,3);            % monte carlo mean
Pmean = mean(Pest,4);


figure,
plot(Own(1,1), Own(3,1),'ko'), hold on
plot(Own(1,2:end-1), Own(3,2:end-1),'k-')
plot(Own(1,end), Own(3,end),'kx')
scatter(Xgt(1,1),Xgt(3,1), 'bo')
scatter(Xgt(1,2:end-1), Xgt(3,2:end-1), 200, 'b.')
scatter(Xgt(1,end), Xgt(3,end), 'bx')

% first point
plot(Xest(1,:), Xest(3,:),'r.-');
% Part = PFResult(1).Particles{1};
% h = scatter(Part(1,:), Part(3,:),'.g');
% P = Pmean(:,:,1);
% %% Sigma elliipses
% g = 3;                          % size of the uncertainty in terms of number of sigmas
% h1 = plotErrorEllipse(Xest([1,3],1), P([1,3],[1,3]), g);
% %
% for i = 2:size(PFResult(1).X,1)
%     refreshdata
%     drawnow
%     pause(0.1)
%     delete(h);
%     delete(h1);
%     Parti = PFResult(1).Particles{i};
%     h = scatter(Parti(1,:), Parti(3,:),'.g');
%     scatter(Xest(1,i), Xest(3,i),200, 'r.');
%     
%     %     hh = figure; set(groot,'CurrentFigure',hh);
%     P = Pmean(:,:,i);
%     h1 = plotErrorEllipse(Xest([1,3],i), P([1,3],[1,3]), g);
% end

hold off

end