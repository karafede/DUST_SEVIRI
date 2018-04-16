
########################
### II Method ###########
########################

library(RNetCDF)
library(rgdal)
library(ncdf4)
library(raster)
library(stringr)
library(h5)
library(gdalUtils)
library(rgdal)

dir <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 2/HISTORICAL_dust/UAE_boundary"
### shapefile for UAE
shp_UAE <- readOGR(dsn = dir, layer = "uae_emirates")

# ----- Transform to EPSG 4326 - WGS84 (required)
shp_UAE <- spTransform(shp_UAE, CRS("+init=epsg:4326"))

shp_UAE@data$name <- 1:nrow(shp_UAE)
plot(shp_UAE)

setwd("F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/HDF5_outputs/II_Method_MetFr/II_method_MetFrance")

###################################################################################

output_dir <- "F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/HDF5_outputs/II_Method_MetFr/II_method_MetFrance/daily_sum_II_MetFrance"

patt <- ".tif"
filenames <- list.files(pattern = patt)
# filenames <- filenames[3748] # 96 scenes  20150331
# n <- dim(stack(filenames))[3]
# filenames <- filenames[2041:n]
# filenames <- filenames[2379:n] # from 20110791 (96 images)
# filenames <- filenames[4137:n]

# inizialise an empty raster to stack ALL HOURS together in an unique raster 

 import_stack_seviri <- function(filenames){
   
   # for each filename open nc file and look how many scenes are inside
   # get the date from the filename
   year <- str_sub(filenames, start = 8, end = -30)
   month <- str_sub(filenames, start = 12, end = -28)
   day <- str_sub(filenames, start = 14, end = -26)
   DATE <- paste0(year,"-",month,"-",day)
   n <- dim(stack(filenames))[3]
   name <- str_sub(filenames, start = 8, end = -16)
   
   # sum all layer in a raster together
     r <- stack(filenames)
     sum_rasters <- sum(r)
     sum_rasters <- crop(sum_rasters, extent(shp_UAE))
     sum_rasters <- mask(sum_rasters, shp_UAE) 
     plot(sum_rasters)
     writeRaster(sum_rasters, paste0(output_dir,"/", name, "_II_Method_sum.tif") , options= "INTERLEAVE=BAND", overwrite=T)

   return(sum_rasters)

}

 BBB <- lapply(filenames, import_stack_seviri) 


 # quick leaflet map
  library(leaflet)
  leaflet() %>% addTiles() %>%
    addRasterImage(sum_rasters, opacity = 0.5) 

#########################################################################################
 