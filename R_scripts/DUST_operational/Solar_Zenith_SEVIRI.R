
library(raster)
library(rgdal)
library(stringr)
library(lubridate)
library(leaflet)
library(webshot)
library(htmlwidgets)
library(mapview)
library(NISTunits)
library(dplyr)


setwd("/research/SEVIRI_data_Raw_data/")
source("/home/mariners/SEVIRI_DUST/extract_pnt_raster.R")

time <- Sys.time()
year <- str_sub(time, start = 0, end = -16)
month <- str_sub(time, start = 6, end = -13)
day <- str_sub(time, start = 9, end = -10)

DATE <- date(time)
DATE <- paste0(year,month,day)
# DATE <- "20171205"
# DATE <- as.numeric(DATE)

##################

# current_date <- paste0(year,month,day)
# current_date <- "20171211"
current_date <- DATE


##################

# DATE <- "2018-01-08"
# DATE <- as.Date(DATE) 
# 
# current_date <- "20180108"

filenames_HRV <- dir("/research/SEVIRI_data_Raw_data/HRV", pattern = current_date)
filenames_HRV <- filenames_HRV[grep(".geo.img", filenames_HRV, fixed = T)]

LON <- seq(from= 30.0055, to = 59.9945, by =0.009047)  #3315
LAT <- seq(from= 10.0065, to = 39.9949, by =0.008079)  #3712
xmn = min(LON)
xmx = max(LON)
ymn = min(LAT)
ymx = max(LAT)


i <- 2

location_AUH <- read.csv("/home/mariners/SEVIRI_DUST/Abu_Dhabi_AUH_site.csv")

extracted_Solar_Zenith <- NULL
DateTime <- NULL
site_AUH <- NULL

# the geo.img contains 7 bands about Latitude, Longitude, SensorZenith, SensorAzimuth, SolarZenith, SolarAzimuth, RelativeAzimuth
# look for band 5 that is the SolarZenith angle

### extract Solar Zenith angle over Abu Dhabi
### site AUH (Abu Dhabi Aeroport)

for (i in 1:length(filenames_HRV)) {

      SolarZenith <- readGDAL(paste0("/research/SEVIRI_data_Raw_data/HRV/",filenames_HRV[i]), band = 5)
      SolarZenith <- as.matrix(SolarZenith)
      SolarZenith <- t(SolarZenith)
      SolarZenith <- raster(SolarZenith, 30.1, 59.9, 10.4,  41.55, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
      # plot(SolarZenith)
      TS <- str_sub(filenames_HRV[i], start = 0, end = -23)
      EXTRACTED_Solar_Zenith <- extract_points(SolarZenith, location_AUH)
      extracted_Solar_Zenith = rbind(extracted_Solar_Zenith, EXTRACTED_Solar_Zenith)        # data vector
      DATETIME_ZENITH <- as.data.frame(rep(TS, nrow(location_AUH)))       # time vector
      DateTime <- rbind(DateTime, DATETIME_ZENITH)
      SITE_AUH <- as.data.frame(location_AUH$Site)
      site_AUH <- rbind(site_AUH, SITE_AUH)
      
    }
    
    
    extracted_Solar_Zenith <- cbind(DateTime, extracted_Solar_Zenith, site_AUH)   # it should be the same length od the AQ_data_2015
    colnames(extracted_Solar_Zenith) <- c("DATETIME", "Zenith_Angle", "Site")
    
    extracted_Solar_Zenith <- extracted_Solar_Zenith %>%
      mutate(DATETIME = ymd_hm(DATETIME))
  
    
    # save data-------------------------------------
    write.csv(extracted_Solar_Zenith, "/home/mariners/SEVIRI_DUST/extracted_Solar_Zenith.csv")
    
    