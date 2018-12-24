function [Speed,X,Y]=speedNoise(pTGth,param)
SpeedNoise=param.SpeedNoise_var*randn(1,param.NS);

Course=pTGth.Course;
Speed=pTGth.Speed+SpeedNoise;

x=zeros(1,param.NS);
y=zeros(1,param.NS);

x(1)=param.tarX;
y(1)=param.tarY;

for k=1:1:param.NS
    [x(k+1),y(k+1)]=pos(x(k),y(k),Course(k),Speed(k),param.dt);
end
X=x;
Y=y;
end
