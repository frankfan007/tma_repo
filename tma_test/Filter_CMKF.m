function [xk,P]=Filter_CMKF(R_m,phi_m,NS,deltat,sigma_R,sigma_phi,Q)
 %measurement polar to cartesian conversion
 cp_m=cosd(phi_m);
 sp_m=sind(phi_m);
 X_m=R_m.*cp_m;
 Y_m=R_m.*sp_m;
 
 xk=zeros(4,NS);
 z=zeros(2,NS);
 P=zeros(4,4,NS);

 sigma_phi_rad=sigma_phi*(pi/180);
 R22(2)=(sigma_R^2)*((sind(phi_m(2)))^2)+(R_m(2)^2)*((sigma_phi_rad)^2)*((cosd(phi_m(2)))^2);
 R11(2)=(sigma_R^2)*(cosd(phi_m(2))^2)+(R_m(2)^2)*(sigma_phi_rad^2)*((sind(phi_m(2)))^2);
 R12(2)=(sigma_R^2-R_m(2)^2*sigma_phi_rad^2)*cosd(phi_m(2))*(sind(phi_m(2)));

 P(:,:,2)=[R11(2) R12(2)/deltat 0 0; R12(2)/deltat 2*R22(2)/deltat^2 0 0; 0 0 R11(2) R12(2)/deltat;0 0 R12(2)/deltat 2*R22(2)/deltat^2]; %two point diff
 %P(:,:,2)=[R11(2) R12(2) 0 0;R12(2) R22(2) 0 0; 0 0 R11(2) R12(2) ;0 0 R12(2) R22(2)];
 
 R(:,:,2)=[R11(2) R12(2); R12(2) R22(2)];
 H=[1 0 0 0; 0 0 1 0];
 F=[1 deltat 0 0;0 1 0 0;0 0 1 deltat;0 0 0 1];
 %initial kalman states

 xk(:,2)=[X_m(1,2);(X_m(1,2)-X_m(1,1))/deltat;Y_m(1,2);(Y_m(1,2)-Y_m(1,1))/deltat];
 for k=3:1:NS
     
     
     z(:,k)=[X_m(1,k);Y_m(1,k)];
     %  linearized covariance
     R22(k)=(sigma_R^2)*((sind(phi_m(k)))^2)+(R_m(k)^2)*((sigma_phi_rad)^2)*((cosd(phi_m(k)))^2);
     R11(k)=(sigma_R^2)*(cosd(phi_m(k))^2)+(R_m(k)^2)*(sigma_phi_rad^2)*((sind(phi_m(k)))^2);
     R12(k)=(sigma_R^2-R_m(k)^2*sigma_phi_rad^2)*cosd(phi_m(k))*(sind(phi_m(k)));
     
     R(:,:,k)=[R11(k) R12(k); R12(k) R22(k)];
     
     xpred=F*xk(:,k-1);
     Ppred=F*P(:,:,k-1)*F'+Q;
     
     %innovation
     y=z(:,k);
     nu=y-H*xpred;
     S=R(:,:,k)+H*Ppred*H';
     
     %innovation update
     K=Ppred*H'*inv(S);   %  kalman gain
     xnew=xpred+(K*nu);   %new state
     pnew=Ppred-(K*S*K'); %new covariance
     
     xk(:,k)=xnew;
     P(:,:,k)=pnew;
 end
end