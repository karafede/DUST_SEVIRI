clc
clear

load \\10.106.67.26\matlab-data\EUMETSAT\LAT_LONG\LONG_20110518;
load \\10.106.67.26\matlab-data\EUMETSAT\LAT_LONG\LAT_20110518;   
load \\10.106.67.26\matlab-data\EUMETSAT\R01\R01_20120226_P3;
% load Dust_animation 

% Interpolation
X1 = LONG(1,:);
Y1 = (flipud(LAT(:,1)))';
[X Y] = meshgrid(X1,Y1);
V = flipud(R01_P3(:,:,1));
X = reshape(X,1500*1500,1);
Y = reshape(Y,1500*1500,1);
V = reshape(V,1500*1500,1);
Xq1 = linspace(min(LONG(:)),max(LONG(:)),1500);
Yq1 = linspace(min(LAT(:)),max(LAT(:)),1500);
[Xq Yq] = meshgrid(Xq1,Yq1);
F = TriScatteredInterp(X,Y,V);
Vq = F(Xq,Yq);
data = flipud(Vq);
% data = Dust_anim.Dust_301;
% data(isnan(data)) = 0;

x = Xq1;
y = Yq1;

cLimLow = min(min(data));
cLimHigh = max(max(data));
altitude = 36000;
alphaMatrix = ones(size(data))*0.95;
% alphaMatrix(data==0) = 0;

kmlFileName = 'Dust_301.kml';

% make the custom colormap
% cmap = [0,0,1;0 1 0;1,0,0];
cmap = colormap;

figure
imagesc(x,y,data,[cLimLow,cLimHigh]);
colormap(cmap)
colorbar

output = ge_imagesc(x,y,data,...
                    'imgURL','Dust_301.png',...
                   'cLimLow',cLimLow,...
                  'cLimHigh',cLimHigh,...
                  'altitude',altitude,...
              'altitudeMode','absolute',...
                  'colorMap',cmap,...
               'alphaMatrix',alphaMatrix);

output2 = ge_colorbar(x(end),y(1),data,...
                          'numClasses',2,...
                             'cLimLow',cLimLow,...
                            'cLimHigh',cLimHigh,...
                       'cBarFormatStr','%+07.4f',...
                            'colorMap',cmap);

ge_output(kmlFileName,[output2 output],'name',kmlFileName);

FileName = 'Dust_301';
north = 40.0049;
south = 9.9965;
east = 60.0045;
west = 29.9955;
k = kml([FileName, '.kml']);
k.overlay(west,east,south,north, 'file',[FileName '.png']);
k.run;
        