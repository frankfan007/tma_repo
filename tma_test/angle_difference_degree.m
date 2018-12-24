function ang_diff=angle_difference_degree(Cdegree,Pdegree)
ang_diff=Cdegree-Pdegree;
if (ang_diff==360||ang_diff==-360)
    ang_diff=0;
elseif (ang_diff>180)
    ang_diff=-360+ang_diff;
elseif (ang_diff<-180)
    ang_diff=360+ang_diff;
elseif (ang_diff>360)
    ang_diff=ang_diff-360;
elseif (ang_diff<-360)
     ang_diff=ang_diff+360;
end
end