
library(raster)
library(rgdal)
library(stringr)
library(lubridate)
library(leaflet)
library(webshot)
library(htmlwidgets)
library(mapview)

setwd("/home/mariners/RGB_masks_MetFr_tif/")
# delete previous .tif. files
patt <- ".tif"
filenames <- list.files(pattern = patt)
file.remove(filenames) 


setwd("/research/SEVIRI_data_Raw_data/")

time <- Sys.time()
year <- str_sub(time, start = 0, end = -16)
month <- str_sub(time, start = 6, end = -13)
day <- str_sub(time, start = 9, end = -10)

DATE <- date(time)

DATE <- paste0(year,month,day)
# DATE <- "20171205"
# DATE <- as.numeric(DATE)

##################

# DATE <- "2017-12-11"
# DATE <- as.Date(DATE) 

# current_date <- paste0(year,month,day)
# current_date <- "20171211"
current_date <- DATE

filenames_T07 <- dir("/research/SEVIRI_data_Raw_data/T07", pattern = current_date)
filenames_T07 <- filenames_T07[grep(".img", filenames_T07, fixed = T)]
filenames_T09 <- dir("/research/SEVIRI_data_Raw_data/T09", pattern = current_date)
filenames_T09 <- filenames_T09[grep(".img", filenames_T09, fixed = T)]
filenames_T10 <- dir("/research/SEVIRI_data_Raw_data/T10", pattern = current_date)
filenames_T10 <- filenames_T10[grep(".img", filenames_T10, fixed = T)]
filenames_T04 <- dir("/research/SEVIRI_data_Raw_data/T04", pattern = current_date)
filenames_T04 <- filenames_T04[grep(".img", filenames_T04, fixed = T)]
filenames_R01 <- dir("/research/SEVIRI_data_Raw_data/R01", pattern = current_date)
filenames_R01 <- filenames_R01[grep(".img", filenames_R01, fixed = T)]
filenames_R02 <- dir("/research/SEVIRI_data_Raw_data/R02", pattern = current_date)
filenames_R02 <- filenames_R02[grep(".img", filenames_R02, fixed = T)]
filenames_R03 <- dir("/research/SEVIRI_data_Raw_data/R03", pattern = current_date)
filenames_R03 <- filenames_R03[grep(".img", filenames_R03, fixed = T)]

#########################################################################################


# x = 3315 lines
# y = 3712 lines

LON <- seq(from= 30.0055, to = 59.9945, by =0.009047)  #3315
LAT <- seq(from= 10.0065, to = 39.9949, by =0.008079)  #3712
xmn = min(LON)
xmx = max(LON)
ymn = min(LAT)
ymx = max(LAT)

# make an empty matrix
Missing_file <- data.frame(matrix(0, ncol = 1, nrow = 30))


# inizialize an empty raster stack for each DAY  
# all_rasters <- stack() 
count1 <- 0

i <- 10

for (i in 1:length(filenames_T07)) {
  

count2 <- 0
count3 <- 0


  remove(A1, A2, A3, A4, R01, R02, R03)
  
  tryCatch({
    A1 <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/T10/",filenames_T10[i]))
    A1 <- as.matrix(A1)+273
  }, error= function(err) { print(paste0("no band T10"))
  }, finally = { 
    count3 <- count3 + 1;
    Missing_file = filenames_T10[i]
  })
  
  tryCatch({
    A2 <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/T09/",filenames_T09[i]))
    A2 <- as.matrix(A2)+273
    
  }, error= function(err) { print(paste0("no band T09"))
  }, finally = { 
    count3 <- count3 + 1;
    Missing_file = filenames_T09[i]
  })
  
  tryCatch({
    A3 <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/T07/",filenames_T07[i]))
    A3 <- as.matrix(A3)+273
  }, error= function(err) { print(paste0("no band T07"))
  }, finally = { 
    count3 <- count3 + 1;
    Missing_file = filenames_T07[i]
  })
  
  
  tryCatch({
    A4 <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/T04/",filenames_T04[i]))
    A4 <- as.matrix(A4)+273
  }, error= function(err) { print(paste0("no band T04"))
  }, finally = { 
    count3 <- count3 + 1;
    Missing_file = filenames_T04[i]
  })
  
  
  tryCatch({
    R01 <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/R01/",filenames_R01[i]))
    R01 <- as.matrix(R01)+273
  }, error= function(err) { print(paste0("no band R01"))
  }, finally = { 
    count3 <- count3 + 1;
    Missing_file = filenames_R01[i]
  })
  
  
  tryCatch({
    R02 <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/R02/",filenames_R02[i]))
    R02 <- as.matrix(R02)+273
  }, error= function(err) { print(paste0("no band R02"))
  }, finally = { 
    count3 <- count3 + 1;
    Missing_file = filenames_R02[i]
  })
  
  
  tryCatch({
    R03 <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/R03/",filenames_R03[i]))
    R03 <- as.matrix(R03)+273
  }, error= function(err) { print(paste0("no band R03"))
  }, finally = { 
    count3 <- count3 + 1;
    Missing_file = filenames_R03[i]
  })
  

  # original Meteofrance Algorithm
  TB039_TB108 = A4 - A2
  TB120_TB108 = A1 - A2
  R006_R016 = R01 / R03
  R01_P3 = R01
  TB087_TB108 = A3 - A2
  Dust_daily_each_time_step <- ((((TB039_TB108 > -10) & (TB120_TB108 > 2.5)) | ((TB039_TB108 > 12) & (TB120_TB108 > 0.6))) | (((TB120_TB108 > -1) & (TB087_TB108 > -1) &  (R006_R016 < 0.8)) | ((TB120_TB108 > -1) & (TB087_TB108 > min(-1,2.5-0.18*R01_P3)) & (R006_R016 < 0.7))))
  
  
  MASK <- Dust_daily_each_time_step*1
  max(MASK)
  MASK[MASK == 0] <- 0.000000000001
  
  ### best colors for the MASK ###########
  ########################################
  MASK_RED <- MASK*345
  MASK_GREEN <- MASK*300
  MASK_BLUE <- MASK*276
  ########################################
  ########################################
  
  
  # convert logical vector (TRUE & FALSE) into 0 & 1
  Dust_daily_each_time_step <- Dust_daily_each_time_step*2
  max(Dust_daily_each_time_step)
  Dust_daily_each_time_step[Dust_daily_each_time_step == 0] <- 1
  max(Dust_daily_each_time_step)
  min(Dust_daily_each_time_step)
  Dust_daily_each_time_step[Dust_daily_each_time_step == 2] <- 0  #dust flag
  
  r1 <- R01*Dust_daily_each_time_step + MASK_RED
  r2 <- R02*Dust_daily_each_time_step + MASK_GREEN
  r3 <- R03*Dust_daily_each_time_step + MASK_BLUE
  
  
  MASK_RED <-  t(MASK_RED)
  MASK_RED <- raster(MASK_RED, 30.1, 59.9, 10.4,  41.55, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  # plot(MASK_RED)
  
  MASK_GREEN <-  t(MASK_GREEN)
  MASK_GREEN <- raster(MASK_GREEN, 30.1, 59.9, 10.4,  41.55, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  # plot(MASK_GREEN)
  
  r1 <-  t(r1[ , ])
  r1 <- raster(r1, 30.1, 59.9, 10.4,  41.55, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  # plot(r1)
  
  r2 <-  t(r2[ , ])
  r2 <- raster(r2, 30.1, 59.9, 10.4,  41.55, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  # plot(r2)
  
  r3 <-  t(r3[ , ])
  r3 <- raster(r3, 30.1, 59.9, 10.4,  41.55, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  # plot(r3)
  
  DUST_mask <-  t(Dust_daily_each_time_step[ , ])
  DUST_mask <- raster(DUST_mask, 30.1, 59.9, 10.4,  41.55, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  # plot(DUST_mask)
  
  # create and RGB image ########
  rgbRaster <- stack(r3,r2,r1)   #RGB == R03, R02, R01 (Red, Green, Blue)
  # plot an RGB version of the stack
  # raster::plotRGB(rgbRaster,r=1,g=2,b=3, stretch = "lin")
  
  # make and SAVE a geotiff raster
  writeRaster(rgbRaster, paste0("/home/mariners/RGB_masks_MetFr_tif/",
                                str_sub(filenames_R01[i], start = 1, end = -19),
                                "_RGB.tif") , options= "INTERLEAVE=BAND", overwrite=T)
  
  
}

# remove files containing NA

setwd("/home/mariners/RGB_masks_MetFr_tif/")
patt <- "NA"
filenames_NA <- list.files(pattern = patt)
file.remove(filenames_NA) 


