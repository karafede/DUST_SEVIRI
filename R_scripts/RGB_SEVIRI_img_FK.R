
library(raster)
library(rgdal)
library(stringr)
library(lubridate)
library(leaflet)
library(mapview)
library(RNetCDF)

setwd("D:/img_files_prova")
# directory <- getwd()
filenames_R01 <- dir("D:/img_files_prova/R01", pattern="\\.img$")
filenames_R02 <- dir("D:/img_files_prova/R02", pattern="\\.img$")
filenames_R03 <- dir("D:/img_files_prova/R03", pattern="\\.img$")


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
filenames_R01 <- dir("D:/img_files_prova/R01", pattern = current_date)
filenames_R01 <- filenames_R01[grep(".img", filenames_R01, fixed = T)]

# DateTime <- str_sub(filenames_R01[1], start = 1, end = -19)

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


t <- DATE

dir <- "D:/Dust_Event_UAE_2015/WRFChem_domain"

### shapefile for UAE
shp_UAE <- readOGR(dsn = dir, layer = "ADMIN_domain_d01_12km_WRFChem")

plot(shp_UAE)
crs <- projection(shp_UAE) ### get projections from shp file
shp_UAE <- spTransform(shp_UAE, CRS("+init=epsg:4326"))

# PM25_2015_GRW <- raster("D:/MODIS_AOD/GlobalGWR_PM25_GL_201501_201512-RH35.nc")
# projection(PM25_2015_GRW) <- CRS("+proj=longlat +datum=WGS84")
### crop raster over the UAE shp file  ###############################
# PM25_2015_GRW <- crop(PM25_2015_GRW, extent(shp_UAE))
# PM25_2015_GRW <- mask(PM25_2015_GRW, shp_UAE)

#######################
# create reference ####
#######################


for (t in TS) {

i <- 2

for (i in 1:length(filenames_R01)) {
  remove(R01, R02, R03)
tryCatch({
  R01 <- readGDAL(paste0("D:/img_files_prova/R01/",filenames_R01[i]))
  R01 <- as.matrix(R01)
  R01 <-  t(R01[ , ])
  r1 <- raster(R01, 30.1, 60, ymn,  42, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  plot(r1)
  plot(shp_UAE, add=TRUE, lwd=1)
}, error= function(err) { print(paste0("no band R01"))
  
}, finally = {
  
})
  
  
  
  tryCatch({
    R02 <- readGDAL(paste0("D:/img_files_prova/R02/",filenames_R02[i]))
    R02 <- as.matrix(R02)
    R02 <-  t(R02[ , ])
    r2 <- raster(R02, 30.1, 60, ymn,  42, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
    plot(r2)
  }, error= function(err) { print(paste0("no band R02"))
    
  }, finally = {
    
  })
  
  
  
  tryCatch({
    R03 <- readGDAL(paste0("D:/img_files_prova/R03/",filenames_R03[i]))
    R03 <- as.matrix(R03)
    R03 <-  t(R03[ , ])
    r3 <- raster(R01, 30.1, 60, ymn,  42, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
    plot(r3)
  }, error= function(err) { print(paste0("no band R03"))
    
  }, finally = {
    
  })
  
  
}


# create a raster stack with bands representing

# blue: band 19, 473.8nm
# green: band 34, 548.9nm
# red; band 58, 669.1nm

# create raster stack
rgbRaster <- stack(r3,r2,r1)   #RGB == R03, R02, R01 (Red, Gree, Blue)
# plot(rgbRaster)


# plot an RGB version of the stack
plotRGB(rgbRaster,r=3,g=2,b=1, stretch = "lin")
writeRaster(rgbRaster, paste0("D:/img_files_prova/",str_sub(filenames_R01[i], start = 1, end = -19),"_RGB.tif") , options= "INTERLEAVE=BAND", overwrite=T)

}

# make leflet map and take a screenshot ####

# # define popup for time scene
# "h2 { font-size: 3px;}"
# content <- paste('<h2><strong>', name_time,'', sep = "")

my_leaflet_map <- leaflet() %>% 
  addTiles() %>% 
  addTiles(group = "OSM (default)") %>%
  addProviderTiles("OpenStreetMap.Mapnik", group = "Road map") %>%
  addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
  addProviderTiles("Stamen.TonerLite", group = "Toner Lite") %>%
  
  # addPopups(32, 38, content,
  #           options = popupOptions(closeButton = FALSE)) %>%
  

  addLayersControl(
    baseGroups = c("Road map", "Toner Lite"),
    # overlayGroups = "SEVIRI",
    options = layersControlOptions(collapsed = TRUE))

mapview::viewRGB(rgbRaster, 3, 2, 1, map = my_leaflet_map)


## This is the png creation part
# saveWidget(map, 'temp.html', selfcontained = FALSE)
# webshot('temp.html', file = paste0(str_sub(name_time, start = 1, end = -10), "_",
#                                    str_sub(name_time, start = 12, end = -7), "_",
#                                    str_sub(name_time, start = 15, end = -4),
#                                    ".png"), vwidth = 900, vheight = 900,
#         cliprect = 'viewport')


}

