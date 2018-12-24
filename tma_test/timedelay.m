function [shifted_time]=timedelay(pTarget,pTGth)
c=1522;%m/s
time_delay= pTarget.Ra/c; %yol/hýz
shifted_time=pTGth.Time+time_delay;
pTGth.time=shifted_time;
