function ang_diff=angle_difference_rad(cmd_psi,psi)
ang_diff=cmd_psi-psi;
if (ang_diff==(2*pi)||ang_diff==(-2*pi))
    ang_diff=0;
elseif (ang_diff>pi)
    ang_diff=-2*pi+ang_diff;
elseif (ang_diff<-pi)
    ang_diff=2*pi+ang_diff;
elseif (ang_diff>2*pi)
    ang_diff=ang_diff-(2*pi);
elseif (ang_diff<-2*pi)
    ang_diff=ang_diff+(2*pi);
end
end