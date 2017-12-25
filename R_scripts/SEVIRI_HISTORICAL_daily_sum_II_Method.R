
######################################
### II Method Meteo France ###########
######################################

library(RNetCDF)
library(rgdal)
library(ncdf4)
library(raster)
library(stringr)


dir <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 2/HISTORICAL_dust/UAE_boundary"
### shapefile for UAE
shp_UAE <- readOGR(dsn = dir, layer = "uae_emirates")

# ----- Transform to EPSG 4326 - WGS84 (required)
shp_UAE <- spTransform(shp_UAE, CRS("+init=epsg:4326"))
# names(shp)

shp_UAE@data$name <- 1:nrow(shp_UAE)
plot(shp_UAE)

setwd("F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/HDF5_outputs/II_Method_MetFr")

output_dir <- "F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/daily_sum_II_Method"

patt <- ".nc"
filenames <- list.files(pattern = patt)
# filenames <- filenames[1] 
# filenames <- filenames[3748] # 96 scenes  20150331

# get the date from the filename
# year <- str_sub(filenames, start = 8, end = -17)
# month <- str_sub(filenames, start = 12, end = -15)
# day <- str_sub(filenames, start = 14, end = -13)
# DATE <- paste0(year,"-",month,"-",day)

# # for each filename open nc file and look how many scenes are inside
# 
# seviri_file <- nc_open(filenames)
# var_value <- ncvar_get(seviri_file)
# n <- dim(var_value)[3]
# 
# # gerate a time sequence for a given day every 15 minuntes
# # start <- as.POSIXct("2015-04-04")
# start <- as.POSIXct(DATE)
# 
# interval <- 15 #minutes
# end <- start + as.difftime(1, units="days")
# TS <- seq(from=start, by=interval*60, to=end-1)
# TS[1:n]



# inizialise an empty raster to stack ALL HOURS together in an unique raster 

 import_nc_seviri <- function(filenames){
   
   
   # for each filename open nc file and look how many scenes are inside
   # get the date from the filename
   year <- str_sub(filenames, start = 8, end = -29)
   month <- str_sub(filenames, start = 12, end = -27)
   day <- str_sub(filenames, start = 14, end = -25)
   DATE <- paste0(year,"-",month,"-",day)
   
   seviri_file <- nc_open(filenames)
   var_value <- ncvar_get(seviri_file)
   n <- dim(var_value)[3]
   
   # gerate a time sequence for a given day every 15 minuntes
   # start <- as.POSIXct("2015-04-04")
   start <- as.POSIXct(DATE)
   
   interval <- 15 #minutes
   end <- start + as.difftime(1, units="days")
   TS <- seq(from=start, by=interval*60, to=end-1)
   TS[1:n]
   

## !we are importing HDF5 files....different structure!!! ----------------------
  # seviri_file <- nc_open(filenames)
  name_vari <- names(seviri_file$var)
  # day name
  name <- str_sub(filenames, start = 8, end = -13)
 
  
###### read the DUST FLAG variable (only)

     # var_value <- ncvar_get(seviri_file)
     LON <- ncvar_get(seviri_file,"lon")
     LAT <- ncvar_get(seviri_file,"lat")
     nc_close(seviri_file)
     remove(seviri_file)
     
     
     xmn= min(LON)
     xmx=max(LON)
     ymn=min(LAT)
     ymx=max(LAT)
     
  all_rasters <- stack()    # stack ALL HOURS together in an unique raster
     
     # i = 1
   
  for (i in 1:dim(var_value)[3]){      # time dimension (always 96 scenes over one day)
    r <- raster((var_value[ , , i]), xmn, xmx, ymn,  ymx, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
    # crop all over the UAE only
    r <- crop(r, extent(shp_UAE))
    r <- mask(r, shp_UAE)  
    plot(r)
    name_time <- TS[i]
    names(r)<- paste("SEVIRI_", name_time, sep = "")
    all_rasters<- stack(all_rasters,r)
    
    # make the sum of all the pixels (this are counts)
    # indices <- format(as.Date(names(all_rasters), format = "X%Y.%m.%d"), format = "%m")
    # indices <- as.numeric(indices)
    # sum all raster together by pixel
    # sum_rasters <- stackApply(all_rasters, indices, na.rm = T, fun = sum)
    # plot(sum_rasters)
    
    # save data
    # print(i)
    sum_rasters <- sum(all_rasters, na.rm = TRUE)
    # sum_rasters <- crop(sum_rasters, extent(shp_UAE))
    # sum_rasters <- mask(sum_rasters, shp_UAE) 
    plot(sum_rasters)
    writeRaster(sum_rasters, paste0(output_dir,"/", name, "_II_Method_sum.tif") , options= "INTERLEAVE=BAND", overwrite=T)
    # clear memory
    gc()
  }
  
#   write.csv(names(all_rasters), paste(name,  ".csv", sep=""))
   return(sum_rasters)

}

 
 BBB <- lapply(filenames, import_nc_seviri) 

 

#########################################################################################
 