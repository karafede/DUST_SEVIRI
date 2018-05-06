clc
clear

n1 = datenum(2004,05,01);
n2 = datenum(2004,05,31);

 
Dust_raster = zeros(298,696);
[BTDref{1:61}] = deal(zeros(298,696));
[Dust{1:61}] = deal(zeros(298,696));
[Dust_daily_sum{1:366}] = deal(zeros(298,696));

count = 0;

for n = n1:n2
    count = count + 1;
    Dust_daily = zeros(298,696);
    DateVectorNewYear = datevec(n);
    Year = DateVectorNewYear(1);
    n3 = datenum(Year,01,01);
    for t = n - 15:n - 1
        DateVectorNewYear1 = datevec(t);
        Year1 = DateVectorNewYear1(1);
        t1 = datenum(Year1,01,01);
    
        checkfileA1 = exist(['\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(t,'yyyy'),'\',sprintf('%.3d',t-t1+1),'\T07',sprintf('%.3d',t-t1+1),'.mat'],'file');
        checkfileA2 = exist(['\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(t,'yyyy'),'\',sprintf('%.3d',t-t1+1),'\T09',sprintf('%.3d',t-t1+1),'.mat'],'file');
        
        if checkfileA1 ~= 0 && checkfileA2 ~= 0
            A1=load(strcat('\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(t,'yyyy'),'\',sprintf('%.3d',t-t1+1),'\T07',sprintf('%.3d',t-t1+1),'.mat'));
            A2=load(strcat('\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(t,'yyyy'),'\',sprintf('%.3d',t-t1+1),'\T09',sprintf('%.3d',t-t1+1),'.mat'));
            fields1=fieldnames(A1);
            fields2=fieldnames(A2);
        else
            continue
        end
        
        l = min([size(A1.(fields1{1}),3),size(A2.(fields2{1}),3)]);
        if l > 61
            l = 61;
        end
        
        if t == n - 15 
            for ii = 1:l
                clearvars A11 A22
                A11 = A1.(fields1{1})(:,:,ii);
                A11(isnan(A11)) = 0;
                A22 = A2.(fields2{1})(:,:,ii);
                A22(isnan(A22)) = 0;
                BTDref{ii} = A22 - A11;
            end
        else
            for ii = 1:l
                clearvars A11 A22 BTD108_087
                A11 = A1.(fields1{1})(:,:,ii);
                A11(isnan(A11)) = 0;
                A22 = A2.(fields2{1})(:,:,ii);
                A22(isnan(A22)) = 0;
                BTD108_087 = A22 - A11;
                BTDref{ii} = max(cat(3,BTDref{ii},BTD108_087),[],3);
            end
        end
            
    end

    checkfileB1 = exist(['\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(n,'yyyy'),'\',sprintf('%.3d',n-n3+1),'\T10',sprintf('%.3d',n-n3+1),'.mat'],'file');
    checkfileB2 = exist(['\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(n,'yyyy'),'\',sprintf('%.3d',n-n3+1),'\T09',sprintf('%.3d',n-n3+1),'.mat'],'file');
    checkfileB3 = exist(['\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(n,'yyyy'),'\',sprintf('%.3d',n-n3+1),'\T07',sprintf('%.3d',n-n3+1),'.mat'],'file');
    
    if checkfileB1 ~= 0 && checkfileB2 ~= 0 && checkfileB3 ~= 0
        
        B1 = load(strcat('\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(n,'yyyy'),'\',sprintf('%.3d',n-n3+1),'\T10',sprintf('%.3d',n-n3+1),'.mat'));
        B2 = load(strcat('\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(n,'yyyy'),'\',sprintf('%.3d',n-n3+1),'\T09',sprintf('%.3d',n-n3+1),'.mat'));
        B3 = load(strcat('\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(n,'yyyy'),'\',sprintf('%.3d',n-n3+1),'\T07',sprintf('%.3d',n-n3+1),'.mat'));
        fields1=fieldnames(B1);
        fields2=fieldnames(B2);
        fields3=fieldnames(B3);
    else
        continue
    end
    
    p = min([size(B1.(fields1{1}),3),size(B2.(fields2{1}),3),size(B3.(fields3{1}),3)]);
    if p > 61
        p = 61;
    end
    
    for jj = 1:p
        clearvars B11 B22 B33 BT108 BT120_BT108 BT108_BT087 BTD108_087anom
        B11 = B1.(fields1{1})(:,:,jj);
        B11(isnan(B11)) = 0;
        B22 = B2.(fields2{1})(:,:,jj);
        B22(isnan(B22)) = 0;
        B33 = B3.(fields3{1})(:,:,jj);
        B33(isnan(B33)) = 0;
        BT108 = B22;
        BT120_BT108 = B11 - B22;
        BT108_BT087 = B22 - B33;
        BTD108_087anom = BT108_BT087 - BTDref{jj};
        Dust{jj} = ((BT108 >= 285) & (BT120_BT108 >= 0) & (BT108_BT087 <= 10) & (BTD108_087anom <= -2));
        Dust_daily = sum(cat(3,Dust_daily,Dust{jj}),3);
    end
    
    Dust_daily_sum{count} = Dust_daily;
    Dust_raster = cat(3,Dust_raster,Dust_daily_sum{count});

end

Dust_raster = sum(Dust_raster,3);
save ('Dust_SDF_frequency_2004_5','Dust_daily_sum','-v7.3')
save ('Dust_SDF_frequency_raster_2004_5','Dust_raster')