function [Xnew,Ynew]=pos(X,Y,Course,Speed,dt)
Xnew=X+(dt*Speed*sind(Course));
Ynew=Y+(dt*Speed*cosd(Course));
end