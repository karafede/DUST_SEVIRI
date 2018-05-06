clear
clc
Dust = zeros(1500*1500,1);
for k = 2:3
    A1=load(strcat('X:\EUMETSAT\T10\T10_20120226_P',num2str(k),'.mat'));
    A2=load(strcat('X:\EUMETSAT\T09\T09_20120226_P',num2str(k),'.mat'));
    A3=load(strcat('X:\EUMETSAT\T07\T07_20120226_P',num2str(k),'.mat'));
    A4=load(strcat('X:\EUMETSAT\T04\T04_20120226_P',num2str(k),'.mat'));
    A5=load(strcat('X:\EUMETSAT\R01\R01_20120226_P',num2str(k),'.mat'));
    A6=load(strcat('X:\EUMETSAT\R03\R03_20120226_P',num2str(k),'.mat'));
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
        Dust_anim.(sprintf('Dust_%d%2.2d',k,kk))= Dust;
    end
end

save('Dust_animation.mat','Dust_anim')

for t=2:3
    if t == 2
        for tt = 5:24
            if tt == 5
                Animation = Dust_anim.(sprintf('Dust_%d%2.2d',t,tt));
            else
                Animation = cat(3,Animation,Dust_anim.(sprintf('Dust_%d%2.2d',t,tt)));
            end
        end
    else
        for tt = 1:9
            Animation = cat(3,Animation,Dust_anim.(sprintf('Dust_%d%2.2d',t,tt)));
        end
    end
end

save Animation

for j = 1:17
    imagesc(Animation(:,:,j))
    F(j) = getframe;
end
movie(F,1) % Play the movie twenty times

while 1 %loop indefinitely. Use ctrl-c to break
   for ii=1:29
      imagesc(Animation(:,:,ii))
      axis off
      drawnow
      pause(0.5) %display at about 20 FPS
   end
end    
