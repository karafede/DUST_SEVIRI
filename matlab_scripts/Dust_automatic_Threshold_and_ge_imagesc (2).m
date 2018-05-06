%1. In Task Scheduler, click on "Create Task...".
%2. In the Trigger tab, click "New...". Set the name and trigger time, etc.
%3. In the Actions tab, click "New...". The "Action" should be kept as "Start a program".
%4. For "Program/script", use "Browse..." to find the Matlab executable, which should set a value like: "C:\Program Files\MATLAB\R2011a\bin\matlab.exe".
%5. Set arguments to: -r scriptname;quit. You do not need the .m if that's the script extension.
%6. Set the "Start in" value as the directory containing the script file, e.g.: C:\Folder.

clear
clc

a = [2014 2 24 12 0 0];
a=datenum(a);
time = datevec(a);
% time = datevec(now);

kk = (time(4) * 60 + time(5)) / 15 + 1;
k = floor((kk + 23) / 24);
kk = mod(kk,24);
kk(kk ==0) = 24;

for t = 1:6
    c = a - t;
%     c = now - t;
    
        checkfileA1 = exist(['\\10.106.67.26\matlab-data\EUMETSAT\T10\T10_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'],'file');
        checkfileA2 = exist(['\\10.106.67.26\matlab-data\EUMETSAT\T09\T09_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'],'file');
        checkfileA3 = exist(['\\10.106.67.26\matlab-data\EUMETSAT\T07\T07_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'],'file');
        checkfileA4 = exist(['\\10.106.67.26\matlab-data\EUMETSAT\T04\T04_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'],'file');
        checkfileA5 = exist(['\\10.106.67.26\matlab-data\EUMETSAT\R01\R01_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'],'file');
        checkfileA6 = exist(['\\10.106.67.26\matlab-data\EUMETSAT\R03\R03_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'],'file');
        if checkfileA1 ~= 0 && checkfileA2 ~= 0 && checkfileA3 ~= 0 && checkfileA4 ~= 0 && checkfileA5 ~= 0 && checkfileA6 ~= 0
             A1=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T10\T10_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'));
             A2=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T09\T09_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'));
             A3=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T07\T07_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'));
             A4=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T04\T04_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'));
             A5=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\R01\R01_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'));
             A6=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\R03\R03_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'));
             fields1=fieldnames(A1);
             fields2=fieldnames(A2);
             fields3=fieldnames(A3);
             fields4=fieldnames(A4);
             fields5=fieldnames(A5);
             fields6=fieldnames(A6);
             isempty1 = isempty(A1.(fields1{1})(:,:,kk));
             isempty2 = isempty(A2.(fields2{1})(:,:,kk));
             isempty3 = isempty(A3.(fields3{1})(:,:,kk));
             isempty4 = isempty(A4.(fields4{1})(:,:,kk));
             isempty5 = isempty(A5.(fields5{1})(:,:,kk));
             isempty6 = isempty(A6.(fields6{1})(:,:,kk));
             is01 = A1.(fields1{1})(:,:,kk);
             is02 = A2.(fields2{1})(:,:,kk);
             is03 = A3.(fields3{1})(:,:,kk);
             is04 = A4.(fields4{1})(:,:,kk);
             is05 = A5.(fields5{1})(:,:,kk);
             is06 = A6.(fields6{1})(:,:,kk);
             if isempty1 == 0 && isempty2 == 0 && isempty3 == 0 && isempty4 == 0 && isempty5 == 0 && isempty6 == 0 
                 if any(is01(:)) == 1 && any(is02(:)) == 1 && any(is03(:)) == 1 && any(is04(:)) == 1 && any(is05(:)) == 1 && any(is06(:)) == 1 
                     TB039_TB108 = A4.(fields4{1})(:,:,kk) - A2.(fields2{1})(:,:,kk);
                     TB120_TB108 = A1.(fields1{1})(:,:,kk) - A2.(fields2{1})(:,:,kk);
                     R006_R016 = A5.(fields5{1})(:,:,kk) ./ A6.(fields6{1})(:,:,kk);
                     R01_P3 = A5.(fields5{1})(:,:,kk);
                     TB087_TB108 = A3.(fields3{1})(:,:,kk) - A2.(fields2{1})(:,:,kk);
        
                     Dust = ((((TB039_TB108 > -10) & (TB120_TB108 > 2.5)) | ((TB039_TB108 > 12) & (TB120_TB108 > 0.6))) | (((TB120_TB108 > -1) & (TB087_TB108 > -1) &  (R006_R016 < 0.8)) | ((TB120_TB108 > -1) & (TB087_TB108 > min(-1,2.5-0.18*R01_P3)) & (R006_R016 < 0.7))));
                     if any(Dust) == 1
                         break
                     end
                 end
             end
        end
   
end

        
Dust = double(Dust);
        
filename = ['D:\Academics\Research\Remote Sensing\Dust_automatic_Threshold\RGB_Mask_',datestr(c,'yyyymmdd'),'_P',num2str(k),'_',num2str(kk,'%02d')];
        
save(filename,'Dust')
        
load \\10.106.67.26\matlab-data\EUMETSAT\LAT_LONG\LONG_20110518;
load \\10.106.67.26\matlab-data\EUMETSAT\LAT_LONG\LAT_20110518;   

data=Dust;

% Interpolation
X1 = (flipud(LAT(:,1)))';
Y1 = LONG(1,:);
[X Y] = ndgrid(X1,Y1);
V = flipud(data);
Xq1 = linspace(min(LAT(:)),max(LAT(:)),1500);
Yq1 = linspace(min(LONG(:)),max(LONG(:)),1500);
[Xq Yq] = ndgrid(Xq1,Yq1);
F = griddedInterpolant(X,Y,V,'spline');
Vq = F(Xq,Yq);
data = flipud(Vq);

data = data>0.5 & data<1.5;
data = double(data);

x = Yq1;
y = Xq1;

cLimLow = min(min(data));
cLimHigh = max(max(data));
altitude = 36000;
alphaMatrix = ones(size(data))*0.95;
alphaMatrix(data==0) = 0;

kmlFileName = ['Dust_',datestr(c,'yyyymmdd'),'_P',num2str(k),'_',num2str(kk,'%02d'),'.kml'];
pngFileName = ['Dust_',datestr(c,'yyyymmdd'),'_P',num2str(k),'_',num2str(kk,'%02d'),'.png'];
% make the custom colormap
cmap = [0,0,1;1,0,0];
% cmap = colormap;

figure
imagesc(x,y,data,[cLimLow,cLimHigh]);
colormap(cmap)
colorbar

output = ge_imagesc(x,y,data,...
                    'imgURL',pngFileName,...
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

FileName = ['Dust_',datestr(c,'yyyymmdd'),'_P',num2str(k),'_',num2str(kk,'%02d')];
north = 40.0049;
south = 9.9965;
east = 60.0045;
west = 29.9955;
k = kml([FileName, '.kml']);
k.overlay(west,east,south,north, 'file',[FileName '.png']);
k.run;