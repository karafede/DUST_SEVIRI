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
  %  clearvars Dust_daily_each_time_step
 % [BTDref{1:61}] = deal(zeros(298,696) - 500);
    count = n - NewYear + 1;
   % count = count +1;
    DateVector = datevec(n);
    for t = n - 7:n - 1   % t = n - 15:n - 1
        DateVectorNewYear1 = datevec(t);
        Year1 = DateVectorNewYear1(1);
        t1 = datenum(Year1,01,01);
        clearvars A1 A2 fields1 fields2
        try
            A1=load(strcat('Y:\MCIDAS\MCIDAS_UAE\',datestr(t,'yyyy'),'\',sprintf('%.3d',t-t1+1),'\T07',sprintf('%.3d',t-t1+1),'.mat'));
            fields1=fieldnames(A1);
            A2=load(strcat('Y:\MCIDAS\MCIDAS_UAE\',datestr(t,'yyyy'),'\',sprintf('%.3d',t-t1+1),'\T09',sprintf('%.3d',t-t1+1),'.mat'));
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

     count2 = 0;
    clearvars B1 B2 B3 fields1 fields2 fields3 
    try
        B1 = load(strcat('Y:\MCIDAS\MCIDAS_UAE\',datestr(n,'yyyy'),'\',sprintf('%.3d',count),'\T10',sprintf('%.3d',count),'.mat'));
        fields1=fieldnames(B1);
    catch
        count1 = count1 + 1;
        Missing_file{count1} = strcat('T10_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'.mat');
    end
    try
        B2 = load(strcat('Y:\MCIDAS\MCIDAS_UAE\',datestr(n,'yyyy'),'\',sprintf('%.3d',count),'\T09',sprintf('%.3d',count),'.mat'));
        fields2=fieldnames(B2);
    catch
        count1 = count1 + 1;
        Missing_file{count1} = strcat('T09_',datestr(n,'yyyy'),'_',sprintf('%.3d',count),'.mat');
    end
    try
        B3 = load(strcat('Y:\MCIDAS\MCIDAS_UAE\',datestr(n,'yyyy'),'\',sprintf('%.3d',count),'\T07',sprintf('%.3d',count),'.mat'));
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
            count2 = count2 + 1;
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
                Dust_daily_each_time_step{1,count2} = ((BT108 >= 285) & (BT120_BT108 >= 0) & (BT108_BT087 <= 10) & (BTD108_087anom <= -2));
                %  Dust_daily_sum{count} = sum(cat(3,Dust_daily_sum{count},Dust_daily_each_time_step{count,jj}),3);
            end
       % end
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
   % Dust_monthly{DateVector(2)} = sum(cat(3,Dust_monthly{DateVector(2)},Dust_daily_sum{count}),3);
    
       filename = ['F:\Historical_DUST\SEVIRI_DUST_MASK_outputs\DUST_Mask_',datestr(n,'yyyymmdd')];
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

filename_nc =['F:\Historical_DUST\SEVIRI_DUST_MASK_outputs\HDF5_outputs\Seviri_',datestr(n,'yyyymmdd'),'_I_Method.nc'];
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