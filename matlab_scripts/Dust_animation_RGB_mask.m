clear
clc
Dust = zeros(1500*1500,1);
RGB = zeros(1500,1500,1);
layer1 = zeros(1500,1500);
layer2 = zeros(1500,1500);
layer3 = zeros(1500,1500);

for k = 2:3
    A1=load(strcat('X:\EUMETSAT\T10\T10_20120226_P',num2str(k),'.mat'));
    A2=load(strcat('X:\EUMETSAT\T09\T09_20120226_P',num2str(k),'.mat'));
    A3=load(strcat('X:\EUMETSAT\T07\T07_20120226_P',num2str(k),'.mat'));
    A4=load(strcat('X:\EUMETSAT\T04\T04_20120226_P',num2str(k),'.mat'));
    A5=load(strcat('X:\EUMETSAT\R01\R01_20120226_P',num2str(k),'.mat'));
    A6=load(strcat('X:\EUMETSAT\R02\R02_20120226_P',num2str(k),'.mat'));
    A7=load(strcat('X:\EUMETSAT\R03\R03_20120226_P',num2str(k),'.mat'));
    fields1=fieldnames(A1);
    fields2=fieldnames(A2);
    fields3=fieldnames(A3);
    fields4=fieldnames(A4);
    fields5=fieldnames(A5);
    fields6=fieldnames(A6);
    fields7=fieldnames(A7);
    
    for kk=1:24
        TB039_TB108 = A4.(fields4{1})(:,:,kk) - A2.(fields2{1})(:,:,kk);
        TB120_TB108 = A1.(fields1{1})(:,:,kk) - A2.(fields2{1})(:,:,kk);
        R006_R016 = A5.(fields5{1})(:,:,kk) ./ A7.(fields7{1})(:,:,kk);
        R01_P3 = A5.(fields5{1})(:,:,kk);
        TB087_TB108 = A3.(fields3{1})(:,:,kk) - A2.(fields2{1})(:,:,kk);
        
        TB039_TB108 = reshape(TB039_TB108,1500*1500,1);
        TB120_TB108 = reshape(TB120_TB108,1500*1500,1);
        R006_R016 = reshape(R006_R016,1500*1500,1);
        R01_P3 = reshape(R01_P3,1500*1500,1);
        TB087_TB108 = reshape(TB087_TB108,1500*1500,1);
        
        for ii = 1:1500*1500
            Dust(ii) = ((((TB039_TB108(ii) > -10) && (TB120_TB108(ii) > 2.5)) || ((TB039_TB108(ii) > 12) && (TB120_TB108(ii) > 0.6)))|| (((TB120_TB108(ii) > -1) && (TB087_TB108(ii) > -1) &&  (R006_R016(ii) < 0.8)) || ((TB120_TB108(ii) > -1) && (TB087_TB108(ii) > min(-1,2.5-0.18*R01_P3(ii))) && (R006_R016(ii) < 0.7))));
        end
        
        Dust = reshape(Dust,1500,1500);
        Dust = logical(Dust);
                
        Red = mat2gray(A7.(fields7{1})(:,:,kk));
        Green = mat2gray(A6.(fields6{1})(:,:,kk));
        Blue = mat2gray(A5.(fields5{1})(:,:,kk));
        
        RGB = cat(3,Red,Green,Blue);
        
        mask(:,:,1) = Dust;
        mask(:,:,2) = Dust;
        mask(:,:,3) = Dust;
        
        layer1(Dust) = 1;
        layer2(Dust) = 0;
        layer3(Dust) = 1;
        
        layer = cat(3,layer1,layer2,layer3);
        
        RGB(mask) = layer(mask);
        
        imwrite(RGB, sprintf('RGB_mask_%d%2.2d.jpg',k,kk));
    end
end














load Animation
B=Animation(:,:,21);
B1=B==1;
C=imread ('RGB_301.jpg');
mask(:,:,1)=B1;
mask(:,:,2)=B1;
mask(:,:,3)=B1;
C(mask)=nan;

D1=C(:,:,1);
D1(B1)=255;
D2=C(:,:,2);
D2(B1)=0;
D3=C(:,:,3);
D3(B1)=255;
C=cat(3,D1,D2,D3);
image(C)