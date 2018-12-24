function [RMSE_pos,RMSE_vel,ANEES,LNEES]=evaluation(pTGth,pOGth,pFilter,param)
% relative true pos and vel
Xt=pTGth.X-pOGth.X;
Yt=pTGth.Y-pOGth.Y;
Xdott=pTGth.Speed.*sind(pTGth.Course) -pOGth.Speed.*sind(pOGth.Course);
Ydott=pTGth.Speed.*cosd(pTGth.Course)-pOGth.Speed.*cosd(pOGth.Course);

[sz,~,~]=size(pFilter.State);
Ns=sz; %Number of state

error_vec=zeros(4,param.NS,param.MonteCarlo);

for m=1:1:param.MonteCarlo
    %pos errors
    error.X(m,:)=Xt(1,(1:end-1))-pFilter.State(1,:,m);
    error.Y(m,:)=Yt(1,(1:end-1))-pFilter.State(3,:,m);
    %vel errors
    error.Xdot(m,:)=Xdott-pFilter.State(2,:,m);
    error.Ydot(m,:)=Ydott-pFilter.State(4,:,m);
    
    error_vec(:,:,m)=[error.X(m,:);error.Xdot(m,:);error.Y(m,:);error.Ydot(m,:)];
    for k=2:1:param.NS % ilk filter state  0 olduðu için 2 den baþlatýyorum
        NEES(m,k-1)=(error_vec(:,k,m)'*inv(pFilter.Cov(:,:,k,m))*error_vec(:,k,m))/Ns; 
    end
end

ANEES(1,:)=sum(NEES,1)/param.MonteCarlo;
LNEES=log(ANEES);

%position RMSE
sq_er_X=error.X(:,(2:end)).^2;
sq_er_Y=error.Y(:,(2:end)).^2;

sq_er_pos=sq_er_X+sq_er_Y;

MSE_pos=sum(sq_er_pos,1)/param.MonteCarlo;
RMSE_pos=sqrt(MSE_pos);

%velocity RMSE 
sq_er_Xdot=error.Xdot(:,(2:end)).^2;
sq_er_Ydot=error.Ydot(:,(2:end)).^2;

sq_er_vel=sq_er_Xdot+sq_er_Ydot;

MSE_vel=sum(sq_er_vel,1)/param.MonteCarlo;
RMSE_vel=sqrt(MSE_vel);
end
