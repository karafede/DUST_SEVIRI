%1. In Task Scheduler, click on "Create Task...".
%2. In the Trigger tab, click "New...". Set the name and trigger time, etc.
%3. In the Actions tab, click "New...". The "Action" should be kept as "Start a program".
%4. For "Program/script", use "Browse..." to find the Matlab executable, which should set a value like: "C:\Program Files\MATLAB\R2011a\bin\matlab.exe".
%5. Set arguments to: -r scriptname;quit. You do not need the .m if that's the script extension.
%6. Set the "Start in" value as the directory containing the script file, e.g.: C:\Folder.


clear
clc
c = clock;
c(3)=c(3) - 2;
Dust = zeros(1500*1500,1);
for k = 2:3
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

    for kk=1:24
        TB039_TB108 = A4.(fields4{1})(:,:,kk) - A2.(fields2{1})(:,:,kk);
        TB120_TB108 = A1.(fields1{1})(:,:,kk) - A2.(fields2{1})(:,:,kk);
        R006_R016 = A5.(fields5{1})(:,:,kk) ./ A6.(fields6{1})(:,:,kk);
        R01_P3 = A5.(fields5{1})(:,:,kk);
        TB087_TB108 = A3.(fields3{1})(:,:,kk) - A2.(fields2{1})(:,:,kk);
        
        Dust = ((((TB039_TB108 > -10) & (TB120_TB108 > 2.5)) | ((TB039_TB108 > 12) & (TB120_TB108 > 0.6))) | (((TB120_TB108 > -1) & (TB087_TB108 > -1) &  (R006_R016 < 0.8)) | ((TB120_TB108 > -1) & (TB087_TB108 > min(-1,2.5-0.18*R01_P3)) & (R006_R016 < 0.7))));
        
        Dust = double(Dust);
        Dust(Dust==0) = nan;
        
        if kk < 10
            filename = ['D:\Academics\Research\Remote Sensing\Dust_automatic_Threshold\RGB_Mask_',datestr(c,'yyyymmdd'),'_P',num2str(k),'_',num2str(0),num2str(kk)];
        else
            filename = ['D:\Academics\Research\Remote Sensing\Dust_automatic_Threshold\RGB_Mask_',datestr(c,'yyyymmdd'),'_P',num2str(k),'_',num2str(kk)];
        end
        
        save(filename,'Dust')
        
    end
end






