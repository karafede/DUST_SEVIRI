n1 = datenum(2015,04,02);
n2 = datenum(2015,04,02);

% [Dust_monthly{1:12}] = deal(zeros(1500));
%%%% 4 datasets every 15 minutes = 4 x 24 hours = 96......images by day
[BTDref{1:96}] = deal(zeros(1500));
count3 = 0; % counter for the missing files of T07, T09, T10 ...
Missing_file = cell(5,1); % object to collect the missing files
[Missing_layer_counter{1:12}] = deal(zeros(1)); % object to collect the empty files
count = 0; % the number of days
[Dust_daily_sum{1:366}] = deal(zeros(1500)); 
[Dust_daily_each_time_step{1:366,1:96}] = deal(zeros(1500)); % the dust flag for days of the year in row and time of the day in column
Missing_index = cell(5,1); % object that records the missing images within the files T07, T09, T10 ...
[Dust_monthly{1:12}] = deal(zeros(1500));%the sum of the dust flags in the month

for n = n1:n2
    DateVector = datevec(n); 
    count = count + 1;
    %%%% creating the reference object BTDref with 96 images 
    for t = n - 15:n - 1 %% the last 15 days for reference
       count1 = 0;
       for k =1:4    % loop for the quarter of the day (4 files per day)
           % A1 is T07 and A2 is T09
            clearvars A1 A2 fields1 fields2
            try
                A1=load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T07_',datestr(t,'yyyymmdd'),'_P',num2str(k),'.mat'));
                fields1=fieldnames(A1);
                A2=load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T09_',datestr(t,'yyyymmdd'),'_P',num2str(k),'.mat'));
                fields2=fieldnames(A2);
            catch
            end
            try
                if t == n - 15 % check if the first day of ref. no need to maximize
                    for ii = 1:24
                        count1 = count1 + 1;
                        BTDref{count1} = A2.(fields2{1})(:,:,ii) - A1.(fields1{1})(:,:,ii);
                    end
                else
                    for ii = 1:24 % the images of the quarter (24 images per file)
                        clearvars BTD108_087
                        count1 = count1 + 1; % going in to the images
                        BTD108_087 = A2.(fields2{1})(:,:,ii) - A1.(fields1{1})(:,:,ii);
                        BTDref{count1} = max(cat(3,BTDref{count1},BTD108_087),[],3);
                    end
                end
            catch
            end
       end
    end
    %%%% End of creating the reference object BTDref 
    
    
    count2 = 0; % the counter for the final images
    for m = 1:4 % to loop in the quarter files of the day
        % B1 is T10, B2 is T09 and B3 is T07
        clearvars B1 B2 B3 fields1 fields2 fields3
        try
            % importing B1 from the mat file
            B1 = load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields1=fieldnames(B1);
        catch
            % if there is an error then put the filename in Missing_file
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        try
            B2 = load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields2=fieldnames(B2);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        try
            B3 = load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields3=fieldnames(B3);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        
        % counting the missing images of the months 
        if exist('B1','var') == 0 && exist('B2','var') == 0 && exist('B3','var') == 0
            Missing_layer_counter{DateVector(2)} = Missing_layer_counter{DateVector(2)} + 24; % the missing images in the month
            continue
        end
        
        try
            for jj = 1:24
                % the french bread 
                clearvars BT108 BT120_BT108 BT108_BT087 BTD108_087anom
                count2 = count2 + 1;
                BT108 = B2.(fields2{1})(:,:,jj);
                BT120_BT108 = B1.(fields1{1})(:,:,jj) - B2.(fields2{1})(:,:,jj);
                BT108_BT087 = B2.(fields2{1})(:,:,jj) - B3.(fields3{1})(:,:,jj);
                BTD108_087anom = BT108_BT087 - BTDref{count2};
                Dust_daily_each_time_step{count,count2} = ((BT108 >= 285) & (BT120_BT108 >= 0) & (BT108_BT087 <= 10) & (BTD108_087anom <= -2));
                Dust_daily_sum{count} = sum(cat(3,Dust_daily_sum{count},Dust_daily_each_time_step{count,count2}),3);
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
