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

for i=1:n
    for j=1:n
        connected(i,j)=0;
    end
end
%[x y]=ginput(1);
for i=1:n
    cnt(i)=0;
end
set(title_name,'String','Neighbours identified');
for i=1:n
    for j=i+1:n
        if(sqrt((s(i).x-s(j).x)^2+(s(i).y-s(j).y)^2)<2)
                A(i,j)=1;
                A(j,i)=1;
                cnt(i)=cnt(i)+1;
               % plot([s(i).x s(j).x],[s(i).y s(j).y],'b-');
        end
    end
end
 for i=1:n
    [x y]= max(cnt);
    if(s(y).covered~=1)
        s(y).head=1;
        for j=1:n
            if(A(y,j)==1)
                s(j).covered=1;
            end
        end
        cnt(y)=-1;
    else
        cnt(y)=-1;
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
for i=1:n
    for j=i:n
        if(i~=j&&s(i).head==1&&s(j).head==1)
            for p=1:n
                if(p~=i&&p~=j&&connected(i,p)~=0&&connected(j,p)~=0&&s(p).head==1)
                    connected(i,j)=1;
                    connected(j,i)=1;
                end
            end     
            for k=1:n
                if(k~=i&&k~=j&&A(i,k)==1&&A(j,k)==1&&connected(i,j)==0)
                        connected(i,j)=1;
                        connected(j,i)=1;
                        plot([s(i).x s(k).x],[s(i).y s(k).y],'g-');
                        plot([s(j).x s(k).x],[s(j).y s(k).y],'g-');
                else
            for m=1:n
                if(A(i,k)==1&&A(k,m)==1&&A(m,j)==1&&connected(i,j)==0)
                    connected(i,j)=1;
                    connected(j,i)=1;
                    plot([s(i).x s(k).x],[s(i).y s(k).y],'g-');
                    plot([s(m).x s(k).x],[s(m).y s(k).y],'g-');
                    plot([s(j).x s(m).x],[s(j).y s(m).y],'g-');
                end
            end
                end
            end
        end
    end
end
  

%[x y]=ginput(1);
%set(title_name,'String','Topology of MANET generated');
%for i=1:n
 %   for j=i+1:n
  %      if(A(i,j)==1&&(s(i).head==1||s(j).head==1))
   %         if(s(i).head==1&&s(j).head==1)
    %            plot([s(i).x s(j).x],[s(i).y s(j).y],'k:');
     %       else
      %          plot([s(i).x s(j).x],[s(i).y s(j).y],'r-');
       %     end
        %elseif(A(i,j)==1)
         %       plot([s(i).x s(j).x],[s(i).y s(j).y],'b-');
         %end
  %  end
%end
%[x y]=ginput(1); 
%close;
