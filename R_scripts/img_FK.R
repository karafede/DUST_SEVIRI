
library(raster)
library(rgdal)
library(stringr)
library(lubridate)

setwd("D:/img_files_prova")
# directory <- getwd()
filenames_T04 <- dir("D:/img_files_prova/T04", pattern="\\.img$")
filenames_T09 <- dir("D:/img_files_prova/T09", pattern="\\.img$")
filenames_T10 <- dir("D:/img_files_prova/T10", pattern="\\.img$")
# filenames_T04 <- dir(directory, pattern="\\.img$")
# filenames_hdr <- dir(directory, pattern="\\.hdr$")

# filenames_hdr <- dir("D:/img_files_prova/T04", pattern="\\.hdr$")
# setwd("D:/img_files_prova/T04")
# 
# hdr(filenames_hdr, format="ENVI") 

time <- Sys.time()
year <- str_sub(time, start = 0, end = -16)
month <- str_sub(time, start = 6, end = -13)
day <- str_sub(time, start = 9, end = -10)

DATE <- date(time)

# DATE <- paste0(year,month,day)
# DATE <- "20171205"
# DATE <- as.numeric(DATE)

# map <- readGDAL(filenames_T04[1]) 
# map <- as.matrix(map)

# summary(map) 
# image(map) 
# e <- extent(map)

##################

DATE <- "2017-12-07"
DATE <- as.Date(DATE) 

# current_date <- paste0(year,month,day)
current_date <- "20171207"
filenames_T04 <- dir("D:/img_files_prova/T04", pattern = current_date)
filenames_T04 <- filenames_T04[grep(".img", filenames_T04, fixed = T)]

# DateTime <- str_sub(filenames_T04[1], start = 1, end = -19)

# start <- DATE-5
# end <- DATE-1

start <- DATE
end <- DATE
TS <- seq(from=start, by=1, to=end)

# x = 3315 lines
# y = 3712 lines

LON <- seq(from= 30.0055, to = 59.9945, by =0.009047)  #3315
LAT <- seq(from= 10.0065, to = 39.9949, by =0.008079)  #3712
xmn = min(LON)
xmx = max(LON)
ymn = min(LAT)
ymx = max(LAT)

# make an empty matrix
BTDref <- matrix(0, nrow = 3315, ncol = 3712)
Missing_file <- data.frame(matrix(0, ncol = 1, nrow = 30))


t <- DATE

#######################
# create reference ####
#######################



for (t in TS) {

# inizialize an empty raster stack for each DAY  
all_rasters <- stack() 
count1 <- 0

i <- 2

for (i in 1:length(filenames_T04)) {
  remove(A1, A2)
tryCatch({
  A1 <- readGDAL(paste0("D:/img_files_prova/T04/",filenames_T04[i]))
  A1 <- as.matrix(A1)
 # image(A1)
  A2 <- readGDAL(paste0("D:/img_files_prova/T09/",filenames_T09[i]))
  A2 <- as.matrix(A2)
  count1 <- count1 + 1
}, error= function(err) { print(paste0("no band T04"))
  
}, finally = {
  
})
  
  
  
tryCatch({ 
  if (t == DATE-5) {
# for (i in 1:length(filenames_T04)) 
count1 <- count1 + 1
BTDref <- A2 - A1 
}

else {
 remove(BTD108_087) 
#  for (i in 1:length(filenames_T04)) 
    BTD108_087 <- A2 - A1
    BTDref <- pmax(BTDref, BTD108_087)  #pairwise max between matrices
  }
    })
  }

count2 <- 0
count3 <- 0

i <- 2

for (i in 1:length(filenames_T04)) {
  remove(B1, B2, B3)
  
  tryCatch({
    B1 <- readGDAL(paste0("D:/img_files_prova/T10/",filenames_T10[i]))
    B1 <- as.matrix(B1)
  }, error= function(err) { print(paste0("no band T10"))
  }, finally = { 
    count3 <- count3 + 1;
    Missing_file = filenames_T10[i]
  })
  
  tryCatch({
    B2 <- readGDAL(paste0("D:/img_files_prova/T09/",filenames_T09[i]))
    B2 <- as.matrix(B2)
    
  }, error= function(err) { print(paste0("no band T09"))
  }, finally = { 
    count3 <- count3 + 1;
    Missing_file = filenames_T09[i]
  })
  
  tryCatch({
    B3 <- readGDAL(paste0("D:/img_files_prova/T04/",filenames_T04[i]))
    B3 <- as.matrix(B3)
  }, error= function(err) { print(paste0("no band T07"))
  }, finally = { 
    count3 <- count3 + 1;
    Missing_file = filenames_T04[i]
  })
  

  
# for (i in 1:length(filenames_T04)) {
  remove(BT108, BT120_BT108, BT108_BT087, BTD108_087anom)
  count2 <- count2 + 1
  BT108 <- B2
  BT120_BT108 <- B1 - B2
  BT108_BT087 <- B2 - B3
  BTD108_087anom <- BT108_BT087 - BTDref
  # create a stacked raster
  Dust_daily_each_time_step <- ((BT108 >= 285) & (BT120_BT108 >= 0) & (BT108_BT087 <= 10) & (BTD108_087anom <= -2))
  
  # convert logical vector (TRUE & FALSE) into 0 & 1
  Dust_daily_each_time_step <- Dust_daily_each_time_step*1
  Dust_daily_each_time_step <- BT120_BT108  ### !!! jusr as a trial
  Dust_daily_each_time_step <-  t(Dust_daily_each_time_step[ , ])    # IF map is upside down 
  ####  A1 <- A1[nrow(A1):1, ]
  r <- raster(Dust_daily_each_time_step, xmn, xmx, ymn,  ymx, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  plot(r)
#  writeRaster(r, "D:/img_files_prova/T04_prova.tif" , options= "INTERLEAVE=BAND", overwrite=T)
  writeRaster(r, paste0("D:/img_files_prova/",str_sub(filenames_T04[i], start = 1, end = -19),".tif") , options= "INTERLEAVE=BAND", overwrite=T)
  
  # all_rasters <- stack(all_rasters,r)
#  }
}
}


# AAA <- matrix(data = seq(1:20), nrow = 5, ncol = 7)
# AAA <- as.matrix(AAA)
# BBB <- AAA >= 6
# BBB <- BBB*1


