%%%% file modified by Federico Karagulian (6 April 2017)
%%%% inputs from Dawit & Marouane
%%%% THIS SCRIPT GENERATES RGB IMAGES WITH MASK FOR DUST FLAGS3

clear
clc

n1 = datenum(2015,04,02);
n2 = datenum(2015,04,02);
Dust=zeros(1500,1500);

for n = n1:n2
    for m = 1:4 % to loop in the quarter files of the day
        clearvars A1 A2 A3 A4 A5 A6 fields1 fields2 fields3 fields4 fields5 fields6
        for jj = 1:24
            checkfileA1 = exist(['Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'],'file');
            checkfileA2 = exist(['Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'],'file');
            checkfileA3 = exist(['Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'],'file');
            checkfileA4 = exist(['Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T04_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'],'file');
            checkfileA5 = exist(['Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\R01_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'],'file');
            checkfileA6 = exist(['Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\R03_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'],'file');
            if checkfileA1 ~= 0 && checkfileA2 ~= 0 && checkfileA3 ~= 0 && checkfileA4 ~= 0 && checkfileA5 ~= 0 && checkfileA6 ~= 0
                A1=load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
                A2=load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
                A3=load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
                A4=load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T04_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
                A5=load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\R01_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
                A6=load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\R03_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
                fields1=fieldnames(A1);
                fields2=fieldnames(A2);
                fields3=fieldnames(A3);
                fields4=fieldnames(A4);
                fields5=fieldnames(A5);
                fields6=fieldnames(A6);
                isempty1 = isempty(A1.(fields1{1})(:,:,jj));
                isempty2 = isempty(A2.(fields2{1})(:,:,jj));
                isempty3 = isempty(A3.(fields3{1})(:,:,jj));
                isempty4 = isempty(A4.(fields4{1})(:,:,jj));
                isempty5 = isempty(A5.(fields5{1})(:,:,jj));
                isempty6 = isempty(A6.(fields6{1})(:,:,jj));
                is01 = A1.(fields1{1})(:,:,jj);
                is02 = A2.(fields2{1})(:,:,jj);
                is03 = A3.(fields3{1})(:,:,jj);
                is04 = A4.(fields4{1})(:,:,jj);
                is05 = A5.(fields5{1})(:,:,jj);
                is06 = A6.(fields6{1})(:,:,jj);
                if isempty1 == 0 && isempty2 == 0 && isempty3 == 0 && isempty4 == 0 && isempty5 == 0 && isempty6 == 0
                    if any(is01(:)) == 1 && any(is02(:)) == 1 && any(is03(:)) == 1 && any(is04(:)) == 1 && any(is05(:)) == 1 && any(is06(:)) == 1
                        TB039_TB108 = A4.(fields4{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
                        TB120_TB108 = A1.(fields1{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
                        R006_R016 = A5.(fields5{1})(:,:,jj) ./ A6.(fields6{1})(:,:,jj);
                        R01_P3 = A5.(fields5{1})(:,:,jj);
                        TB087_TB108 = A3.(fields3{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
                        
                        idx = ((((TB039_TB108 > -10) & (TB120_TB108 > 2.5)) | ((TB039_TB108 > 12) & (TB120_TB108 > 0.6))) | (((TB120_TB108 > -1) & (TB087_TB108 > -1) &  (R006_R016 < 0.8)) | ((TB120_TB108 > -1) & (TB087_TB108 > min(-1,2.5-0.18*R01_P3)) & (R006_R016 < 0.7))));
                        Dust(idx)=1;
                        %if any(Dust) == 1
                        %    break
                        %end
                    end
                end
            end
            Dust = double(Dust);
            imagesc(Dust)
            
             filename = ['Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\output_20150402_new\RGB_Mask_OLD',datestr(n,'yyyymmdd'),'_P',num2str(m),'_',num2str(jj,'%02d')];
            
            %%% save data in the deirectory defined above
            save(filename,'Dust')
        end
    end
end





%%%%%%%% end of data processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  figure
% imagesc(Dust)
% sum(sum(Dust,2), 1)

load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\LAT_20110518.mat')
load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\LONG_20110518.mat')

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

n=n1;
m=1;
jj=12;

kmlFileName = ['Dust_',datestr(n,'yyyymmdd'),'_P',num2str(m),'_',num2str(jj,'%02d'),'.kml'];
pngFileName = ['Dust_',datestr(n,'yyyymmdd'),'_P',num2str(m),'_',num2str(jj,'%02d'),'.png'];


%%%% make the custom colormap
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