
%{
nccreate('Z:\_SHARED_FOLDERS\Dust_Event_UAE_2015\our_nc.nc' , 'DAY_91','Dimensions',{'r',1500,'c',1500 },...
          'Format','classic')
ncwrite('Z:\_SHARED_FOLDERS\Dust_Event_UAE_2015\our_nc.nc','DAY_91', Dust_daily_sum{1, 91})


fed=[];
for kk=1:366
    dawit= [];
for ii=1:96
    dawit= cat(3, dawit, Dust_daily_each_time_step{kk, ii});
end
   fed=cat(4,fed,dawit);
    clear dawit
end
%}

load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\LAT_20110518.mat')
load('Z:\_SHARED_FOLDERS\Air Quality\Phase 2\DUST SEVIRI\seviri_data_20150402\LONG_20110518.mat')

for jj=91:366
    day_nn= strcat('Day_', num2str(jj, '%03i'));
    dawit=[];
for kk=1:96
    dawit= cat(3, dawit, Dust_daily_each_time_step{jj, kk});
end
if jj==1
ncid=netcdf.create('Z:\_SHARED_FOLDERS\Dust_Event_UAE_2015\our_nc.nc','NOCLOBBER');
dimid(1)=netcdf.defDim(ncid,'time',96);
dimid(2)=netcdf.defDim(ncid,'lon',1500);
dimid(3)=netcdf.defDim(ncid,'lat',1500);
varid=netcdf.defVar(ncid, day_nn ,'NC_DOUBLE',dimid);
varid2 = netcdf.defVar(ncid, 'lat', 'NC_DOUBLE', dimid(2));
varid3 = netcdf.defVar(ncid, 'long', 'NC_DOUBLE', dimid(3));
netcdf.endDef(ncid);
netcdf.putVar(ncid,varid,dawit);
netcdf.putVar(ncid,varid2,LAT(:,1));
netcdf.putVar(ncid,varid3,LONG(1,:)');
netcdf.close(ncid)
else
ncid=netcdf.open('Z:\_SHARED_FOLDERS\Dust_Event_UAE_2015\our_nc.nc','NOCLOBBER');
dimid(1)=netcdf.defDim(ncid,'time',96);
dimid(2)=netcdf.defDim(ncid,'lon',1500);
dimid(3)=netcdf.defDim(ncid,'lat',1500);
varid=netcdf.defVar(ncid,'Daay_001',NC_DOUBLE',dimid);
netcdf.endDef(ncid);
netcdf.putVar(ncid,varid,dawit);
netcdf.close(ncid)
end

end
