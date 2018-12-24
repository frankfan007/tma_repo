function [X,Y,Course,Speed,Time]=motion(x,y,course,speed,NS,dt,CmanevTime,SManevTime,turnRate,Acc)
X=zeros(1,NS);
Y=zeros(1,NS);
Time=zeros(1,NS);
Course=zeros(1,NS);
Speed=zeros(1,NS);
X(1)=x;
Y(1)=y;
Course(1)=course(1,1);
Speed(1)=speed(1,1);

[Coursesz,~]=size(course);
[Speedsz,~]=size(speed);

if (Coursesz==1) && (Speedsz==1) %manevra yok
    for k=1:1:NS
        Speed(k)=speed(1,1);
        Course(k)=course(1,1);
        [X(k+1),Y(k+1)]=pos(X(k),Y(k),Course(k),Speed(k),dt);
        if k==1
            Time(k)=0;
        else
            Time(k)=(k-1)*dt;
        end
    end
elseif (Coursesz>1) && (Speedsz==1) %course manevra
      a=1;
    for k=1:1:NS
        Speed(k)=speed(1,1);
        if k==1
            Time(k)=0;
        else
            Time(k)=(k-1)*dt;
        end
        if (k<=CmanevTime(a,1)/dt) %doðrusal hareket
            Course(k)=course(a,1);
        elseif (CmanevTime(a,1)/dt<k) %manevra zamaný
       
            degree_Change=course_speed_manev(course(a+1,1),course(a,1),turnRate(a,1),dt,true);
            Course(k)=Course(k-1)+degree_Change;
           
            if (course(a+1,1)== Course(k))
                a=a+1;
            end
        end     
        [X(k+1),Y(k+1)]=pos(X(k),Y(k),Course(k),Speed(k),dt);
    end
elseif  (Coursesz==1) && (Speedsz>1) %speed manevra
    a=1;
    for k=1:1:NS
        Course(k)=course(1,1);
        if k==1
            Time(k)=0;
        else
            Time(k)=(k-1)*dt;
        end
        if (k<=SManevTime(a,1)/dt) %doðrusal hareket
            Speed(k)=speed(a,1);
        elseif (SManevTime(a,1)/dt<k) %manevra zamaný
             Speed_Change=course_speed_manev(speed(a+1,1),speed(a,1),Acc(a,1),dt,false);
             Speed(k)=Speed(k-1)+Speed_Change;
            
            if (speed(a+1,1)== Speed(k))
                a=a+1;
            end
        end
        [X(k+1),Y(k+1)]=pos(X(k),Y(k),Course(k),Speed(k),dt);
    end
 elseif (Coursesz>1) && (Speedsz>1) %course&speed manevra
     a=1;
     b=1;
     for k=1:1:NS
         if k==1
             Time(k)=0;
         else
             Time(k)=(k-1)*dt;
         end
         if (k<=SManevTime(a,1)/dt) && (k<=CmanevTime(b,1)/dt) %doðrusal hareket
             Speed(k)=speed(a,1);
             Course(k)=course(b,1);
            
         elseif( SManevTime(a,1)/dt<k) %speed manevra
             Speed_Change=course_speed_manev(speed(a+1,1),speed(a,1),Acc(a,1),dt,false);
             Speed(k)=Speed(k-1)+Speed_Change;
             Course(k)=course(b,1);
              if (speed(a+1,1)== Speed(k))
                 a=a+1;
             end
             
         elseif (CmanevTime(b,1)/dt<k) %course manevra
            degree_Change=course_speed_manev(course(b+1,1),course(b,1),turnRate(b,1),dt,true);
            Course(k)=Course(k-1)+degree_Change;
            Speed(k)=speed(a,1);
             if (course(b+1,1)== Course(k))
                b=b+1;
            end
         end
           [X(k+1),Y(k+1)]=pos(X(k),Y(k),dt,Course(k),Speed(k),dt);
     end

end