%%  Quantization analysis

clc; close all;


for i = 1:param.MonteCarlo
    TrueB(i,:) = pTarget(i).TrueRelBearing;
    QuanB(i,:) = pTarget(i).QuantizedRelBearing;
end

figure,
for i = 1:size(TrueB,2)
    err = TrueB(:,i) - QuanB(:,i);
    
    refreshdata
    drawnow
    pause(0.5)
    histogram(err,'Normalization','pdf')
end


