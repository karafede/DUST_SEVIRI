clc
clear
load \\10.106.67.26\matlab-data\EUMETSAT\T10\T10_20120226_P1;
%Overlaying latitude and longitude over image case 2
figure('Color','white')
Z=flipud(T10_P1(:,:,1));
R = georasterref('RasterSize', size(Z), ...
  'Latlim', [10.0065163418805 39.9949317428787], 'Lonlim', [30.0055330666120 59.9944665088319]);
worldmap(Z, R)
meshm(Z, R)
%demcmap(Z)