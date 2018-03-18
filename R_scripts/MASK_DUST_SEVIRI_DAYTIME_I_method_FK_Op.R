
library(raster)
library(rgdal)
library(stringr)
library(lubridate)
library(leaflet)
library(webshot)
library(htmlwidgets)
library(mapview)


setwd("/home/mariners/MASKS/")
# delete previous .tif. files
patt <- ".tif"
filenames <- list.files(pattern = patt)
file.remove(filenames) 


setwd("/research/SEVIRI_data_Raw_data/")

time <- Sys.time()
time <- time - 14400
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

# R01 and R02 start at 02:00 am
filenames_T07 <- dir("/research/SEVIRI_data_Raw_data/T07", pattern = current_date)
filenames_T07 <- filenames_T07[grep(".img", filenames_T07, fixed = T)]
n <- length(filenames_T07)
filenames_T07 <- filenames_T07[9:n]

filenames_T09 <- dir("/research/SEVIRI_data_Raw_data/T09", pattern = current_date)
filenames_T09 <- filenames_T09[grep(".img", filenames_T09, fixed = T)]
n <- length(filenames_T09)
filenames_T09 <- filenames_T09[9:n]

filenames_T10 <- dir("/research/SEVIRI_data_Raw_data/T10", pattern = current_date)
filenames_T10 <- filenames_T10[grep(".img", filenames_T10, fixed = T)]
n <- length(filenames_T10)
filenames_T10 <- filenames_T10[9:n]

filenames_T04 <- dir("/research/SEVIRI_data_Raw_data/T04", pattern = current_date)
filenames_T04 <- filenames_T04[grep(".img", filenames_T04, fixed = T)]
n <- length(filenames_T04)
filenames_T04 <- filenames_T04[9:n]

filenames_R01 <- dir("/research/SEVIRI_data_Raw_data/R01", pattern = current_date)
filenames_R01 <- filenames_R01[grep(".img", filenames_R01, fixed = T)]
filenames_R02 <- dir("/research/SEVIRI_data_Raw_data/R02", pattern = current_date)
filenames_R02 <- filenames_R02[grep(".img", filenames_R02, fixed = T)]

filenames_R03 <- dir("/research/SEVIRI_data_Raw_data/R03", pattern = current_date)
filenames_R03 <- filenames_R03[grep(".img", filenames_R03, fixed = T)]
n <- length(filenames_R03)
filenames_R03 <- filenames_R03[9:n]

n <- length(filenames_R03)
file <- filenames_R03[n]

# latest time
latest_time <- str_sub(file, start = 0, end = -19)
latest_time <- as.numeric(latest_time)



##################################
# load solar zenith angle data ###
##################################

# extracted_Solar_Zenith <-  read.csv("/home/mariners/SEVIRI_DUST/extracted_Solar_Zenith.csv")
# Solar_Zenith_NIGHTTIME <- extracted_Solar_Zenith$DATETIME[extracted_Solar_Zenith$Zenith_Angle > 108]
# 
# 
# # daytime
# year <- str_sub(Solar_Zenith_DAYTIME, start = 0, end = -16)
# month <- str_sub(Solar_Zenith_DAYTIME, start = 6, end = -13)
# day <- str_sub(Solar_Zenith_DAYTIME, start = 9, end = -10)
# hour <- str_sub(Solar_Zenith_DAYTIME, start = 12, end = -7)
# minutes <- str_sub(Solar_Zenith_DAYTIME, start = 15, end = -4)
# Solar_Zenith_DAYTIME <- paste0(year, month, day, hour, minutes)
# Solar_Zenith_DAYTIME <- as.data.frame(Solar_Zenith_DAYTIME)
# 
# 
# ### nighttime
# # year <- str_sub(Solar_Zenith_NIGHTTIME, start = 0, end = -16)
# # month <- str_sub(Solar_Zenith_NIGHTTIME, start = 6, end = -13)
# # day <- str_sub(Solar_Zenith_NIGHTTIME, start = 9, end = -10)
# # hour <- str_sub(Solar_Zenith_NIGHTTIME, start = 12, end = -7)
# # minutes <- str_sub(Solar_Zenith_NIGHTTIME, start = 15, end = -4)
# # Solar_Zenith_NIGHTTIME <- paste0(year, month, day, hour, minutes)
# # Solar_Zenith_NIGHTTIME <- as.data.frame(Solar_Zenith_NIGHTTIME)
# 
# 
# if (nrow(Solar_Zenith_DAYTIME)==0) {
#   Solar_Zenith_DAYTIME <- "AAA"
# }
# 
# 
# # find matches between seviri bands @ nighttime 
# filenames_T07 <- unique (grep(paste(Solar_Zenith_DAYTIME$Solar_Zenith_DAYTIME,collapse="|"), 
#                               filenames_T07, value=TRUE))
# filenames_T09 <- unique (grep(paste(Solar_Zenith_DAYTIME$Solar_Zenith_DAYTIME,collapse="|"), 
#                               filenames_T09, value=TRUE))
# filenames_T10 <- unique (grep(paste(Solar_Zenith_DAYTIME$Solar_Zenith_DAYTIME,collapse="|"), 
#                               filenames_T10, value=TRUE))
# filenames_T04 <- unique (grep(paste(Solar_Zenith_DAYTIME$Solar_Zenith_DAYTIME,collapse="|"), 
#                               filenames_T04, value=TRUE))
# filenames_R01 <- unique (grep(paste(Solar_Zenith_DAYTIME$Solar_Zenith_DAYTIME,collapse="|"), 
#                               filenames_R01, value=TRUE))
# filenames_R02 <- unique (grep(paste(Solar_Zenith_DAYTIME$Solar_Zenith_DAYTIME,collapse="|"), 
#                               filenames_R02, value=TRUE))
# filenames_R03 <- unique (grep(paste(Solar_Zenith_DAYTIME$Solar_Zenith_DAYTIME,collapse="|"), 
#                               filenames_R03, value=TRUE))


#########################################################################################
# define START and END date to create a reference (background brightness temperature) ###


DATE <- date(time)
# DATE <- as.numeric(DATE)
start <- DATE-3  # DATE-15
end <- DATE-1 # DATE-1 (always)

TS <- seq(from=start, by=1, to=end)
TS <- format(TS, format="%Y%m%d")
# TS <- as.numeric(TS)


# x = 3315 lines
# y = 3712 lines

LON <- seq(from= 30.0055, to = 59.9945, by =0.009047)  #3315
LAT <- seq(from= 10.0065, to = 39.9949, by =0.008079)  #3712
xmn = min(LON)
xmx = max(LON)
ymn = min(LAT)
ymx = max(LAT)

# make an empty matrix
# BTDref <- matrix(0, nrow = 3315, ncol = 3712)
BTDREF <- matrix(0, nrow = 3315, ncol = 3712)
Missing_file <- data.frame(matrix(0, ncol = 1, nrow = 30))


# t <- DATE



##################################
# create reference background ####
################################## 

count1 <- 0

# for (i in 1:length(filenames_T07)) {

for (t in TS) {
  
# t <- TS[1]
# t <- as.character(t) 
filenames_T07_ref <- dir("/research/SEVIRI_data_Raw_data/T07", pattern = t)
filenames_T07_ref <- filenames_T07_ref[grep(".img", filenames_T07_ref, fixed = T)]
filenames_T09_ref <- dir("/research/SEVIRI_data_Raw_data/T09", pattern = t)
filenames_T09_ref <- filenames_T09_ref[grep(".img", filenames_T09_ref, fixed = T)]

DATE <- date(time)
DATE <- DATE-3
DATE <- format(DATE, format="%Y%m%d")

# j <- 10

for (j in 1:length(filenames_T07_ref)) {
  remove(A1, A2)
  
tryCatch({
  A1 <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/T07/",filenames_T07_ref[j]))
  A1 <- as.matrix(A1)+273  # conversion into degrees Kelvin
  A2 <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/T09/",filenames_T09_ref[j]))
  A2 <- as.matrix(A2)+273
  count1 <- count1 + 1
}, error= function(err) { print(paste0("no band T07 & T09"))

}, finally = {

})
  
  
tryCatch({ 
  if (t == DATE) {
count1 <- count1 + 1
BTDref <- A2 - A1 
}

else {
 remove(BTD108_087) 
    BTD108_087 <- A2 - A1
     BTDref <- pmax(BTDREF, BTD108_087)  # pairwise max between matrices
     BTDREF <- BTDref
   # BTDref <- pmax(BTDref, BTD108_087)  # pairwise max between matrices
  }
    })
 }

 }


#######################################  
#### end of building reference ########
#######################################
  
count2 <- 0
count3 <- 0

# i <- 22

for (i in 1:length(filenames_T07)) {
  remove(B1, B2, B3)
  
  tryCatch({
    B1 <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/T10/",filenames_T10[i]))
    B1 <- as.matrix(B1)+273
  }, error= function(err) { print(paste0("no band T10"))
  }, finally = { 
    count3 <- count3 + 1;
    Missing_file = filenames_T10[i]
  })
  
  tryCatch({
    B2 <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/T09/",filenames_T09[i]))
    B2 <- as.matrix(B2)+273
    
  }, error= function(err) { print(paste0("no band T09"))
  }, finally = { 
    count3 <- count3 + 1;
    Missing_file = filenames_T09[i]
  })
  
  tryCatch({
    B3 <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/T07/",filenames_T07[i]))
    B3 <- as.matrix(B3)+273
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
  
  
  remove(BT108, BT120_BT108, BT108_BT087, BTD108_087anom)
  count2 <- count2 + 1
  BT108 <- B2
  BT120_BT108 <- B1 - B2
  BT108_BT087 <- B2 - B3
  BTD108_087anom <- BT108_BT087 - BTDref
  # create a stacked raster
 # Dust_daily_each_time_step <- ((BT108 >= 285) & (BT120_BT108 >= 0) & (BT108_BT087 <= 10) & (BTD108_087anom <= -2))
 # Dust_daily_each_time_step <- ((BT108 >= 296) & (BT120_BT108 >= 0) & (BT108_BT087 <= 10) & (BTD108_087anom <= -2))
#  Dust_daily_each_time_step <- ((BT108 >= 289) & (BT120_BT108 >= 0) & (BT108_BT087 <= 10) & (BTD108_087anom <= -2))
  Dust_daily_each_time_step <- ((BT108 >= 291) & (BT120_BT108 >= 0) & (BT108_BT087 <= 10) & (BTD108_087anom <= -2))
  
  
  MASK <- Dust_daily_each_time_step*1
  MASK[is.na(MASK)] <- 0
  max(MASK)
#  MASK[MASK == 0] <- 0
  
  
  DUST_mask <-  t(MASK[ , ])
  DUST_mask_a <- raster(DUST_mask, 30.1, 59.9, 10.4,  41.55, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  # plot(DUST_mask)

  
  # make and SAVE a geotiff raster
  writeRaster(DUST_mask_a, paste0("/home/mariners/MASKS/",
                                str_sub(filenames_R01[i], start = 1, end = -19),
                                "_MASK.tif") , options= "INTERLEAVE=BAND", overwrite=T)
  
  
}

  
# remove files containing NA

setwd("/home/mariners/RGB_masks_tif/")
patt <- "NA"
filenames_NA <- list.files(pattern = patt)
file.remove(filenames_NA) 


############################################################################################

# run Python script for DUST alerts



