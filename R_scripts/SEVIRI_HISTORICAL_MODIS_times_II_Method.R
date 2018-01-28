
library(RNetCDF)
library(rgdal)
library(ncdf4)
library(raster)
library(stringr)

###########################################################################
### stack all the rasters at 07:15 am, as for MODIS TERRA #################
###########################################################################

dir <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 2/HISTORICAL_dust/UAE_boundary"
### shapefile for UAE
shp_UAE <- readOGR(dsn = dir, layer = "uae_emirates")

# ----- Transform to EPSG 4326 - WGS84 (required)
shp_UAE <- spTransform(shp_UAE, CRS("+init=epsg:4326"))
# names(shp)

shp_UAE@data$name <- 1:nrow(shp_UAE)
plot(shp_UAE)

setwd("F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/HDF5_outputs/II_Method_MetFr")

output_dir <- "F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/TERRA_time_II_Method_MetFr"

patt <- ".nc"
filenames <- list.files(pattern = patt)
# filenames <- filenames[1] # 61 scenes
# filenames <- filenames[3748] # 96 scenes  20150331
n <- length(filenames)
# filenames <- filenames[2041:n]
filenames <- filenames[4081:n]

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
   # select time at 07:15 am ##
   TS_TERRA <- TS[30]


## !we are importing HDF5 files....different structure!!! ----------------------
  seviri_file <- nc_open(filenames)
  name_vari <- names(seviri_file$var)

  # day name
  name <- str_sub(filenames, start = 8, end = -15)
  
  
###### read the DUST FLAG variable (only)

     var_value <- ncvar_get(seviri_file)
     LON <- ncvar_get(seviri_file,"lon")
     LAT <- ncvar_get(seviri_file,"lat")
     nc_close(seviri_file)
     remove(seviri_file)
     
     xmn= min(LON)
     xmx=max(LON)
     ymn=min(LAT)
     ymx=max(LAT)
     
  all_rasters <- stack()    # stack ALL HOURS together in an unique raster
     
    # i = 30
    CRS <- projection(shp_UAE)
    # r <- raster((var_value[ , , 1]), xmn, xmx, ymn,  ymx, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
    r <- raster((var_value[ , , 30]), xmn, xmx, ymn,  ymx, crs=CRS)
    # plot(r)
    plot(shp_UAE, add=TRUE, lwd=1)
    # crop all over the UAE only
    r <- crop(r, extent(shp_UAE))
    r <- mask(r, shp_UAE)  
    plot(r)
    name_time <- TS[30]
    names(r)<- paste("SEVIRI_", name_time, sep = "")
    all_rasters<- stack(all_rasters,r)
    

    # save data
    writeRaster(all_rasters, paste0(output_dir,"/", name, "_SEVIRI_TERRA_time_II_Method_MetFr.tif") , options= "INTERLEAVE=BAND", overwrite=T)
    # clear the memory
    gc()

}

 
 BBB <- lapply(filenames, import_nc_seviri) 

 # AAA <- stack("F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/TERRA_time/20040318_SEVIRI_TERRA_time.tif")


 
 
#########################################################################################################
#########################################################################################################
 
 
 library(RNetCDF)
 library(rgdal)
 library(ncdf4)
 library(raster)
 library(stringr)
 
 
 ###########################################################################
 ### stack all the rasters at 07:15 am, as for MODIS AQUA ##################
 ###########################################################################
 
 
 dir <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 2/HISTORICAL_dust/UAE_boundary"
 ### shapefile for UAE
 shp_UAE <- readOGR(dsn = dir, layer = "uae_emirates")
 
 # ----- Transform to EPSG 4326 - WGS84 (required)
 shp_UAE <- spTransform(shp_UAE, CRS("+init=epsg:4326"))
 # names(shp)
 
 shp_UAE@data$name <- 1:nrow(shp_UAE)
 plot(shp_UAE)
 
 setwd("F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/HDF5_outputs/II_Method_MetFr")
 
 output_dir <- "F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/AQUA_time_II_Method_MetFr"
 
 patt <- ".nc"
 filenames <- list.files(pattern = patt)
 # filenames <- filenames[1] # 61 scenes
 # filenames <- filenames[3790] # 96 scenes
 n <- length(filenames)
 # filenames <- filenames[2041:n]
 filenames <- filenames[4081:n]
 
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
   # select time at 07:15 am ##
   TS_TERRA <- TS[39]
   
   
   
   ## !we are importing HDF5 files....different structure!!! ----------------------
   seviri_file <- nc_open(filenames)
   name_vari <- names(seviri_file$var)
   # day name
   name <- str_sub(filenames, start = 8, end = -15)
   
   
   ###### read the DUST FLAG variable (only)
   
   var_value <- ncvar_get(seviri_file)
   LON <- ncvar_get(seviri_file,"lon")
   LAT <- ncvar_get(seviri_file,"lat")
   nc_close(seviri_file)
   remove(seviri_file)
   
   xmn= min(LON)
   xmx=max(LON)
   ymn=min(LAT)
   ymx=max(LAT)
   
   all_rasters <- stack()    # stack ALL HOURS together in an unique raster
   
   # i = 39
   
   r <- raster((var_value[ , , 39]), xmn, xmx, ymn,  ymx, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
   # crop all over the UAE only
   r <- crop(r, extent(shp_UAE))
   r <- mask(r, shp_UAE)  
   plot(r)
   name_time <- TS[39]
   names(r)<- paste("SEVIRI_", name_time, sep = "")
   all_rasters<- stack(all_rasters,r)
   
   
   # save data
   writeRaster(all_rasters, paste0(output_dir,"/", name, "_SEVIRI_AQUA_time_II_Method_MetFr.tif") , options= "INTERLEAVE=BAND", overwrite=T)
   # clear up the memory
   gc()
   rm(list=ls())
   
 }
 
 
 BBB <- lapply(filenames, import_nc_seviri) 
 
 
#################################################
 