clear all 
clc 
clf 
disp ('sensor5')

%open ('sensor8meter1.txt') % always open the file first 
fileID=fopen('sensor7meter1.txt','r'); % write on the file
formatSpec='%f'; 
A=fscanf(fileID,formatSpec); % create a column A with the data from the text file
% t=linspace(0,2800,20000);  
% figure(1)
% plot(t,A)   
% hold on; 
% xlabel('time (second)'); ylabel ('distance (mm)'); title ('time vs reading');  
hist(A,[900:10:1000]) 
xlabel('distance (mm)'); ylabel('reading frequency'); title('sensor reading');  
title('sensor 2')
% plot([1350 1350], [0 20000],'r:')
% fig=figure; 
%  hold on;
%  hax=axes;
%  SP=1000;  
%  line([SP SP],get(hax,'YLim'),'Color',[1 0 0]);
hold on 


%open ('sensor8meter1.25.txt') % always open the file first 
fileID=fopen('sensor7meter1.25.txt','r'); % write on the file
formatSpec='%f'; 
A1=fscanf(fileID,formatSpec); % A is obtaining data and creates a column 
% t=linspace(20000,2800,40000);  
% figure(1)
% plot(t,A)  
% xlabel('time (second)'); ylabel ('distance (mm)'); title ('time vs reading');  
%figure(1)
hist(A1,[1150:10:1250]) 
xlabel('distance (mm)'); ylabel('reading frequency'); title('sensor reading');  
%plot([1350 1350], [0 20000],'r:') 
hold on


%open ('sensor8meter1.5.txt') % always open the file first 
fileID=fopen('sensor7meter1.5.txt','r'); % write on the file
formatSpec='%f'; 
A2=fscanf(fileID,formatSpec); % A is obtaining data and creates a column 
%t=linspace(0,2800,20000);  
%figure(2)
% plot(t,A);  
% xlabel('time (second)'); ylabel ('distance (mm)'); title ('time vs
% reading'); 
hist(A2,[1400:5:1500]) 
xlabel('distance (mm)'); ylabel('reading frequency'); title('sensor reading') 
%plot([1500 1500], [0 20000],'r:')


%open ('sensor8meter1.75.txt') % always open the file first 
fileID=fopen('sensor7meter1.75.txt','r'); % write on the file
formatSpec='%f'; 
A3=fscanf(fileID,formatSpec); % A is obtaining data and creates a column 
%t=linspace(0,2800,20000);  
%figure(2)
% plot(t,A);  
% xlabel('time (second)'); ylabel ('distance (mm)'); title ('time vs reading'); 
hist(A3,[1650:10:1750]) 
xlabel('distance (mm)'); ylabel('reading frequency'); title('sensor reading') 
%plot([1500 1500], [0 20000],'r:') 


%open ('sensor8meter2.txt') % always open the file first 
fileID=fopen('sensor7meter2.txt','r'); % write on the file
formatSpec='%f'; 
A4=fscanf(fileID,formatSpec); % A is obtaining data and creates a column 
%t=linspace(0,2800,20000);  
%figure(2)
% plot(t,A);  
% xlabel('time (second)'); ylabel ('distance (mm)'); title ('time vs
% reading'); 
hist(A4,[1950:10:2050]) 
xlabel('distance (mm)'); ylabel('reading frequency'); title('sensor reading') 
%plot([1500 1500], [0 20000],'r:') 
%%
format short;
avg=[mean(A);mean(A1); mean(A2);mean(A3);mean(A4)]
%avg= sprintf('%.8f ',avg)
std=[std(A);std(A1);std(A2);std(A3);std(A4)]
%std8=sprintf('%.8f', std)
actual= [1000;1250;1500;1750;2000];  
difference=actual-avg ; 
add_fact=mean(difference)
mult_fact=1/(actual\avg) 
add_fix=avg+add_fact;
mult_fix=avg*mult_fact; 

x=abs(add_fix-actual); 
y=abs(mult_fix-actual); 
if mean(x)>mean(y); 
    disp('mult_fact is more effective') 
elseif mean(x)<mean(y) 
    disp('add_fact is more effective') 
elseif mean(x)==mean(y); 
    disp ('both factors have an equal effect') 
end

%%
if isnan(avg(1,1))==1 | isnan(avg(2,1))==1 | isnan(avg(3,1))==1 | isnan(avg(4,1))==1 | isnan(avg(5,1))==1
    [row col]=find(isnan(avg));  
    if row==1;
        disp('error exists at 1 meter txt tile')
        [row col]=find(isnan(A)) 
    elseif row==2;
        disp('error exists at 1.25 meter txt tile')
        [row col]=find(isnan(A1))
    elseif row==3;
        disp('error exists at 1.5 meter txt tile')
        [row col]=find(isnan(A2))
    elseif row==4;
        disp('error exists at  1.75 meter txt tile')
        [row col]=find(isnan(A3))
    elseif row==5;
        disp('null exists at  2 meter txt tile')
        [row col]=find(isnan(A4))
 else  
    disp('program ran successfully') 
end 
end

 
  


