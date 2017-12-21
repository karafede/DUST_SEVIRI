n1 = datenum(2011,07,01);   % start date
n2 = datenum(2017,12,18);   % end date

% [Dust_monthly{1:12}] = deal(zeros(1500));
%%%% 4 datasets every 15 minutes = 4 x 24 hours = 96......images by day
% [BTDref{1:96}] = deal(zeros(1500));

count3 = 0; % counter for the missing files of T07, T09, T10 ...
Missing_file = cell(5,1); % object to collect the missing files
[Missing_layer_counter{1:12}] = deal(zeros(1)); % object to collect the empty files
count = 0; % the number of days
%[Dust_daily_sum{1:366}] = deal(zeros(1500)); 
%[Dust_daily_each_time_step{1:366,1:96}] = deal(zeros(1500)); % the dust flag for days of the year in row and time of the day in column
Missing_index = cell(5,1); % object that records the missing images within the files T07, T09, T10 ...
%[Dust_monthly{1:12}] = deal(zeros(1500));%the sum of the dust flags in the month
count4 = 0;
Dust= zeros(1500,1500);

for n = n1:n2
    DateVector = datevec(n); 
    count = count + 1;
    
       
    count2 = 0; % the counter for the final images
    for m = 1:4 % to loop in the quarter files of the day
        clearvars A1 A2 A3 A4 A5 A6 fields1 fields2 fields3 fields4 fields5 fields6
        try
            % importing B1 from the mat file
            A1 = load(strcat('Y:\EUMETSAT\T10\T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields1=fieldnames(A1);
        catch
            % if there is an error then put the filename in Missing_file
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T10_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        try
            A2 = load(strcat('Y:\EUMETSAT\T09\T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields2=fieldnames(A2);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T09_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        try
            A3 = load(strcat('Y:\EUMETSAT\T07\T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields3=fieldnames(A3);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T07_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        try
            A4 = load(strcat('Y:\EUMETSAT\T04\T04_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields4=fieldnames(A4);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('T04_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        try
            A5 = load(strcat('Y:\EUMETSAT\R01\R01_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
            fields5=fieldnames(A5);
        catch
            count3 = count3 + 1;
            Missing_file{count3} = strcat('R01_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat');
        end
        try
            A6 = load(strcat('Y:\EUMETSAT\R03\R03_',datestr(n,'yyyymmdd'),'_P',num2str(m),'.mat'));
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
                 if exist('A5','var') == 1 
                
                % the french bread 
                %%%% DG%%%
                %{
                ff=year(n);
                year_num=datenum(ff,01,01);
                day_num= n-year_num;
                %}
                
                %%%%-%%%%%%
                clearvars TB039_TB108 TB120_TB108 R006_R016 R01_P3 TB087_TB108
                count2 = count2 + 1;
              
                TB039_TB108 = A4.(fields4{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
                TB120_TB108 = A1.(fields1{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
                R006_R016 = A5.(fields5{1})(:,:,jj) ./ A6.(fields6{1})(:,:,jj);
                R01_P3 = A5.(fields5{1})(:,:,jj);
                TB087_TB108 = A3.(fields3{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
                       
                Dust_daily_each_time_step{1,count2} = ((((TB039_TB108 > -10) & (TB120_TB108 > 2.5)) | ((TB039_TB108 > 12) & (TB120_TB108 > 0.6))) | (((TB120_TB108 > -1) & (TB087_TB108 > -1) &  (R006_R016 < 0.8)) | ((TB120_TB108 > -1) & (TB087_TB108 > min(-1,2.5-0.18*R01_P3)) & (R006_R016 < 0.7))));
                 
                     
              %{     %}  
                 else
                clearvars TB039_TB108 TB120_TB108 R006_R016 R01_P3 TB087_TB108
                count2 = count2 + 1;
               
                
                TB039_TB108 = A4.(fields4{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
                TB120_TB108 = A1.(fields1{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
                %R006_R016 = A5.(fields5{1})(:,:,jj) ./ A6.(fields6{1})(:,:,jj);
                %R01_P3 = A5.(fields5{1})(:,:,jj);
                TB087_TB108 = A3.(fields3{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
                       
                Dust_daily_each_time_step{1,count2} = ((((TB039_TB108 > -10) & (TB120_TB108 > 2.5)) | ((TB039_TB108 > 12) & (TB120_TB108 > 0.6)))); %  | (((TB120_TB108 > -1) & (TB087_TB108 > -1)) | ((TB120_TB108 > -1) )));

                end
                
                
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
 


%{
figure
for jj=1:96
imagesc(Dust_daily_each_time_step{1,jj})
title(jj)
pause(0.5)
end
%}
    % output folder
       filename = ['F:\Historical_DUST\SEVIRI_DUST_MASK_outputs\II_Method_MetFr\DUST_Mask_METFr_Orig',datestr(n,'yyyymmdd')];
save (filename,'Dust_daily_each_time_step', '-v7.3')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Create Netcdf files ##############################################


% load all seviri data for one day

% load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\output_20150402_new\RGB_Mask_METFr_Orig20150329.mat')  
% load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\output_20150402_new\RGB_Mask_METFr_Orig20150330.mat')  
% load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\output_20150402_new\RGB_Mask_METFr_Orig20150331.mat')    
% load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\output_20150402_new\RGB_Mask_METFr_Orig20150401.mat')  
% load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\output_20150402_new\RGB_Mask_METFr_Orig20150402.mat')
% load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\output_20150402_new\RGB_Mask_METFr_Orig20150403.mat')  
% load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\output_20150402_new\RGB_Mask_METFr_Orig20150404.mat')
 
% load Latitude & Longitude
load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\LAT_20110518.mat')
load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\LONG_20110518.mat')

%%%% adjusting
for kk=1:84
if isempty(Dust_daily_each_time_step{1,kk})
    Dust_daily_each_time_step{1,kk}= NaN(1500,1500);
end
end
%%%% developing in matrix format

dawit=[];
for jj=1:84
  dawit= cat(3, dawit, Dust_daily_each_time_step{jj});
end


filename_nc =['F:\Historical_DUST\SEVIRI_DUST_MASK_outputs\HDF5_outputs\II_Method_MetFr\Seviri_',datestr(n,'yyyymmdd'),'_II_Method_METFr_Orig.nc'];
ncid=netcdf.create(filename_nc,'NETCDF4');

dimid(1)=netcdf.defDim(ncid,'lat',1500);
dimid(2)=netcdf.defDim(ncid,'lon',1500);
dimid(3)=netcdf.defDim(ncid,'time',84);

% change the name of the NetCDF file according to the date
varid1=netcdf.defVar(ncid, 'SEVIRI_DF_2015_04_04' ,'NC_DOUBLE',dimid);
varid2 = netcdf.defVar(ncid, 'lon', 'NC_DOUBLE', dimid(2));
varid3 = netcdf.defVar(ncid, 'lat', 'NC_DOUBLE', dimid(1));

netcdf.defVarDeflate(ncid,varid1,true,true,5);

%varid4 = netcdf.defVar(ncid, 'time', 'NC_DOUBLE', dimid(3));

netcdf.endDef(ncid);
netcdf.putVar(ncid,varid1,dawit(:,:,:));
netcdf.putVar(ncid,varid2,LONG(1,:)');
netcdf.putVar(ncid,varid3,LAT(:,1));
%netcdf.putVar(ncid,varid4,se');

netcdf.close(ncid)

end

%%%%%% end of the script
%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% xxxx=dawit(:,:,5);
% sum(sum(isnan(xxxx),2),1)

% imagesc(dawit(:,:,1))   

