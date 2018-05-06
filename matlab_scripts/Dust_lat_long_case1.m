clc
clear
load \\10.106.67.26\matlab-data\EUMETSAT\LAT_LONG\LONG_20110518;
load \\10.106.67.26\matlab-data\EUMETSAT\LAT_LONG\LAT_20110518;
load \\10.106.67.26\matlab-data\EUMETSAT\T10\T10_20120226_P1;
%Overlaying latitude and longitude over image case 1
figure('Color','white')
axesm('miller','MapLatLimit',[10.0065163418805 39.9949317428787],'MapLonLimit',[30.0055330666120 59.9944665088319],'MLineLocation',[10],'PLineLocation',[10],'parallelLabel','on','MeridianLabel','on')
axis off; framem on; gridm on;
surfm(LAT,LONG,T10_P1(:,:,1))


