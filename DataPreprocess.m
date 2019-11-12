clc; clearvars; close all;

load Senaryo1Kosum1_M.mat;
MC = 1;

b = pMilpas.bearing;
k = 0;
t = 0;
K = 20;
for i = 1:length(b)
    k = k+1;
    if k < K
        bseq(k) = b(i);
    else
        bseq(k) = b(i);
        k = 0;
        t = t+1;
        bprocessed(t) = mean(bseq);
        own.X(t,1) = pOwnship.X(i);
        own.Y(t,1) = pOwnship.Y(i);
        own.C(t,1) = pOwnship.C(i);
        own.S(t,1) = pOwnship.S(i);
        gt.X(t,1) = pTargetGPS.X(i);
        gt.Y(t,1) = pTargetGPS.Y(i);
        gt.S(t,1) = pTargetGPS.S(i);
    end
end