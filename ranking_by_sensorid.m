%%  RANKING BASED ON STANDARD DEVIATION AND ACCURACY
clc 
clear all
load 'grmx.txt' 
std=grmx(:,4); 
%[std sensorID]=sort(std,'ascend'); 
dif=grmx(:,3);
%[dif sensordID2]=sort(dif,'ascend');
%rm=[sensorID std]; %% ranking based on standard deviation 
%rm2=[sensorID2 dif];  %% ranking based on accuracy 
%good_sensors=find(dif<50 & std<30) 
bad_sensors=find(dif>100 | std>35); 
%number_of_good_sensors= size(good_sensors) 
%number_of_bad_sensors= size(bad_sensors);  
%%{bad attribute=(dif>100 | std>35) 40 sensors in total
%%best attribute=(dif<50 & std<20) 38 sensors in total}

best_sensors=find(dif<50 & std<30); 
best_sensors1=find(dif<50 & std<20); 
best_sensors=best_sensors.'
best_sensors2=setdiff(best_sensors,best_sensors1) 
bad_sensors=bad_sensors.'; 
 

fileID = fopen('rand.txt','w');
 %fprintf(fileID,'%7s %7s  %7s %7s\r\n','Sns','avg','dif','std')
fprintf(fileID,'%2.2f,',best_sensors);
fclose(fileID);  
type rand.txt  

fileID = fopen('rand2.txt','w');
 %fprintf(fileID,'%7s %7s  %7s %7s\r\n','Sns','avg','dif','std')
fprintf(fileID,'%2.2f,',bad_sensors);
fclose(fileID);  
type rand2.txt 
