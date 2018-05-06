clear
clc
Dust = zeros(1500*1500,1);
for k = 2:3
    F1 = strcat('\\10.106.67.26\matlab-data\EUMETSAT\T10\T10_20120226_P',num2str(k),'.mat');
    F2 = strcat('\\10.106.67.26\matlab-data\EUMETSAT\T09\T09_20120226_P',num2str(k),'.mat');
    F3 = strcat('\\10.106.67.26\matlab-data\EUMETSAT\T07\T07_20120226_P',num2str(k),'.mat');
    F4 = strcat('\\10.106.67.26\matlab-data\EUMETSAT\T04\T04_20120226_P',num2str(k),'.mat');
    F5 = strcat('\\10.106.67.26\matlab-data\EUMETSAT\R01\R01_20120226_P',num2str(k),'.mat');
    F6 = strcat('\\10.106.67.26\matlab-data\EUMETSAT\R02\R02_20120226_P',num2str(k),'.mat');
    F7 = strcat('\\10.106.67.26\matlab-data\EUMETSAT\R03\R03_20120226_P',num2str(k),'.mat');
    A1=load(F1);
    A2=load(F2);
    A3=load(F3);
    A4=load(F4);
    A5=load(F5);
    A6=load(F6);
    A7=load(F7);
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
            if ((((TB039_TB108(ii) > -10) && (TB120_TB108(ii) > 2.5)) || ((TB039_TB108(ii) > 12) && (TB120_TB108(ii) > 0.6)))|| (((TB120_TB108(ii) > -1) && (TB087_TB108(ii) > -1) &&  (R006_R016(ii) < 0.8)) || ((TB120_TB108(ii) > -1) && (TB087_TB108(ii) > min(-1,2.5-0.18*R01_P3(ii))) && (R006_R016(ii) < 0.7))))
                Dust(ii) = 1;
            else
                Dust(ii) = 0;
            end
        end
        Dust = reshape(Dust,1500,1500);
        Dust(Dust==0) = nan;
        fnam=sprintf('Dust_%d%2.2d',k,kk);
        save (fnam,'Dust');
    end
end


for t=2:3
    if t == 2
        for tt = 5:24
            A = load(sprintf('Dust_%d%2.2d',t,tt));
            fields=fieldnames(A);
            if tt == 5
                Animation = A.(fields{1});
            else
                Animation = cat(3,Animation,A.(fields{1}));
            end
        end
    else
        for tt = 1:9
            A = load(sprintf('Dust_%d%2.2d',t,tt));
            fields=fieldnames(A);
            Animation = cat(3,Animation,A.(fields{1}));
        end
    end
end

save Animation
load Animation 

for j = 1:17
    imagesc(Animation(:,:,j))
    F(j) = getframe;
end
movie(F,20) % Play the movie twenty times

while 1 %loop indefinitely. Use ctrl-c to break
   for ii=1:29
      imagesc(Animation(:,:,ii))
      axis off
      drawnow
      pause(0.5) %display at about 20 FPS
   end
end    
