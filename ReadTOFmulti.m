function [reading] = ReadTOFmulti( )

delete(instrfindall);

sensorstart = input('Input which sensor to start');
sensorsnum = input('Input number of sensors connected');
sensorend = sensorstart+sensorsnum-1;

numMeasurements = 20;
s = serial('COM8');
s.BaudRate = 500000;
s.DataBits = 8;
s.StopBits = 1;
s.Timeout = 1;
s.Terminator = 'CR';
fopen(s);

reading = zeros(sensorsnum, numMeasurements);
for i = 1:numMeasurements
	for id = sensorstart:sensorend
	  fprintf(s, strcat('A', num2str(id)));
	  res_s = fscanf(s, '%s', 300);
	  res = strsplit(res_s, '>');
	  storeindex = 1+id-sensorstart;
	  reading(storeindex,i) = str2double(res(2));
	  %pause(0.05);
	end  
end
for i = 1:sensorsnum
	figure;
    hist(reading(i,:));
	xlabel('Distance (mm)');
	ylabel('Freq.');
	title(strcat('Sensor ', num2str(i)));
	S = std(reading(i,:));
	dim = [0.2 0.5 0.3 0.3];
	str = strcat('Std. Dev:  ', num2str(S));
	annotation('textbox',dim,'String',str,'FitBoxToText','on');

    dev = reading(i,:)-305;

    figure;
    hist(dev);
    xlabel('deviation (mm)');
	ylabel('Freq.');
	title(strcat('Sensor ', num2str(i)));
	S = std(reading(i,:));
    M = mean(reading(i,:));
	dim = [0.2 0.5 0.3 0.3];
	str = strcat('Std. Dev:  ', num2str(S));
	annotation('textbox',dim,'String',str,'FitBoxToText','on');
    
    figure;
    scale = dev/305.0;
    hist(scale);
    xlabel('deviation in scale(%)');
	ylabel('Freq.');
	title(strcat('Sensor ', num2str(i)));
	S = std(reading(i,:));
	dim = [0.2 0.5 0.3 0.3];
	str = strcat('Std. Dev:  ', num2str(S));
	annotation('textbox',dim,'String',str,'FitBoxToText','on');
end