clear
clc
c = clock;
c(3)=c(3) - 2;
for k = 2:3
    A1=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T10\T10_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'));
    A2=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T09\T09_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'));
    A3=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T07\T07_',datestr(c,'yyyymmdd'),'_P',num2str(k),'.mat'));
    fields1=fieldnames(A1);
    fields2=fieldnames(A2);
    fields3=fieldnames(A3);
    
    for kk=1:24
        
        Red = A1.(fields1{1})(:,:,kk) - A2.(fields2{1})(:,:,kk);
        Green = A2.(fields2{1})(:,:,kk) - A3.(fields3{1})(:,:,kk);
        Blue = A2.(fields2{1})(:,:,kk);
        
        Red = mat2gray(Red,[-4 2]);
        Green = mat2gray(Green,[0 15]);
        Green = Green.^(1/2.5);
        Blue = mat2gray(Blue,[261 289]);
        RGB = cat(3,Red,Green,Blue);
        
        if kk < 10
            filename = ['D:\Academics\Research\Remote Sensing\Dust_automatic_Pink\RGB_Pink_',datestr(c,'yyyymmdd'),'_P',num2str(k),'_',num2str(0),num2str(kk)];
        else
            filename = ['D:\Academics\Research\Remote Sensing\Dust_automatic_Pink\RGB_Pink_',datestr(c,'yyyymmdd'),'_P',num2str(k),'_',num2str(kk)];
        end
      
        save(filename,'RGB')
    end
end

