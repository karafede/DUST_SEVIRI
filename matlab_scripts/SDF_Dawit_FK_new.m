n1 = datenum(2015,04,01);
n2 = datenum(2015,04,01);

% [Dust_monthly{1:12}] = deal(zeros(1500));
%%%% 4 datasets every 15 minutes = 4 x 24 hours = 96......images by day
% [BTDref{1:96}] = deal(zeros(1500));

count3 = 0; % counter for the missing files of T07, T09, T10 ...
Missing_file = cell(5,1); % object to collect the missing files
[Missing_layer_counter{1:12}] = deal(zeros(1)); % object to collect the empty files
count = 0; % the number of days
% [Dust_daily_sum{1:366}] = deal(zeros(1500)); 
% [Dust_daily_each_time_step{1:366,1:96}] = deal(zeros(1500)); % the dust flag for days of the year in row and time of the day in column
Dust=zeros(1500,1500);
Missing_index = cell(5,1); % object that records the missing images within the files T07, T09, T10 ...
% [Dust_monthly{1:12}] = deal(zeros(1500));%the sum of the dust flags in the month
count4 = 0;

%fake ref
%[BTDref_1{1:96}] = deal(zeros(1500));
for n = n1:n2
    DateVector = datevec(n); 
    count = count + 1;
    
    %%%% creating the reference object BTDref with 96 images 
    %{
    
    
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
                count1 = count1 + 24;
                continue
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
                count1 = count1 + (24 - ii);
                continue
            end
       end
    end
    %%%% End of creating the reference object BTDref 
    % fake ref.
    r = 0.9 + (1.1-0.9).*rand(1500,1500);
    for kk=1:96
        BTDref_1{kk}= BTDref{kk}.*r;
    end
    BTDref=BTDref_1;
    %}
    
    count2 = 0; % the counter for the final images
    for m = 1:4 % to loop in the quarter files of the day
        clearvars A1 A2 A3 A4 A5 A6 fields1 fields2 fields3 fields4 fields5 fields6
        try
            % importing B1 from the mat file
            A1 = load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields1=fieldnames(A1);
        catch
            % if there is an error then put the filename in Missing_file
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        try
            A2 = load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields2=fieldnames(A2);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        try
            A3 = load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields3=fieldnames(A3);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
         try
            A4 = load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\T04_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields4=fieldnames(A4);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T04_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
         end
         try
            A5 = load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\R01_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields5=fieldnames(A5);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('R01_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
         end
         try
            A6 = load(strcat('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\R03_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields6=fieldnames(A6);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('R03_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
       
        % counting the missing images of the months 
        if exist('A1','var') == 0 && exist('A2','var') == 0 && exist('A3','var') == 0 && exist('A4','var') == 0 && exist('A5','var') == 0 && exist('A6','var') == 0
            Missing_layer_counter{DateVector(2)} = Missing_layer_counter{DateVector(2)} + 24; % the missing images in the month
             continue
        end
        
      try
         for jj = 1:24
                % the french bread 
                %%%% DG%%%
                ff=year(n);
                year_num=datenum(ff,01,01);
                day_num= n-year_num;
                %%%%-%%%%%%
                clearvars TB039_TB108 TB120_TB108 R006_R016 R01_P3 TB087_TB108
                count2 = count2 + 1;
                TB039_TB108 = A4.(fields4{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
                TB120_TB108 = A1.(fields1{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
                R006_R016 = A5.(fields5{1})(:,:,jj) ./ A6.(fields6{1})(:,:,jj);
                R01_P3 = A5.(fields5{1})(:,:,jj);
                TB087_TB108 = A3.(fields3{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
     
                % Dust_daily_each_time_step{day_num,count2} = ((((TB039_TB108 > -10) & (TB120_TB108 > 2.5)) | ((TB039_TB108 > 12) & (TB120_TB108 > 0.6))) | (((TB120_TB108 > -1) & (TB087_TB108 > -1) &  (R006_R016 < 0.8)) | ((TB120_TB108 > -1) & (TB087_TB108 > min(-1,2.5-0.18*R01_P3)) & (R006_R016 < 0.7))));
                % Dust_daily_sum{day_num} = sum(cat(3,Dust_daily_sum{day_num},Dust_daily_each_time_step{day_num,count2}),3);
                idx = ((((TB039_TB108 > -10) & (TB120_TB108 > 2.5)) | ((TB039_TB108 > 12) & (TB120_TB108 > 0.6))) | (((TB120_TB108 > -1) & (TB087_TB108 > -1) &  (R006_R016 < 0.8)) | ((TB120_TB108 > -1) & (TB087_TB108 > min(-1,2.5-0.18*R01_P3)) & (R006_R016 < 0.7))));
                Dust(idx)=1;
                
                 Dust = double(Dust);
            
             filename = ['Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\output_20150401\RGB_Mask_',datestr(n,'yyyymmdd'),'_P',num2str(m),'_',num2str(jj,'%02d')];
            
            %%% save data in the deirectory defined above
            save(filename,'Dust')     
            
      end
           
        catch
            Missing_layer_counter{DateVector(2)} = Missing_layer_counter{DateVector(2)} + ((24 - jj) + 1);
            count2 = count2 + (24 - jj);
            clearvars sa1 sa2 sa3 sa4 sa5 sa6
            if exist('A1','var') == 1 && jj < 24
                sa1 = size(A1.(fields1{1}),3);
                if sa1 < 24
                    count4 = count4 + 1;
                    Missing_index{count4} = strcat('T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'_>=',num2str(sa1+1),'.mat');
                end
            end
            if exist('A2','var') == 1 && jj < 24
                sa2 = size(A2.(fields2{1}),3);
                if sa2 < 24
                    count4 = count4 + 1;
                    Missing_index{count4} = strcat('T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'_>=',num2str(sa2+1),'.mat');
                end
            end
            if exist('A3','var') == 1 && jj < 24
                sa3 = size(A3.(fields3{1}),3);
                if sa3 < 24
                    count4 = count4 + 1;
                    Missing_index{count4} = strcat('T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'_>=',num2str(sa3+1),'.mat');
                end
            end
             if exist('A4','var') == 1 && jj < 24
                sa4 = size(A4.(fields4{1}),3);
                if sa4 < 24
                    count4 = count4 + 1;
                    Missing_index{count4} = strcat('T04_',datestr(n,'yyyymmdd'),'_P',num2str(m),'_>=',num2str(sa4+1),'.mat');
                end
             end
            if exist('A5','var') == 1 && jj < 24
                sa5 = size(A5.(fields5{1}),3);
                if sa5 < 24
                    count4 = count4 + 1;
                    Missing_index{count4} = strcat('R01_',datestr(n,'yyyymmdd'),'_P',num2str(m),'_>=',num2str(sa5+1),'.mat');
                end
            end
            if exist('A6','var') == 1 && jj < 24
                sa6 = size(A6.(fields6{1}),3);
                if sa6 < 24
                    count4 = count4 + 1;
                    Missing_index{count4} = strcat('R03_',datestr(n,'yyyymmdd'),'_P',num2str(m),'_>=',num2str(sa6+1),'.mat');
                end
            end
            continue
                       
 
     end
 end
 
              
    % Dust_monthly{DateVector(2)} = sum(cat(3,Dust_monthly{DateVector(2)},Dust_daily_sum{day_num}),3);
  
end

 %  sum(sum(Dust_daily_sum{1, 91},2),1)
