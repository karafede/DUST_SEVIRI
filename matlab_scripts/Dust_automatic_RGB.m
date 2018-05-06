clear
clc
c = clock;
c(3)=c(3) - 2;
RGB = zeros(1500,1500,1);
for k = 2:3
    A1=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\R01\R01_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'));
    A2=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\R02\R02_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'));
    A3=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\R03\R03_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'));
    fields1=fieldnames(A1);
    fields2=fieldnames(A2);
    fields3=fieldnames(A3);
    
    for kk=1:24
        Red = mat2gray(A3.(fields3{1})(:,:,kk));
        Green = mat2gray(A2.(fields2{1})(:,:,kk));
        Blue = mat2gray(A1.(fields1{1})(:,:,kk));
        RGB = cat(3,Red,Green,Blue);
        
        imwrite(RGB, sprintf('%s%d%2.2d%2.2d_P%d_%2.2d.jpg','D:\Academics\Research\Remote Sensing\Dust_automatic_RGB\RGB_',c(1),c(2),c(3),k,kk));
        
    end  
            
end

