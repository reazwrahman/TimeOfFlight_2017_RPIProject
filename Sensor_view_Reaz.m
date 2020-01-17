function C=Sensor_view_Reaz(h,input,~,i,h_border)
%% First parameter h is the handler of the axes we are plotting.
% Parameter input contains the sensor measurements. Last parameter h_border
% contains handlers of all childs of axes h. You need to use the function
% imborder(h) to get h_border. Parameter i is the iteration number(can be
% ignored).

axes(h);

% %% loctemp contains the sensor distribution map, 1 corresponds to tiles
% with sensor and vice versa
loctemp = [...
            1 1 1 1 1 1 1 1 1 1 1 1 1 1;...
            1 0 1 0 1 0 1 0 0 1 1 0 0 1;...
            1 1 1 0 1 1 1 0 1 1 0 1 1 1;...
            1 0 1 0 1 0 1 0 0 1 1 0 0 1;...
            1 1 1 1 1 1 1 1 1 1 1 1 1 1];
% 
% [m,n] = size(loctemp);
[xind,yind] = find(loctemp);
[xzero,yzero] = find(loctemp==0);
hnd=zeros(5,14);

chld=allchild(h);
for j=1:size(chld)
    if chld(j)~=h_border(:)
        delete(chld(j));
    end
end

% Plotting 70 rectangles in the axis, each corresponds to one tile
for j=1:14
    for k=1:5
        hnd(k,j)= rectangle('parent',h,'Position',[2*(14-j+1),2*(k),2,2]);
    end
end
  
% meas = zeros(5,14,3);

% Interpolation: We have 70tiles, 53 of them has color sensors. So a linear
% interpolation is needed to have a continuous distribution of color.

A1=zeros(70,1); A2=zeros(70,1); A3=zeros(70,1);
B1=zeros(53,1); B2=zeros(53,1); B3=zeros(53,1);
C=zeros(210,1);

for m=1:53
    B1(m,1)=input(3*m-2,i);
    B2(m,1)=input(3*m-1,i);
    B3(m,1)=input(3*m,i);
end

I=[7,9,17,18,19,27,29,37,38,39,42,44,53,57,59,62,64];
k1=1; j1=1;
while(k1<71)
    if(ismember(k1,I)==0)
        A1(k1,1)=B1(j1,1);
        A2(k1,1)=B2(j1,1);
        A3(k1,1)=B3(j1,1);
        j1=j1+1;
    end
k1=k1+1;
end
%%
A11=reshape(A1,[5,14]);
A22=reshape(A2,[5,14]);
A33=reshape(A3,[5,14]);
for ii=1:5
    z1=find(A11(ii,:));
    C11(ii,:)=interp1(z1,A11(ii,z1),1:14)';
    z2=find(A22(ii,:));
    C22(ii,:)=interp1(z2,A22(ii,z2),1:14)';
    z3=find(A33(ii,:));
    C33(ii,:)=interp1(z3,A33(ii,z3),1:14)';
end
C1=reshape(C11,[70,1]);
C2=reshape(C22,[70,1]);
C3=reshape(C33,[70,1]);
    %%

for m=1:70
    C(3*m-2,1) = C1(m,1);
    C(3*m-1,1) = C2(m,1);
    C(3*m,1) = C3(m,1);
end

for j=1:53
    set(hnd(xind(j),yind(j)),'Facecolor',[C(3*j-2,1) C(3*j-1,1) C(3*j,1)]); % 53 sensors   
end
 
for j=1:17
    set(hnd(xzero(j),yzero(j)),'Facecolor',[C(3*I(j)-2,1) C(3*I(j)-1,1) C(3*I(j),1)]); % others
end

%       axis([0 28 0 10]);
        text(26.25,5,'\fontsize{12} \color{white} \bf Light','Parent',h);
        text(26.25,9,'\fontsize{12} \color{white} \bf Light','Parent',h);
        text(22.25,7,'\fontsize{12} \color{white} \bf Light','Parent',h);
        text(18.25,5,'\fontsize{12} \color{white} \bf Light','Parent',h);
        text(18.25,9,'\fontsize{12} \color{white} \bf Light','Parent',h);
        text(12.25,5,'\fontsize{12} \color{white} \bf Light','Parent',h);
        text(12.25,9,'\fontsize{12} \color{white} \bf Light','Parent',h);
        text(8.25,7,'\fontsize{12} \color{white} \bf Light','Parent',h);
        text(4.25,5,'\fontsize{12} \color{white} \bf Light','Parent',h);
        text(4.25,9,'\fontsize{12} \color{white} \bf Light','Parent',h);
        text(13.8,5,'\fontsize{12} \color{white} \bf Air Duct','Parent',h);
        text(13.8,9,'\fontsize{12} \color{white} \bf Air Duct','Parent',h);
        text(21.8,5,'\fontsize{12} \color{white} \bf Air Duct','Parent',h);
        text(21.8,9,'\fontsize{12} \color{white} \bf Air Duct','Parent',h);
        text(5.8,5,'\fontsize{12} \color{white} \bf Air Duct','Parent',h);
        text(5.8,9,'\fontsize{12} \color{white} \bf Air Duct','Parent',h);
%       text(14.25,7,'\fontsize{12} \color{white} \bf Light','Parent',h);
