clc
clear

n1 = datenum(2004,07,01);
n2 = datenum(2004,09,30);

DateVectorNewYear = datevec(n1);
Year = DateVectorNewYear(1);
NewYear = datenum(Year,01,01);
d1 = n1 - NewYear + 1;
d2 = n2 - NewYear + 1;

[Dust_monthly{1:12}] = deal(zeros(298,696));
[Missing_layer_counter{1:12}] = deal(zeros(1));
[BTDref{1:61}] = deal(zeros(298,696) - 500);
[Dust_daily_sum{d1:d2}] = deal(zeros(298,696));
[Dust_daily_each_time_step{d1:d2,1:61}] = deal(zeros(298,696));
Missing_file = cell(5,1);
Missing_index = cell(5,1);
Zeros_layer = cell(5,1);

count = 0;
count1 = 0;
count2 = 0;
count3 = 0;

for n = n1:n2
    [BTDref{1:61}] = deal(zeros(298,696) - 500);
    count = n - NewYear + 1;
    DateVector = datevec(n);
    for t = n - 15:n - 1
        DateVectorNewYear1 = datevec(t);
        Year1 = DateVectorNewYear1(1);
        t1 = datenum(Year1,01,01);
        clearvars A1 A2 fields1 fields2
        try
            A1=load(strcat('\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(t,'yyyy'),'\',sprintf('%.3d',t-t1+1),'\T07',sprintf('%.3d',t-t1+1),'.mat'));
            fields1=fieldnames(A1);
            A2=load(strcat('\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(t,'yyyy'),'\',sprintf('%.3d',t-t1+1),'\T09',sprintf('%.3d',t-t1+1),'.mat'));
            fields2=fieldnames(A2);
        catch
            continue
        end
        
        try
            for ii = 1:61
                clearvars A11 A22 BTD108_087
                A11 = A1.(fields1{1})(:,:,ii);
                A11(isnan(A11)) = 0;
                A22 = A2.(fields2{1})(:,:,ii);
                A22(isnan(A22)) = 0;
                if A11 == 0 | A22 == 0
                    continue
                else
                    BTD108_087 = A22 - A11;
                    BTDref{ii} = max(cat(3,BTDref{ii},BTD108_087),[],3);
                end
            end
            
        catch
            continue
        end
    
    end

    clearvars B1 B2 B3 fields1 fields2 fields3
    try
        B1 = load(strcat('\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(n,'yyyy'),'\',sprintf('%.3d',count),'\T10',sprintf('%.3d',count),'.mat'));
        fields1=fieldnames(B1);
    catch
        count1 = count1 + 1;
        Missing_file{count1} = strcat('T10_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'.mat');
    end
    try
        B2 = load(strcat('\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(n,'yyyy'),'\',sprintf('%.3d',count),'\T09',sprintf('%.3d',count),'.mat'));
        fields2=fieldnames(B2);
    catch
        count1 = count1 + 1;
        Missing_file{count1} = strcat('T09_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'.mat');
    end
    try
        B3 = load(strcat('\\10.106.67.26\matlab-data\Archive_MCIDAS\MCIDAS\',datestr(n,'yyyy'),'\',sprintf('%.3d',count),'\T07',sprintf('%.3d',count),'.mat'));
        fields3=fieldnames(B3);
    catch
        count1 = count1 + 1;
        Missing_file{count1} = strcat('T07_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'.mat');
    end
    
    if exist('B1','var') == 0 && exist('B2','var') == 0 && exist('B3','var') == 0 
        Missing_layer_counter{DateVector(2)} = Missing_layer_counter{DateVector(2)} + 61;
        continue
    end
    
    try
        for jj = 1:61
            clearvars B11 B22 B33 BT108 BT120_BT108 BT108_BT087 BTD108_087anom
            B11 = B1.(fields1{1})(:,:,jj);
            B11(isnan(B11)) = 0;
            B22 = B2.(fields2{1})(:,:,jj);
            B22(isnan(B22)) = 0;
            B33 = B3.(fields3{1})(:,:,jj);
            B33(isnan(B33)) = 0;
            if B11 == 0 | B22 == 0 | B33 == 0
                Dust_daily_each_time_step{count,jj} = nan(298,696);
                if B11 == 0
                    count3 = count3 + 1;
                    Zeros_layer{count3} = strcat('T10_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'_layer',num2str(jj),'.mat');
                end
                if B22 == 0
                    count3 = count3 + 1;
                    Zeros_layer{count3} = strcat('T09_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'_layer',num2str(jj),'.mat');
                end
                if B33 == 0
                    count3 = count3 + 1;
                    Zeros_layer{count3} = strcat('T07_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'_layer',num2str(jj),'.mat');
                end
                continue
            else
                BT108 = B22;
                BT120_BT108 = B11 - B22;
                BT108_BT087 = B22 - B33;
                BTD108_087anom = BT108_BT087 - BTDref{jj};          
                Dust_daily_each_time_step{count,jj} = ((BT108 >= 285) & (BT120_BT108 >= 0) & (BT108_BT087 <= 10) & (BTD108_087anom <= -2));
                Dust_daily_sum{count} = sum(cat(3,Dust_daily_sum{count},Dust_daily_each_time_step{count,jj}),3);
            end
        end
    catch
        Missing_layer_counter{DateVector(2)} = Missing_layer_counter{DateVector(2)} + ((61 - jj) + 1);
        clearvars sb1 sb2 sb3 
        if exist('B1','var') == 1 && jj < 61
            sb1 = size(B1.(fields1{1}),3);
        if sb1 < 61
            count2 = count2 + 1;
            Missing_index{count2} = strcat('T10_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'_>=',num2str(sb1+1),'.mat');
        end
        end
        if exist('B2','var') == 1 && jj < 61
            sb2 = size(B2.(fields2{1}),3);
            if sb2 < 61
                count2 = count2 + 1;
                Missing_index{count2} = strcat('T09_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'_>=',num2str(sb2+1),'.mat');
            end
        end
        if exist('B3','var') == 1 && jj < 61
            sb3 = size(B3.(fields3{1}),3);
            if sb3 < 61
                count2 = count2 + 1;
                Missing_index{count2} = strcat('T07_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'_>=',num2str(sb3+1),'.mat');
            end
        end
        continue
    end
    Dust_monthly{DateVector(2)} = sum(cat(3,Dust_monthly{DateVector(2)},Dust_daily_sum{count}),3);
    
end

save ('Dust_daily_SDF_McIDAS_2004_7to9_end','Dust_daily_each_time_step','-v7.3')
save ('Dust_SDF_frequency_McIDAS_2004_7to9_end','Dust_daily_sum','-v7.3')
save ('Dust_SDF_frequency_raster_McIDAS_2004_7to9_end','Dust_monthly')
save ('Missing_layer_counter_McIDAS_2004_7to9_end','Missing_layer_counter')
save ('Missing_file_McIDAS_2004_7to9_end','Missing_file')
save ('Missing_index_McIDAS_2004_7to9_end','Missing_index')
save ('Zeros_layer_McIDAS_2004_7to9_end','Zeros_layer')