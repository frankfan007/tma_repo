function [pTarget]=mea(pOGth,pTGth,param,FIELDNOTSET)

for k=1:1:param.NS
    if (param.parallax==1)
        X=pOGth.X +param.deltax;
    elseif  (param.parallax==0)
        X=pOGth.X;
    end
    pTarget.Ra(k)=sqrt((pTGth.X(k)-X(k))^2+(pTGth.Y(k)-pOGth.Y(k))^2);   %without noise
    pTarget.phi_r(k)=atan2((pTGth.Y(k)-pOGth.Y(k)),(pTGth.X(k)-X(k))); %rad
    pTarget.phi_d(k)=atan2d((pTGth.Y(k)-pOGth.Y(k)),(pTGth.X(k)-X(k))); %degree   (abs bearing)
    
    %%%%%
    if  pTarget.phi_d>180
        pTarget.phi_d(k)  =pTarget.phi_d(k)-360;
    elseif pTarget.phi_d<-180
        pTarget.phi_d(k)  =pTarget.phi_d(k)+360;
    else
        pTarget.phi_d=pTarget.phi_d;
    end
    %%%%
    
    pTarget.RelBearingdegree(k)=angle_difference_degree(pTarget.phi_d(k),pOGth.Course(k));  % rel bearing=abs bearing-own ship course
    
    % FIELDNOTSET atanmandan önceki rel bearing degeri
    pTarget.TrueRelBearing(k)= pTarget.RelBearingdegree(k);
    
    if( pTarget.RelBearingdegree(k)>param.ownArea(1,1) || pTarget.RelBearingdegree(k)<param.ownArea(2,1))
        pTarget.RelBearingdegree(k)=FIELDNOTSET; %badsector
    end
    pTarget.QuantizedRelBearing(k)=quantize(pTarget.RelBearingdegree(k),param.Quantization_Interval,FIELDNOTSET);
    if k>=2
        % abs bearing üzerinden hesaplanan  bearing rate
        pTarget.Absdeltaphi(k)=angle_difference_degree(pTarget.phi_d(k),pTarget.phi_d(k-1));
        pTarget.Absbearingrate(k)=pTarget.Absdeltaphi(k)/param.dt;   
    end  
end
e_R=param.sigmaR*randn(1,param.NS);
e_phi=param.sigmaphi*randn(1,param.NS);

 pTarget.NoisyRange=pTarget.Ra+e_R; %range measurement with noise
    for f=1:1:param.NS
        if  pTarget.QuantizedRelBearing(f)==FIELDNOTSET
            pTarget.NoisyRelBearing(f)= pTarget.QuantizedRelBearing(f);
        else
           pTarget.NoisyRelBearing(f)= pTarget.QuantizedRelBearing(f)+e_phi(1,f);%bearing measurement with noise
        end
    end
   