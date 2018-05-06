clc
clear

n1 = datenum(2012,03,01);
n2 = datenum(2012,03,31);

DateVectorNewYear = datevec(n1);
Year = DateVectorNewYear(1);
NewYear = datenum(Year,01,01);
d1 = n1 - NewYear + 1;
d2 = n2 - NewYear + 1;
 
Dust_raster_2012 = zeros(1500);
[BTDref{1:96}] = deal(zeros(1500) - 500);
[Dust_2012{1:96}] = deal(zeros(1500));
[Dust_daily_2012{d1:d2}] = deal(zeros(1500));

count = 0;

for n = n1:n2
    Dust_daily = zeros(1500);
    [BTDref{1:96}] = deal(zeros(1500) - 500);
    count = n - NewYear + 1;
    for t = n - 15:n - 1
        count1 = 0;
        for k = 1:4
            clearvars A1 A2 fields1 fields2
            checkfileA1 = exist(['\\10.106.67.26\matlab-data\EUMETSAT\T07\T07_',datestr(t,'yyyymmdd'),'_P',num2str(k),'.mat'],'file');
            checkfileA2 = exist(['\\10.106.67.26\matlab-data\EUMETSAT\T09\T09_',datestr(t,'yyyymmdd'),'_P',num2str(k),'.mat'],'file');
            if checkfileA1 ~= 0 && checkfileA2 ~= 0
                A1=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T07\T07_',datestr(t,'yyyymmdd'),'_P',num2str(k),'.mat'));
                A2=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T09\T09_',datestr(t,'yyyymmdd'),'_P',num2str(k),'.mat'));
                fields1=fieldnames(A1);
                fields2=fieldnames(A2);
            else
                count1 = count1 + 24;
            continue
            end
            l = min([size(A1.(fields1{1}),3),size(A2.(fields2{1}),3)]);
            if l > 24
                l = 24;
            end
                
            for ii = 1:l
                count1 = count1 + 1;
                clearvars BTD108_087
                if A1.(fields1{1})(:,:,ii) == 0 | A2.(fields2{1})(:,:,ii) == 0
                    continue
                else
                    BTD108_087 = A2.(fields2{1})(:,:,ii) - A1.(fields1{1})(:,:,ii);
                    BTDref{count1} = max(cat(3,BTDref{count1},BTD108_087),[],3);
                end
            end
            count1 = count1 + (24 - ii);
        end
    
    end

count2 = 0;
for m = 1:4
    clearvars B1 B2 B3 fields1 fields2 fields3
    checkfileB1 = exist(['\\10.106.67.26\matlab-data\EUMETSAT\T10\T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'],'file');
    checkfileB2 = exist(['\\10.106.67.26\matlab-data\EUMETSAT\T09\T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'],'file');
    checkfileB3 = exist(['\\10.106.67.26\matlab-data\EUMETSAT\T07\T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'],'file');
    
    if checkfileB1 ~= 0 && checkfileB2 ~= 0 && checkfileB3 ~= 0
        
        B1 = load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T10\T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
        B2 = load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T09\T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
        B3 = load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T07\T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
        fields1=fieldnames(B1);
        fields2=fieldnames(B2);
        fields3=fieldnames(B3);
    else
        count2 = count2 + 24;
        continue
    end
    
    p = min([size(B1.(fields1{1}),3),size(B2.(fields2{1}),3),size(B3.(fields3{1}),3)]);
    if p > 24
        p = 24;
    end
    
    for jj = 1:p
        clearvars BT108 BT120_BT108 BT108_BT087 BTD108_087anom
        count2 = count2 + 1;
        if B1.(fields1{1})(:,:,jj) == 0 | B2.(fields2{1})(:,:,jj) == 0 | B3.(fields3{1})(:,:,jj) == 0
            Dust_2012{count2} = nan(1500);
            continue
        else
            BT108 = B2.(fields2{1})(:,:,jj);
            BT120_BT108 = B1.(fields1{1})(:,:,jj) - B2.(fields2{1})(:,:,jj);
            BT108_BT087 = B2.(fields2{1})(:,:,jj) - B3.(fields3{1})(:,:,jj);
            BTD108_087anom = BT108_BT087 - BTDref{count2};
            Dust_2012{count2} = ((BT108 >= 285) & (BT120_BT108 >= 0) & (BT108_BT087 <= 10) & (BTD108_087anom <= -2));
            Dust_daily = sum(cat(3,Dust_daily,Dust_2012{count2}),3);
        end
    end
    count2 = count2 + (24 - jj);
end

    Dust_daily_2012{count} = Dust_daily;
    Dust_raster_2012 = cat(3,Dust_raster_2012,Dust_daily_2012{count});

end

Dust_raster_2012 = sum(Dust_raster_2012,3);
save ('Dust_SDF_frequency_2012_3_end','Dust_daily_2012','-v7.3')
save ('Dust_SDF_frequency_raster_2012_3_end','Dust_raster_2012')