clc
clear
load \\10.106.67.26\matlab-data\EUMETSAT\LAT_LONG\LONG_20110518;
load \\10.106.67.26\matlab-data\EUMETSAT\LAT_LONG\LAT_20110518;

load \\10.106.67.26\matlab-data\EUMETSAT\T11\T11_20120226_P3;

load \\10.106.67.26\matlab-data\EUMETSAT\T10\T10_20120226_P3;
load \\10.106.67.26\matlab-data\EUMETSAT\T09\T09_20120226_P3;
load \\10.106.67.26\matlab-data\EUMETSAT\T07\T07_20120226_P3;

load \\10.106.67.26\matlab-data\EUMETSAT\T04\T04_20120226_P3;

load \\10.106.67.26\matlab-data\EUMETSAT\R01\R01_20120226_P3;
load \\10.106.67.26\matlab-data\EUMETSAT\R02\R02_20120226_P3;
load \\10.106.67.26\matlab-data\EUMETSAT\R03\R03_20120226_P3;

load Z:\Archive_MCIDAS\MCIDAS\2004\204\T10204;

imagesc(T10_P1(:,:,1))
T120_T108=T10_P4(:,:,1) - T09_P4(:,:,1);
imagesc(T120_T108)
hold on
LAT1=(LAT(:,1));
LAT=LAT1(1:250:end,1);
LAT(ceil(1499/250)+1,1)= LAT1(end,1);
LONG1=LONG(1,:);
LONG=LONG1(1,1:250:end);
LONG(1,ceil(1499/250)+1)= LONG1(1,end);
[LONG LAT]=meshgrid(LONG,LAT);
plot(LONG,LAT,LONG',LAT')

%RGB

% Red = Red .^ (1/3);
% Green = Green .^ (1/3);
% Blue = Blue .^ (1/3);
RGB = cat(3,Red,Green,Blue);
image(RGB)

Red1=Red./sqrt(Red.^2+Green.^2+Blue.^2);
Green1=Green./sqrt(Red.^2+Green.^2+Blue.^2);
Blue1=Blue./sqrt(Red.^2+Green.^2+Blue.^2);
RGB1 = cat(3,Red1,Green1,Blue1);
image(RGB1)








%meshgrat
latlim = [-90 90]; 
lonlim = [-180 180];
[lat,lon] = meshgrat(latlim,lonlim,[3 6])



%surfm
figure('Color','white')
load topo
axesm miller
axis off; framem on; gridm on;
[lat,lon] = meshgrat(topo,topolegend,[90 180]);
surfm(lat,lon,topo)
demcmap(topo)

%meshgrat
latlim = [-90 90]; 
lonlim = [-180 180];
[lat,lon] = meshgrat(latlim,lonlim,[3 6])

%meshm
korea = load('korea.mat');
Z = korea.map;
R = georasterref('RasterSize', size(Z), ...
  'Latlim', [30 45], 'Lonlim', [115 135]);
worldmap(Z, R)
meshm(Z, R)
demcmap(Z)

%Normalizing matrix in matlab
mmin = min(M(:));
mmax = max(M(:));
M = (M-mmin) ./ (mmax-mmin); % first subtract mmin to have [0; (mmax-mmin)], then normalize by highest value


TB039_TB108 = T04_P3(:,:,1) - T09_P3(:,:,1);
TB120_TB108 = T10_P3(:,:,1) - T09_P3(:,:,1);
R006_R016 = R01_P3(:,:,1)./R03_P3(:,:,1);
R01_P3 = R01_P3(:,:,1);
TB087_TB108 = T07_P3(:,:,1) - T09_P3(:,:,1);

TB039_TB108 = reshape(TB039_TB108,1500*1500,1);
TB120_TB108 = reshape(TB120_TB108,1500*1500,1);
R006_R016 = reshape(R006_R016,1500*1500,1);
R01_P3 = reshape(R01_P3,1500*1500,1);
TB087_TB108 = reshape(TB087_TB108,1500*1500,1);


Dust = zeros(1500*1500,1);
for ii = 1:1500*1500
if ((((TB039_TB108(ii) > -10) && (TB120_TB108(ii) > 2.5)) || ((TB039_TB108(ii) > 12) && (TB120_TB108(ii) > 0.6)))|| (((TB120_TB108(ii) > -1) && (TB087_TB108(ii) > -1) &&  (R006_R016(ii) < 0.8)) || ((TB120_TB108(ii) > -1) && (TB087_TB108(ii) > min(-1,2.5-0.18*R01_P3(ii))) && (R006_R016(ii) < 0.7))))
    Dust(ii) = 1;
else
    Dust(ii) = 0;
end
end

Dust = reshape(Dust,1500,1500);
Dust(Dust==0) = nan;
imagesc(Dust)



for ii = 1:1500*1500
if (TB039_TB108(ii) > -10) && (TB120_TB108(ii) > 2.5)
    Dust(ii) = 1;
elseif (TB039_TB108(ii) > 12) && (TB120_TB108(ii) > 0.6)
    Dust(ii) = 1;
else
    Dust(ii) = 0;
end
end

Dust = reshape(Dust,1500,1500);
imagesc(Dust)



 

n=10;
tmpl='data_%d%d';
for ii=1:2
     
for i=1:n
     v=rand(1,i);
     fnam=sprintf(tmpl,ii,i);
     save(fnam,'v');
end
end
     dir('data_*.*');
     
A = rand(49,49);
A(:,:,2) = rand(49,49);
A(:,:,3) = rand(49,49);     
     
load mandrill
figure('color','k')
image(X)
colormap(map) 
axis off; % Remove axis ticks and numbers
axis image; % Set aspect ratio to obtain square pixels 


kmlFolder = tempdir;

latlim = [10.0065163418805; 39.9949317428787];
lonlim = [30.0055330666120; 59.9944665088319];

description = sprintf('%s<br>%s</br><br>%s</br>', ...
   '3 Apple Hill Drive', 'Natick, MA. 01760', ...
   'http://www.mathworks.com');

iconDir = fullfile(matlabroot,'toolbox','matlab','icons');
iconFilename = fullfile(iconDir, 'matlabicon.gif');

name = 'The MathWorks, Inc.';

DustFilename = fullfile('C:','Users','tyohannes','Desktop','Academics','Research','Remote Sensing','RGB_Movie_26022012_3.gif');
kmlwrite(filename, lat, lon, ...
   'Description', description, ...
   'Name', name, ...
   'Icon', iconFilename);

winopen(filename)

% this will place an overlay of a random plot over Hawaii.
     plot(1:1:10, rand(10,1), 'w');
     rect = [21.37, 21.36, -157.971, -157.973];
     export_overlay(gcf, 'output.kmz', rect);

k = kml('my kml file');     
warning('off','MATLAB:nonIntegerTruncatedInConversionToChar')     
dimg = pow2(get(0,'DefaultImageCData'),47);     
ee = reshape([47,42,37,36,35,34,33,28,23,18,13,9,5,1,-1,51,46,41,...
              36,35,34,33,32,27,22,16,12,8,4,-1,33.8562,43.3,41.3,...
              54.7167,23.35,17,21.17,33.8562,49.45,41.3,40.4296,...
              35.7143,33.8562,35.0839,-22.007,-85.2163,-70.3504,...
              -72.3504,20.5167,90.7083,17,72.83,-83.2163,11.0833,-70.3504,...
              -79.9191,-83.5102,-84.2163,-106.6186,-47.8974],[15 4]);
en = reshape([111,[1:2]*0+77,72,77,116,97,121,77,56,46,87,97,116,111,108, ...
             [1:2]*0+84,105,84,104,32,111,101,45,46,105,110,104,32,100,...
             [1:2]*0+87,108,87,101,83,117,108,98,46,108,100,101,112,101,...
             [1:2]*0+32,98,[1:2]*0+32,105,110,97,105,32,107,[1:2]*0+32,...
             111,115,[1:2]*0+100,101,111,110,97,103,110,116,111,105,116,...
             111,114,116,[1:2]*0+111,114,108,117,109,101,99,115,[1:2]*0+110,...
             104,114,99,32,[1:2]*0+103,116,100,109,101,115,111,[1:2]*0+32,115,...
             101,105,111,108,[1:4]*0+32,98,115,116,108,115,116,111,32,103,32,...
             105,49,50,109,108,[1:2]*0+101,32,105,116,104,110,98,105,97,116,...
             [1:2]*0+-1,97,111,114,32,108,97,105,101,44,105,110,109,116,...
             [1:2]*0+-1,116,103,-1,109,105,44,108,[1:2]*0+32,103,[1:2]*0+97,...
             108,[1:2]*0+-1,114,111,-1,97,116,32,108,97,71,32,108,114,101,...
             [1:2]*0+-1,105,[1:2]*0+-1,103,116,98,32,114,105,69,32,101,32,...
             [1:2]*0+-1,120,[1:2]*0+-1,105,108,121,114,116,118,100,119,108,69,...
             [1:5]*0+-1,99,101,32,117,32,101,100,97,111,100,[1:5]*0+-1,...
             [1:2]*0+32,65,108,111,110,105,115,44,100,[1:5]*0+-1,115,69,...
             108,101,102,115,110,[1:2]*0+32,105,[1:5]*0+-1,113,100,98,115,...
             [1:2]*0+32,115,97,109,110,[1:5]*0+-1,117,100,114,-1,77,38,-1,...
             108,97,115,[1:5]*0+-1,97,105,101,-1,65,32,-1,119,115,[1:6]*0+-1,...
             114,110,99,-1,84,70,-1,97,32,[1:6]*0+-1,101,115,104,-1,76,111,...
             -1,121,110,[1:8]*0+-1,116,-1,65,114,-1,115,227,[1:8]*0+-1,32,...
             -1,66,115,-1,32,111,[1:8]*0+-1,68,[1:2]*0+-1,121,-1,116,32,...
             [1:8]*0+-1,117,[1:2]*0+-1,116,-1,104,111,[1:8]*0+-1,114,...
             [1:2]*0+-1,104,-1,101,32,[1:8]*0+-1,101,[1:2]*0+-1,101,-1,...
             114,100,[1:8]*0+-1,114,[1:4]*0+-1,101,111,[1:14]*0+-1,32,...
             [1:14]*0+-1,67,[1:14]*0+-1,65,[1:14]*0+-1,65,[1:14]*0+-1,83,...
             [1:14]*0+-1,79],[15 35]);          
for i = 1:size(ee,1)
    fn = sprintf('ee%i.jpg',i);
    if i<size(ee,1)
        img = bitslice(dimg,ee(i,1),ee(i,2));
        img = img-min(img(:))./(max(img(:))-min(img(:)));
        imwrite(img*2^6,gray,fn);
    else
        r = bitslice(dimg,0,0);
        g = bitslice(dimg,17,17);
        b = bitslice(dimg,34,34);

        imwrite(cat(3,r,g,b),fn)
    end
    n = char(en(i,:));
    k.overlay(ee(i,4)-0.5,ee(i,4)+0.5,ee(i,3)-0.5/secd(ee(i,3)),ee(i,3)+0.5/secd(ee(i,3)), ...
              'file',fn,'color','FFFFFFFF','name',n)
end


k.run;
fnn=sprintf('RGB_301.jpg');
imwrite(fn,fnn);
k.overlay(30.0055330666120 +0.5,59.9944665088319-0.5,10.0065163418805+0.5,39.9949317428787-0.5, ...
              'file',fnn,'color','FFFFFFFF','name',char(en(1,:)))
          
          

cmap = [1 1 1;1,0,0];

figure
imagesc(Dust1);
colormap(cmap)



X=LONG;
Y=LAT;
V=R01_P3(:,:,1);
Xq1=LONG(1,:);
Yq1=fliplr(linspace(min(LAT(:)),max(LAT(:)),1500));
[Xq Yq] = meshgrid(Xq1,Yq1);
Vq = interp2(X,Y,V,Xq,Yq,'linear');

[X,Y] = meshgrid(-3:1:3);
V = peaks(X,Y);
surf(X,Y,V)
title('Sample Grid');
a=[-3 -2.5 -1 0.5 1 1.5 3];
[Xq,Yq] = meshgrid(a);
Vq = interp2(X,Y,V,Xq,Yq,'linear');
surf(Xq,Yq,Vq);
title('Refined Grid');

y=zeros(365,1);
err1=zeros(365,1);
for t=2:366
    y(t)=b+a*y(t-1)+err1(t);
end      









 for i = 2:6 %WHY 2 AND NOT 1
    time = now - i; %check several days before today.
    datevector = datevec(time);

    %open ftp server and extract file
    f= ftp('n4ftl01u.ecs.nasa.gov:21');
    cd(f,['/SAN/AMSA/AE_Land3.002/']);
    x = ~isempty(dir(f,[ num2str(datevector(1), '%03d') '.' num2str(datevector(2), '%02d') '.' num2str(datevector(3), '%02d')]));
    
    if (x == 1)
        break
    end

 end
    
 
 [C I]=min(abs(24.442-LAT(:,1)));
 [C1 I1]=min(abs(54.617-LONG(1,:)));
 
 Mezaira_15_AERONET_Original=xlsread ('120101_121231_Mezaira');
 Mezaira_15_AERONET_Original(:,1) = Mezaira_15_AERONET_Original(:,1) + datenum('30-Dec-1899'); 
 save('Masdar_Institute_15_AERONET_Original','Masdar_Institute_15_AERONET_Original')
 
 
 Abu_Al_Bukhoosh_AERONET_SEVIRI_time_all = A.Abu_Al_Bukhoosh_AERONET_Original;
 save('Abu_Al_Bukhoosh_AERONET_SEVIRI_time_all','Abu_Al_Bukhoosh_AERONET_SEVIRI_time_all') 
 
 
 SDF_AOD_Masdar_Institute_15(26016,4);
 
 SDF_AOD_500_Masdar_Institute_15 = SDF_Dust_Flag1;
 SDF_AOD_500_Masdar_Institute_15(2209:11040,:) = SDF_Dust_Flag2;
 SDF_AOD_500_Masdar_Institute_15(11041:19872,:) = SDF_Dust_Flag3;
 SDF_AOD_500_Masdar_Institute_15(19873:26016,:) = SDF_Dust_Flag4;
 save('SDF_AOD_500_Masdar_Institute_15','SDF_AOD_500_Masdar_Institute_15')
 
 
plot(SDF_AOD_500_Masdar_Institute_15(:,1),SDF_AOD_500_Masdar_Institute_15(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_500_Masdar_Institute_15(:,1),SDF_AOD_500_Masdar_Institute_15(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (Jun 2012 - Mar 2013')
ylabel('AOD 500')
l = legend('No SDF','SDF present');
xlim([SDF_AOD_500_Masdar_Institute_15(1,1) SDF_AOD_500_Masdar_Institute_15(26016,1)])
datetick('x','mmm','keeplimits')
title('Masdar Institute 15')

SDF_AOD_500_Mezaira_15 = SDF_Dust_Flag1;
SDF_AOD_500_Mezaira_15(4033:12768,:) = SDF_Dust_Flag2;
SDF_AOD_500_Mezaira_15(12769:13056,:) = SDF_Dust_Flag3;
save('SDF_500_AOD_Mezaira_15','SDF_AOD_500_Mezaira_15')

plot(SDF_AOD_500_Mezaira_15(:,1),SDF_AOD_500_Mezaira_15(:,3),'bo','MarkerFaceColor','b','MarkerSize',4)
hold on
plot(SDF_AOD_500_Mezaira_15(:,1),SDF_AOD_500_Mezaira_15(:,4),'ro','MarkerFaceColor','r','MarkerSize',4)
hold off
xlabel('Time (2012)')
ylabel('AOD 500')
l1 = legend('No SDF','SDF present');
xlim([SDF_AOD_500_Mezaira_15(1,1) SDF_AOD_500_Mezaira_15(9024,1)])
datetick('x','mmm','keeplimits')
title('Mezaira 15')

I4 = find(SDF_Dust_Flag3(:,1) == 0);
SDF_Dust_Flag3(I4,:) = [];



SDF_present_2004to2012 = SDF_present;
clearvars SDF_present

SDF_present_2004to2012 = [SDF_present_2004to2012;SDF_present];
clearvars SDF_present

save('SDF_present_2004to2012','SDF_present_2004to2012')
clear







