clc;
clear all;
k=1;
n=input('How many nodes you want to add?');
ax=[0 10 0 10];
axis(ax);
hold on;
axis(axis);
title_name=title('The nodes from user input');
for i=1:n
    [s(i).x s(i).y]=ginput(1);
    s(i).id=i;
    s(i).head=0;
    s(i).covered=0;
    plot(s(i).x,s(i).y,'b.');
end
for i=1:n
    for j=1:n
        A(i,j)=0;
    end
end
[x y]=ginput(1);
set(title_name,'String','Neighbours identified');
for i=1:n
    for j=i+1:n
        if(sqrt((s(i).x-s(j).x)^2+(s(i).y-s(j).y)^2)<2)
                A(i,j)=1;
                A(j,i)=1;
                plot([s(i).x s(j).x],[s(i).y s(j).y],'b-');
        end
    end
end
for i=1:n
    min=i;
    for j=1:n
        if(s(i).covered~=1)  
            if(A(i,j)==1&&s(j).head==1)
                s(i).covered=1;
            else if(A(i,j)== 1&&min>j&&s(j).covered~=1)
                min=j;
            end
        end
    end
    if(s(i).covered~=1 && min ==i)
        s(i).head=1;
    end 
end
[x y]=ginput(1);
set(title_name,'String','Cluster heads identified');
for i=1:n
    if(s(i).head==1)
        plot(s(i).x,s(i).y,'r.');
        circle(s(i).x,s(i).y,2);
    else
        plot(s(i).x,s(i).y,'b.');
    end
end
[x y]=ginput(1);
set(title_name,'String','Topology of MANET generated');
for i=1:n
    for j=i+1:n
        if(A(i,j)==1&&(s(i).head==1||s(j).head==1))
            if(s(i).head==1&&s(j).head==1)
                plot([s(i).x s(j).x],[s(i).y s(j).y],'k:');
            else
                plot([s(i).x s(j).x],[s(i).y s(j).y],'r-');
            end
        elseif(A(i,j)==1)
                plot([s(i).x s(j).x],[s(i).y s(j).y],'b-');
        end
    end
end
[x y]=ginput(1);
close;
