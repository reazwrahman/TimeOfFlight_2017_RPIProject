function [reading] = ReadTOF( )

delete(instrfindall);

numMeasurements = 20;
sensorID = 5;

s = serial('COM8');
s.BaudRate = 500000;
s.DataBits = 8;
s.StopBits = 1;
s.Timeout = 1;
s.Terminator = 'CR';
fopen(s);

reading = zeros(1, numMeasurements);
for i = 1:numMeasurements
  fprintf(s, strcat('A', num2str(sensorID)));
  res_s = fscanf(s, '%s', 300);
  res = strsplit(res_s, '>');
  reading(i) = str2double(res(2));
  pause(0.05);
end
hist(reading);
xlabel('Distance (mm)');
ylabel('Freq.');
title(strcat('Sensor ', num2str(sensorID)));
S = std(reading);
dim = [0.2 0.5 0.3 0.3];
str = strcat('Std. Dev:  ', num2str(S));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
fclose(s);
end