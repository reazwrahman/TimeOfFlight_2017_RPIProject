clc  
clear all
prompt1='actual distance?' ;
prompt2='number of reading per sensors?';
prompt3='number of sensors?'; 

x=input(prompt1);
y=input(prompt2);
z=input(prompt3);


%% CREATING INDIVIDUAL COLUMN VECTOR FOR EACH SENSOR WITH AVG READING AND
%STANDARD DEVIATION

load 'exp5.txt' 
A=exp5(:,2);

s1=A(1:z:y*z);
m1=(sum(s1))/y; 
d1=std(s1); 

s2=A(2:z:y*z);
m2=(sum(s2))/y;  
d2=std(s2);

s3=A(3:z:y*z);
m3=(sum(s3))/y;
d3=std(s3);

s4=A(4:z:y*z);
m4=(sum(s4))/y; 
d4=std(s4);

s5=A(5:z:y*z);
m5=(sum(s5))/y; 
d5=std(s5);

% s6=A(6:z:y*z);
% m6=mean(s6); 
% d6=std(s6);
% 
% s7=A(7:z:y*z);
% m7=(sum(s7))/y; 
% d7=std(s7);
% 
% s8=A(7:z:y*z);
% m8=(sum(s3))/y;
% d8=std(s8);
% 
% 
% s9=A(9:z:y*z);
% m9=(sum(s9))/y;
% d9=std(s9);
% 
% s10=A(10:z:y*z);
% m10=(sum(s10))/y; 
% d10=std(s10);

format shortG ;
% sid=[11;12;13;14;15;16;17;18;19;20];
% avg=[m1;m2;m3;m4;m5;m6;m7;m8;m9;m10];
% diff=[abs(x-m1);abs(x-m2);abs(x-m3);abs(x-m4);abs(x-m5);abs(x-m6);abs(x-m7);abs(x-m8);abs(x-m9);abs(x-m10)];
% stdv=[d1;d2;d3;d4;d5;d6;d7;d8;d9;d10];
% 
% rmx2=[sid avg diff stdv] 


sid=[21,22,23,24,25];
avg=[m1,m2,m3,m4,m5];
add_fact=[(x-m1),(x-m2),(x-m3),(x-m4),(x-m5)];
stdv=[d1,d2,d3,d4,d5]; 
mult_fact=[1/(x\m1),1/(x\m2),1/(x\m3),1/(x\m4),1/(x\m5)];
% add_fix=[m1+(x-m1),m2+(x-m2),x+(x-m3),x+(x-m4),x+(x-m5)];
% mult_fix=[m1*1/(x\m1),m2*1/(x\m2),1/(x\m3)*m3,1/(x\m4)*m4,1/(x\m5)*m5];

% actual=[x,x,x,x,x];
% add1=abs(actual-add_fix);%comparing add fix to the actual value 
% mult1=abs(actual-mult_fix); 

%% COMPARES THE ADD FACTOR TO MULTI FACTOR AND TAKES THE SUPERIOR ONE (not required in this code) 
%% will be used later after data collection
% if mean(add1)>=mean(mult1)
%          factor=mult_fact 
%          disp 'taking mult fact'
%            
% elseif mean(add1)<mean(mult1) 
%          factor=add_fact 
%          disp 'taking add_fact'
% 
% end



B=[sid;avg;add_fact;stdv]; 

C=[sid;avg;add_fact;mult_fact]; 

%% TEXT FILE FOR ADD FACTORS AND MULTI FACTORS ACCUMULATION
% fileID = fopen('factor.txt','w');
% %fprintf(fileID,'%7s %7s  %7s %7s\r\n','Sns','avg','dif','std')
% fprintf(fileID,'%5d    %5.2f   %5.2f  %5.2f\r\n',C);
% fclose(fileID); 
% type factor.txt 
% load factor.txt; 
% factors_column=trial(:,4); % calibration factors stored in a column vector 
% factors_row=factors_column.'; %calibration factors stored in a row vector

%% TEXT FILE FOR RANKING PURPOSES (required in this code)

fileID = fopen('trial.txt','w');
%fprintf(fileID,'%7s %7s  %7s %7s\r\n','Sns','avg','dif','std')
fprintf(fileID,'%5d    %5.2f   %5.2f     %5.2f   %5.4   5.2f    5.2f\r\n',B);
fclose(fileID); 


%% RANKING BASED ON STANDARD DEVIATION AND ACCURACY  
%% (will be used at the end of data collection)
% load 'grmx.txt' 
% std2=grmx(:,4); 
% [stdv,sensorID]=sort(std2,'ascend'); 
% dif2=grmx(:,3);
% [dif2,sensordID2]=sort(dif2,'ascend');
% rm=[sensorID stdv]; %% ranking based on standard deviation 
% rm2=[sensorID2 dif2]; %% ranking based on accuracy

