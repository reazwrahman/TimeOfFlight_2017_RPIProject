%% code for aggregating all the calibration factors
clc
x=input ('what is the actual distance?');
% %%
load grmx.txt
sid=grmx(:,1); 
sid2=sid.';
avg=grmx(:,2); 
avg2=avg.';%turning the column vector to a row vector for appending to a text file nicely
[C,D]=size(avg); 
actual=repmat(x,[C,D]); % creates an array of actual reading, with dimension size obtained from avg column
add_fact=actual-avg; 
add_fact2=add_fact.';
mult_fact=1./(actual.\avg); 
mult_fact2=mult_fact.';
D=[sid2;avg2;add_fact2;mult_fact2]; %creates a column distribution from row vectors so that it can be appended to the text file nicely

fileID = fopen('factor.txt','w');
% %fprintf(fileID,'%7s %7s  %7s %7s\r\n','Sns','avg','dif','std')
fprintf(fileID,'%2d   %5.2f  %5.2f   %5.2f\r\n',D);% D goes in text file with proper formatting
fclose(fileID); 
%type factor.txt;


%%
load factor.txt  
add_fix=avg+add_fact; 
mult_fix=avg.*mult_fact; 
[A,B]=size(add_fix); 
actual=repmat(1390,[A,B]); % creating an array of the actual distance that has the proper matrix size
add1=abs(actual-add_fix);%comparing add fix to the actual value 
mult1=abs(actual-mult_fix);% comparing mult_fix to the actual value 


if mean(add1)>=mean(mult1)
         disp 'taking mult fact'
         factor=mult_fact;
           
elseif mean(add1)<mean(mult1) 
         disp 'taking add_fact'
         factor=add_fact; 
end 

factor_column=factor;
format shortG
mult_fact(121)=0;
mult_fact2=mult_fact(151:160);

factor_row=factor_column.' ;
fileID = fopen('mult.txt','w');
 %fprintf(fileID,'%7s %7s  %7s %7s\r\n','Sns','avg','dif','std')
fprintf(fileID,'%2.2f,',mult_fact);
fclose(fileID);  
type mult.txt 

factor_row=factor_column.' ;
fileID = fopen('add.txt','w');
 %fprintf(fileID,'%7s %7s  %7s %7s\r\n','Sns','avg','dif','std')
fprintf(fileID,'%2.2f,',add_fact.');
fclose(fileID);  
type add.txt 

