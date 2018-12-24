function degree_change=course_speed_manev(Com_val,Cur_Val,Rate,dt,m)
if m==1
total_change=angle_difference_degree(Com_val,Cur_Val); %course change(degree)
else
total_change=Com_val-Cur_Val; % speed change
end
total_NS=total_change/(Rate*dt); %maneuver total number of sample
if mod(total_NS,1)==0
total_NS=abs(total_NS);
else 
fprintf('check initial parameters') 
end
degree_change=total_change/total_NS;  
end