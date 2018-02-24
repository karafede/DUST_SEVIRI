

library(readr)
library(sp)
library(raster)
library(gstat)
library(rgdal)
library(RNetCDF)
library(ncdf4)
library(stringr)
library(rgeos)
library(leaflet)
library(htmlwidgets)
library(dplyr)

e <- extent(50,60,20, 28)  # UAE extent
plot(e)

# make a spatial polygon from the extent
p <- as(e, "SpatialPolygons")
plot(p)
proj4string(p) <- CRS("+proj=longlat +datum=WGS84")
# crs(p) <- "proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

# save shp file for the rectangular DOMAIN
setwd("Z:/_SHARED_FOLDERS/Air Quality/Phase 2/admin_GIS/prova_shapes")
shapefile(p, "rectangular_domain.shp", overwrite=TRUE)

# reload and plot domain

dir <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 2/admin_GIS/prova_shapes"
shp_rect <- readOGR(dsn = dir, layer = "rectangular_domain")
# ----- Transform to EPSG 4326 - WGS84 (required)
shp_rect <- spTransform(shp_rect, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
shp_rect@data$name <- 1:nrow(shp_rect)
plot(shp_rect)


#########################
### shapefile UAE #######
#########################

dir <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 2/HISTORICAL_dust/UAE_boundary"
### shapefile for UAE
shp_UAE <- readOGR(dsn = dir, layer = "uae_emirates")

# ----- Transform to EPSG 4326 - WGS84 (required)
shp_UAE <- spTransform(shp_UAE, CRS("+init=epsg:4326"))
# names(shp)

shp_UAE@data$name <- 1:nrow(shp_UAE)
plot(shp_rect)
plot(shp_UAE, add=TRUE, lwd=1)

###################################
## shapefile Arabian Peninsual ####
###################################

dir <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 2/Dust_Event_UAE_2015/WRFChem_domain"
shp_AP <- readOGR(dsn = dir, layer = "ADMIN_domain_d01_WRFChem")

# ----- Transform to EPSG 4326 - WGS84 (required)
shp_AP <- spTransform(shp_AP, CRS("+init=epsg:4326"))
# names(shp)

shp_AP@data$name <- 1:nrow(shp_AP)
plot(shp_rect)
plot(shp_AP, add=TRUE, lwd=1)

# d01_shp_WW <- crop(shp_WW, e)
# plot(d01_shp_WW)
# setwd("Z:/_SHARED_FOLDERS/Air Quality/Phase 2/Dust_Event_UAE_2015/WRFChem_domain")
# shapefile(d01_shp_WW, "ADMIN_domain_MIKE.shp.shp", overwrite=TRUE)

##################################################
# make a point for a location in the UAE #########
##################################################

require(sf)
coordinates_ABU_DHABI <- read.table(text="
                    longitude    latitude
                    54.646    24.43195",
                    header=TRUE)

# new coordiantes over AP
coordinates_ABU_DHABI <- read.table(text="
                    longitude    latitude
                    47.63    21.08",
                    header=TRUE)

coordinates_ABU_DHABI <- read.table(text="
                    longitude    latitude
                    47.63    21.08",
                    "54.646    24.43195",
                    header=TRUE)


coord_ABU_DHABI_point <- st_as_sf(x = coordinates_ABU_DHABI, 
                        coords = c("longitude", "latitude"),
                        crs = "+proj=longlat +datum=WGS84")
# simple plot
plot(coord_ABU_DHABI_point)

# convert to sp object if needed
coord_ABU_DHABI_point <- as(coord_ABU_DHABI_point, "Spatial")

# shp_buff <- gBuffer(shp_UAE, width=40, byid=TRUE, quadsegs=10)
shp_buff <- gBuffer(coord_ABU_DHABI_point, width=5)
shp_buff <- spTransform(shp_buff, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
plot(shp_buff)
plot(shp_UAE, add=TRUE, lwd=1)
plot(shp_AP, add=TRUE, lwd=1)

# save shp file for the crcular buffer
setwd("Z:/_SHARED_FOLDERS/Air Quality/Phase 2/admin_GIS/prova_shapes")
shapefile(shp_buff, "circular_buffer.shp", overwrite=TRUE)
dir <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 2/admin_GIS/prova_shapes"
# reload and plot domain
shp_buff <- readOGR(dsn = dir, layer = "circular_buffer")


#######################################
# load .tif file for the DUST MASK ####
#######################################

setwd("Z:/_SHARED_FOLDERS/Air Quality/Phase 2/DUST SEVIRI/masks")
patt <- ".tif"
filenames <- list.files(pattern = patt)

filenames <- filenames[18]
filenames
# [1] "201802200615_MASK.tif"
DUST_mask <- raster(filenames)

# mask and crop raster over the UAE
# DUST_mask <- crop(DUST_mask, extent(shp_UAE))
# DUST_mask <- mask(DUST_mask, shp_UAE)

# DUST_mask <- crop(DUST_mask, extent(shp_AP))
# DUST_mask <- mask(DUST_mask, shp_AP)

plot(DUST_mask)

# get points from the raster (lat, lon, points)
values <- rasterToPoints(DUST_mask)
colnames(values) <- c("x", "y", "values")
values <- as.data.frame(values) 
head(values)

crs <- projection(shp_buff) ### get projections from shp file
# make a spatial object with the points from the raster
values <- SpatialPointsDataFrame(values[,1:2], values, 
                                       proj4string=CRS(crs))

# get NUMBER of POINTS that fall into the circular buffer zone
# pts_in_buffer <- sp::over(values, shp_buff, fun = NULL)
# pts_in_buffer <- over(values, shp_buff[, "ID"])

library(spatialEco)
pts_in_buffer <- point.in.poly(values, shp_buff)

pts_in_buffer <- as.data.frame(pts_in_buffer)
pts_in_buffer <- pts_in_buffer %>%
  filter(values > 0)

#### Sum of points in the circular buffer (each point correspond to an area of ~ 1km)
data_points <- pts_in_buffer %>% 
  dplyr::summarize(sum = sum(values))




