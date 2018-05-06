clc
clear
load \\10.106.67.26\matlab-data\EUMETSAT\T11\T11_20120226_P3;
load \\10.106.67.26\matlab-data\EUMETSAT\T10\T10_20120226_P3;
load \\10.106.67.26\matlab-data\EUMETSAT\T09\T09_20120226_P3;
load \\10.106.67.26\matlab-data\EUMETSAT\T07\T07_20120226_P3;
load \\10.106.67.26\matlab-data\EUMETSAT\T04\T04_20120226_P3;

x=1:1500;
y134=T11_P3(1250,:,1);
y120=T10_P3(1250,:,1);
y108=T09_P3(1250,:,1);
y087=T07_P3(1250,:,1);
y039=T04_P3(1250,:,1);
plot(x,y134,'k',x,y120,'r',x,y108,'m',x,y087,'b',x,y039,'g')
l=legend('T134','T120','T108','T087','T039');