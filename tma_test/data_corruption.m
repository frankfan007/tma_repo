function [Range,Bearing]=data_corruption(range,bearing,param,FIELDNOTSET)
y=randsample(param.NS,param.Num_Data); %random samples
y=y';
range(y)=FIELDNOTSET;
bearing(y)=FIELDNOTSET;
Range=range;
Bearing=bearing;