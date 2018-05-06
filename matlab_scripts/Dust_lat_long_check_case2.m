clc
clear
%Overlaying latitude and longitude over image case 2
load \\10.106.67.26\matlab-data\EUMETSAT\LAT_LONG\LONG_20110518;
load \\10.106.67.26\matlab-data\EUMETSAT\LAT_LONG\LAT_20110518;  
load \\10.106.67.26\matlab-data\EUMETSAT\T10\T10_20120226_P1;

% Interpolation
X = LONG(1,:);
Y = (flipud(LAT(:,1)))';
V=flipud(T10_P1(:,:,1));
Xq1=linspace(min(LONG(:)),max(LONG(:)),1500);
Yq1=linspace(min(LAT(:)),max(LAT(:)),1500);
[Xq Yq] = meshgrid(Xq1,Yq1);
Vq = griddata(X,Y,V,Xq,Yq);


figure('Color','white')
Z=Vq;
R = georasterref('RasterSize', size(Z), ...
  'Latlim', [10.0065163418805 39.9949317428787], 'Lonlim', [30.0055330666120 59.9944665088319]);
worldmap(Z, R)
meshm(Z, R)
%demcmap(Z)

%Check the lat long given in the SEVIRI data fits with the coast in matlab
hold on
load coast
geoshow(lat, long)


