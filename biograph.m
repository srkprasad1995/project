x=random('poisson',1:0.5:8,1,15);
m=0;
y=random('poisson',1:15,1,15);
m=input('kjhgjh')
k=1;w=[];p=0;
for i=1:15
    for j=1:15
         p=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
        if(p<m)
            X(k)=i;
            Y(k)=j;
            W(k)=p;
            k=k+1;
        end
    end
end
disp(X);
disp(Y);
disp(W);
DG=sparse(X,Y,W)
UG=tril(DG+DG')
h = view(biograph(UG,[],'ShowArrows','off','ShowWeights','on'))
%[dist,path,pred] = graphshortestpath(UG,1,6,'directed',false)
%set(h.Nodes(path),'Color',[.6 0.4 0.4])
 %fowEdges = getedgesbynodeid(h,get(h.Nodes(path),'ID'));
 %revEdges = getedgesbynodeid(h,get(h.Nodes(fliplr(path)),'ID'));
 %edges = [fowEdges;revEdges];
 %set(edges,'LineColor',[1 0 0])
 %set(edges,'LineWidth',1.5)%
