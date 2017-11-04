
clear
clc
RGB = zeros(1500,1500,1);
for k = 2:3
    %reading of channels for RBG ceation 
    
   % A1=load(strcat('X:\EUMETSAT\R01\R01_20150604_P',num2str(k),'.mat'));
   % A2=load(strcat('X:\EUMETSAT\R02\R02_20150604_P',num2str(k),'.mat'));
   % A3=load(strcat('X:\EUMETSAT\R03\R03_20150604_P',num2str(k),'.mat'));
    A1=load(strcat('E:\MASDAR_FK\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\R01_20150402_P',num2str(k),'.mat'));
    A2=load(strcat('E:\MASDAR_FK\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\R02_20150402_P',num2str(k),'.mat'));
    A3=load(strcat('E:\MASDAR_FK\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\R03_20150402_P',num2str(k),'.mat'));
    fields1=fieldnames(A1);
    fields2=fieldnames(A2);
    fields3=fieldnames(A3);
    
    for kk=1:24
        Red = mat2gray(A3.(fields3{1})(:,:,kk));
        Green = mat2gray(A2.(fields2{1})(:,:,kk));
        Blue = mat2gray(A1.(fields1{1})(:,:,kk));
        RGB = cat(3,Red,Green,Blue);
        
     %   imagesc(RGB);   
      %  title(kk)
      %  pause(.5)
   % end
        
        imwrite(RGB, sprintf('RGB_20150402_%d%2.2d.jpg',k,kk));

        % fog detection goes here; and output should "fog" that should
        % multiply a static or updated RGB
         %fog = double(fog);
        %fog(fog==0) = nan;
    end  
            
end




cc = 0;
Animation_RGB(29) = struct('cdata',[],'colormap',[]);
for t=2:3
    if t == 2
        for tt = 5:24
            A = imread(sprintf('RGB_%d%2.2d.jpg',t,tt));
            cc = cc + 1;
            Animation_RGB(cc) = immovie(A);
        end
    else
        for tt = 1:9
            A = imread(sprintf('RGB_%d%2.2d.jpg',t,tt));
            cc = cc + 1;
            Animation_RGB(cc) = immovie(A);
        end
    end
end

implay(Animation_RGB,2);

web('RGB_Movie.gif')
