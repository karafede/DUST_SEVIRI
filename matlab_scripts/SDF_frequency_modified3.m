clc
clear

n1 = datenum(2013,01,01);
n2 = datenum(2013,01,02);

[Dust_monthly{1:12}] = deal(zeros(1500));
[Missing_layer_counter{1:12}] = deal(zeros(1));
[BTDref{1:96}] = deal(zeros(1500) - 500);
[Dust_daily_sum{1:366}] = deal(zeros(1500));
[Dust_daily_each_time_step{1:366,1:96}] = deal(zeros(1500));
Missing_file = cell(5,1);
Missing_index = cell(5,1);

count = 0;
count3 = 0;
count4 = 0;

for n = n1:n2
    DateVector = datevec(n);
    count = count + 1;
    for t = n - 15:n - 1
        count1 = 0;
        for k = 1:4
            clearvars A1 A2 fields1 fields2
            try
                A1=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T07\T07_',datestr(t,'yyyymmdd'),'_P',num2str(k),'.mat'));
                fields1=fieldnames(A1);
                A2=load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T09\T09_',datestr(t,'yyyymmdd'),'_P',num2str(k),'.mat'));
                fields2=fieldnames(A2);
            catch
                count1 = count1 + 24;
            continue
            end
            try
                for ii = 1:24
                    clearvars BTD108_087
                    count1 = count1 + 1;
                    if A1.(fields1{1})(:,:,ii) == 0 | A2.(fields2{1})(:,:,ii) == 0
                        continue
                    else
                        BTD108_087 = A2.(fields2{1})(:,:,ii) - A1.(fields1{1})(:,:,ii);
                        BTDref{count1} = max(cat(3,BTDref{count1},BTD108_087),[],3);
                    end
                end
            catch
                count1 = count1 + (24 - ii);
                continue
            end
        end
    end
    
    count2 = 0;
    for m = 1:4
        clearvars B1 B2 B3 fields1 fields2 fields3
        try
            B1 = load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T10\T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields1=fieldnames(B1);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        try
            B2 = load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T09\T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields2=fieldnames(B2);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        try
            B3 = load(strcat('\\10.106.67.26\matlab-data\EUMETSAT\T07\T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields3=fieldnames(B3);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        
        if exist('B1','var') == 0 && exist('B2','var') == 0 && exist('B3','var') == 0
            Missing_layer_counter{DateVector(2)} = Missing_layer_counter{DateVector(2)} + 24;
            continue
        end
        
        try
            for jj = 1:24
                clearvars BT108 BT120_BT108 BT108_BT087 BTD108_087anom
                count2 = count2 + 1;
                if B1.(fields1{1})(:,:,jj) == 0 | B2.(fields2{1})(:,:,jj) == 0 | B3.(fields3{1})(:,:,jj) == 0
                    Dust_daily_each_time_step{count,count2} = nan(1500);
                    continue
                else
                    BT108 = B2.(fields2{1})(:,:,jj);
                    BT120_BT108 = B1.(fields1{1})(:,:,jj) - B2.(fields2{1})(:,:,jj);
                    BT108_BT087 = B2.(fields2{1})(:,:,jj) - B3.(fields3{1})(:,:,jj);
                    BTD108_087anom = BT108_BT087 - BTDref{count2};
                    Dust_daily_each_time_step{count,count2} = ((BT108 >= 285) & (BT120_BT108 >= 0) & (BT108_BT087 <= 10) & (BTD108_087anom <= -2));
                    Dust_daily_sum{count} = sum(cat(3,Dust_daily_sum{count},Dust_daily_each_time_step{count,count2}),3);
                end
            end
        catch
            Missing_layer_counter{DateVector(2)} = Missing_layer_counter{DateVector(2)} + ((24 - jj) + 1);
            count2 = count2 + (24 - jj);
            clearvars sb1 sb2 sb3 
            if exist('B1','var') == 1 && jj < 24
                sb1 = size(B1.(fields1{1}),3);
                if sb1 < 24
                    count4 = count4 + 1;
                    Missing_index{count4} = strcat('T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'_>=',num2str(sb1+1),'.mat');
                end
            end
            if exist('B2','var') == 1 && jj < 24
                sb2 = size(B2.(fields2{1}),3);
                if sb2 < 24
                    count4 = count4 + 1;
                    Missing_index{count4} = strcat('T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'_>=',num2str(sb2+1),'.mat');
                end
            end
            if exist('B3','var') == 1 && jj < 24
                sb3 = size(B3.(fields3{1}),3);
                if sb3 < 24
                    count4 = count4 + 1;
                    Missing_index{count4} = strcat('T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'_>=',num2str(sb3+1),'.mat');
                end
            end
            continue
        end
    
    end
    
    Dust_monthly{DateVector(2)} = sum(cat(3,Dust_monthly{DateVector(2)},Dust_daily_sum{count}),3);
    
end

% save ('Dust_daily_SDF_2012_1_new','Dust_daily_each_time_step','-v7.3')
% save ('Dust_SDF_frequency_2012_1_new','Dust_daily_sum','-v7.3')
% save ('Dust_SDF_frequency_raster_2012_1_new','Dust_monthly')
% save ('Missing_layer_counter_2012_1_new','Missing_layer_counter')
% save ('Missing_file_2012_1_new','Missing_file')
% save ('Missing_index_2012_1_new','Missing_index')
