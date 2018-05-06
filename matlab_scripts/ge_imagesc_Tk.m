clc
clear

load LONG_20110518;
load LAT_20110518;   
load Dust_301;

data = Dust_301;
data(isnan(data)) = 0;

x = LONG(1,:);
y = (flipud(LAT(:,1)))';
cLimLow = min(min(data));
cLimHigh = max(max(data));
altitude = 800;
alphaMatrix = ones(size(data))*0.75;
alphaMatrix(data==0) = 0;

kmlFileName = 'Dust_301.kml';

% make the custom colormap
cmap = [0,0,1;1,0,0];

figure
imagesc(x,y,data,[cLimLow,cLimHigh]);
colormap(cmap)
colorbar

output = ge_imagesc(x,y,data,...
                    'imgURL','Dust_301.png',...
                   'cLimLow',cLimLow,...
                  'cLimHigh',cLimHigh,...
                  'altitude',altitude,...
              'altitudeMode','clampToGround',...
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
north = 39.9949317428787;
south = 10.0065163418805;
east = 59.9944665088319;
west = 30.0055330666120;
k = kml([FileName, '.kml']);
k.overlay(west,east,south,north, 'file',[FileName '.png']);
k.run;