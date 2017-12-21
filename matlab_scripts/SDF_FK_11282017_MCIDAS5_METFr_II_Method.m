% clc
% clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% it only process one year at the time but it is very fast %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n1 = datenum(2005,01,01);
n2 = datenum(2011,06,30);

DateVectorNewYear = datevec(n1);
Year = DateVectorNewYear(1);
NewYear = datenum(Year,01,01);
d1 = n1 - NewYear + 1;
d2 = n2 - NewYear + 1;

% [Dust_monthly{1:12}] = deal(zeros(298,696));  %only over UAE
[Missing_layer_counter{1:12}] = deal(zeros(1));
[BTDref{1:61}] = deal(zeros(298,696) - 500);
% [Dust_daily_sum{d1:d2}] = deal(zeros(298,696));
% [Dust_daily_each_time_step{d1:d2,1:61}] = deal(zeros(298,696));
Missing_file = cell(5,1);
Missing_index = cell(5,1);
Zeros_layer = cell(5,1);

count = 0;
count1 = 0;
count3 = 0;


for n = n1:n2
   % [BTDref{1:61}] = deal(zeros(298,696) - 500);
    count = n - NewYear + 1;
    DateVector = datevec(n);
    count2 = 0; % the counter for the final images
    
    clearvars A1 A2 A3 A4 A5 A6 fields1 fields2 fields3 fields4 fields5 fields6
    try
        A1 = load(strcat('Y:\MCIDAS\MCIDAS_UAE\',datestr(n,'yyyy'),'\',sprintf('%.3d',count),'\T10',sprintf('%.3d',count),'.mat'));
        fields1=fieldnames(A1);
    catch
        count1 = count1 + 1;
        Missing_file{count1} = strcat('T10_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'.mat');
    end
    try
        A2 = load(strcat('Y:\MCIDAS\MCIDAS_UAE\',datestr(n,'yyyy'),'\',sprintf('%.3d',count),'\T09',sprintf('%.3d',count),'.mat'));
        fields2=fieldnames(A2);
    catch
        count1 = count1 + 1;
        Missing_file{count1} = strcat('T09_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'.mat');
    end
    try
        A3 = load(strcat('Y:\MCIDAS\MCIDAS_UAE\',datestr(n,'yyyy'),'\',sprintf('%.3d',count),'\T07',sprintf('%.3d',count),'.mat'));
        fields3=fieldnames(A3);
    catch
        count1 = count1 + 1;
        Missing_file{count1} = strcat('T07_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'.mat');
    end
    try
        A4 = load(strcat('Y:\MCIDAS\MCIDAS_UAE\',datestr(n,'yyyy'),'\',sprintf('%.3d',count),'\T04',sprintf('%.3d',count),'.mat'));
        fields4=fieldnames(A4);
    catch
        count1 = count1 + 1;
        Missing_file{count1} = strcat('T04_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'.mat');
    end
    try
        A5 = load(strcat('Y:\MCIDAS\MCIDAS_UAE\',datestr(n,'yyyy'),'\',sprintf('%.3d',count),'\R01',sprintf('%.3d',count),'.mat'));
        fields5=fieldnames(A5);
    catch
        count1 = count1 + 1;
        Missing_file{count1} = strcat('R01_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'.mat');
    end
    try
        A6 = load(strcat('Y:\MCIDAS\MCIDAS_UAE\',datestr(n,'yyyy'),'\',sprintf('%.3d',count),'\R03',sprintf('%.3d',count),'.mat'));
        fields6=fieldnames(A6);
    catch
        count1 = count1 + 1;
        Missing_file{count1} = strcat('R03_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'.mat');
    end
    
    if exist('A1','var') == 0 && exist('A2','var') == 0 && exist('A3','var') == 0 && exist('A4','var') == 0 && exist('A5','var') == 0 && exist('A6','var') == 0
        Missing_layer_counter{DateVector(2)} = Missing_layer_counter{DateVector(2)} + 61;
        continue
    end
    
    try
        for jj = 1:61
            if exist('A5','var') == 1 
                 
            clearvars B11 B22 B33 BT108 BT120_BT108 BT108_BT087 BTD108_087anom
            count2 = count2 + 1;
            
             TB039_TB108 = A4.(fields4{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
             TB120_TB108 = A1.(fields1{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
             R006_R016 = A5.(fields5{1})(:,:,jj) ./ A6.(fields6{1})(:,:,jj);
             R01_P3 = A5.(fields5{1})(:,:,jj);
             TB087_TB108 = A3.(fields3{1})(:,:,jj) - A2.(fields2{1})(:,:,jj);
                       
             Dust_daily_each_time_step{1,count2} = ((((TB039_TB108 > -10) & (TB120_TB108 > 2.5)) | ((TB039_TB108 > 12) & (TB120_TB108 > 0.6))) | (((TB120_TB108 > -1) & (TB087_TB108 > -1) &  (R006_R016 < 0.8)) | ((TB120_TB108 > -1) & (TB087_TB108 > min(-1,2.5-0.18*R01_P3)) & (R006_R016 < 0.7))));
                 
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
        Missing_layer_counter{DateVector(2)} = Missing_layer_counter{DateVector(2)} + ((61 - jj) + 1);
         clearvars sa1 sa2 sa3 sa4 sa5 sa6 
        if exist('A1','var') == 1 && jj < 61
            sa1 = size(A1.(fields1{1}),3);
        if sa1 < 61
            count2 = count2 + 1;
            Missing_index{count2} = strcat('T10_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'_>=',num2str(sa1+1),'.mat');
        end
        end
        if exist('A2','var') == 1 && jj < 61
            sa2 = size(A2.(fields2{1}),3);
            if sa2 < 61
                count2 = count2 + 1;
                Missing_index{count2} = strcat('T09_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'_>=',num2str(sa2+1),'.mat');
            end
        end
        if exist('A3','var') == 1 && jj < 61
            sa3 = size(A3.(fields3{1}),3);
            if sa3 < 61
                count2 = count2 + 1;
                Missing_index{count2} = strcat('T07_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'_>=',num2str(sa3+1),'.mat');
            end
        end
         if exist('A4','var') == 1 && jj < 61
            sa4 = size(A4.(fields4{1}),3);
            if sa4 < 61
                count2 = count2 + 1;
                Missing_index{count2} = strcat('T04_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'_>=',num2str(sa4+1),'.mat');
            end
         end
         if exist('A5','var') == 1 && jj < 61
            sa5 = size(A5.(fields5{1}),3);
            if sa5 < 61
                count2 = count2 + 1;
                Missing_index{count2} = strcat('R01_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'_>=',num2str(sa5+1),'.mat');
            end
         end
         if exist('A6','var') == 1 && jj < 61
            sa6 = size(A6.(fields6{1}),3);
            if sa6 < 61
                count2 = count2 + 1;
                Missing_index{count2} = strcat('R03_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'_>=',num2str(sa6+1),'.mat');
            end
        end
        continue
    end
  
    
       filename = ['F:\Historical_DUST\SEVIRI_DUST_MASK_outputs\II_Method_MetFr\DUST_Mask_METFr_Orig',datestr(n,'yyyymmdd')];
save (filename,'Dust_daily_each_time_step', '-v7.3')
   
% end


% figure
% for jj=1:61
% imagesc(Dust_daily_each_time_step{1,jj})
% title(jj)
% pause(.5)
% end


% for n = n1:n2
 % load(['F:\Historical_DUST\SEVIRI_DUST_MASK_outputs\DUST_Mask_',datestr(n,'yyyymmdd'),'.mat']);

% load Latitude & Longitude
% load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\MCIDAS\LAT_2009.mat')
% load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\MCIDAS\LONG_2009.mat')

% make a gridded lat and lon
LAT = repmat((22.1307:0.01965:27.9815),696,1);
LAT = LAT';
LAT = flipud(LAT);
LONG = repmat((48.6936:0.01909:61.9642),298,1);


%%%% adjusting
for kk=1:61
if isempty(Dust_daily_each_time_step{1,kk})
    Dust_daily_each_time_step{1,kk}= NaN(298,696);
end
end
%%%% developing in matrix format

dawit=[];
for jj=1:61 
  dawit= cat(3, dawit, Dust_daily_each_time_step{jj});
end

% daw=dawit(:,:, 5:10);
%%%% creating the nc file

filename_nc =['F:\Historical_DUST\SEVIRI_DUST_MASK_outputs\HDF5_outputs\II_Method_MetFr\Seviri_',datestr(n,'yyyymmdd'),'_II_Method_METFr_Orig.nc'];
ncid=netcdf.create(filename_nc,'NETCDF4');


dimid(1)=netcdf.defDim(ncid,'lat',298); % check!
dimid(2)=netcdf.defDim(ncid,'lon',696); % check
dimid(3)=netcdf.defDim(ncid,'time',61);

% name of the NetCDF fields
varid1=netcdf.defVar(ncid, 'SEVIRI_DF' ,'NC_DOUBLE',dimid);
varid2 = netcdf.defVar(ncid, 'lon', 'NC_DOUBLE', dimid(2));
varid3 = netcdf.defVar(ncid, 'lat', 'NC_DOUBLE', dimid(1));

netcdf.defVarDeflate(ncid,varid1,true,true,5);

netcdf.endDef(ncid);
netcdf.putVar(ncid,varid1,dawit(:,:,:));
netcdf.putVar(ncid,varid2,LONG(1,:)');
netcdf.putVar(ncid,varid3,LAT(:,1));

netcdf.close(ncid)

end

%%%%%% end of the script