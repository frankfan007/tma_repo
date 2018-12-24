function [xk,P]=Filter_EKF(R_m,phi_m,NS,deltat,sigma_R,sigma_phi,Q)
sigma_phi=sigma_phi*(pi/180);
phi_m=phi_m*(pi/180);
xk=zeros(4,NS);
z=zeros(2,NS);
var_R=(sigma_R)^2;
var_phi=(sigma_phi)^2;
%measurement polar to cartesian conversion
cp_m=cos(phi_m);
sp_m=sin(phi_m);
X_m=R_m.*cp_m;
Y_m=R_m.*sp_m;

R=[var_R 0 ;0 var_phi];%measurement noise covariance matrix

sigma_phi_rad=sigma_phi;
R22(2)=(sigma_R^2)*((sin(phi_m(2)))^2)+(R_m(2)^2)*((sigma_phi_rad)^2)*((cos(phi_m(2)))^2);
R11(2)=(sigma_R^2)*(cos(phi_m(2))^2)+(R_m(2)^2)*(sigma_phi_rad^2)*((sin(phi_m(2)))^2);
R12(2)=(sigma_R^2-R_m(2)^2*sigma_phi_rad^2)*cos(phi_m(2))*(sin(phi_m(2)));

%state covariance matrix (error in the estimate)
P(:,:,2)=[R11(2) R12(2)/deltat 0 0; R12(2)/deltat 2*R22(2)/deltat^2 0 0; 0 0 R11(2) R12(2)/deltat;0 0 R12(2)/deltat 2*R22(2)/deltat^2]; %two point diff
%P(:,:,2)=500*eye(4);
F=[1 deltat 0 0;0 1 0 0;0 0 1 deltat;0 0 0 1];
%initial kalman state
xk(:,2)=[X_m(1,2);(X_m(1,2)-X_m(1,1))/deltat;Y_m(1,2);(Y_m(1,2)-Y_m(1,1))/deltat];

for k=3:1:NS
    
    %kalman
    %predict
    xpred=F*xk(:,k-1);
    Ppred=F*P(:,:,k-1)*F'+Q;
    
    Rapred=sqrt(xpred(1,1)^2+xpred(3,1)^2);
    phipred=atan(xpred(3,1)/xpred(1,1)); %rad
    zpred=[Rapred;phipred];
    
    x=xpred(1,1);
    y=xpred(3,1);
    
    r=sqrt(x^2+y^2);
    a11= x/r;
    a13= y/r;
    a21=-y/r^2;
    a23=x/r^2;
    
    Hx=[a11 0 a13 0; a21 0 a23 0];
    S=R+Hx*Ppred*Hx';
    K=Ppred*Hx'*inv(S);   %  kalman gain
    z(:,k)=[R_m(k);phi_m(k)];
    nu(1)=z(1,k)-zpred(1,1);
    nu(2)=angle_difference_rad(z(2,k),zpred(2,1));
    nu=[nu(1);nu(2)];
    xnew=xpred+(K*nu);
    pnew=Ppred-(K*S*K'); %new covariance
    xk(:,k)=xnew;
    P(:,:,k)=pnew;
end
end