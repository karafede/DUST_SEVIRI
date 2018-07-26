

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
                    longitude    latitude ID
                    47.63    21.08  Saudi
                    55.207   25.008 Dubai", 
                    header=TRUE)


coord_ABU_DHABI_point <- st_as_sf(x = coordinates_ABU_DHABI, 
                        coords = c("longitude", "latitude"),
                        crs = "+proj=longlat +datum=WGS84")
# simple plot
# plot(coord_ABU_DHABI_point)

# convert to sp object if needed
coord_ABU_DHABI_point <- as(coord_ABU_DHABI_point, "Spatial")
setwd("Z:/_SHARED_FOLDERS/Air Quality/Phase 2/admin_GIS/prova_shapes")
shapefile(coord_ABU_DHABI_point, "points.shp", overwrite=TRUE)

dir <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 2/admin_GIS/prova_shapes"
points <- readOGR(dsn = dir, layer = "points")
plot(points)
# add a buffer around each point
shp_buff <- gBuffer(points, width=1, byid=TRUE)
shp_buff <- spTransform(shp_buff, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
plot(shp_buff)
plot(shp_UAE, add=TRUE, lwd=1)
plot(shp_AP, add=TRUE, lwd=1)

# save shp file for the circular buffer
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
# find points inside the buffer
pts_in_buffer <- point.in.poly(values, shp_buff)
head(pts_in_buffer@data)
data_points <- pts_in_buffer@data 
names(data_points)


# Aggregate by zone/polygon
data_points <- pts_in_buffer@data 
names(data_points)

data_points <- data_points %>% 
  dplyr::group_by(ID) %>% 
  dplyr::summarise(sum = sum(values)) %>% 
  dplyr::ungroup()


# Join aggregation to polygons 
shp_buff@data <- shp_buff@data %>% 
  left_join(data_points, "ID")

# Filter out polygons with no data
data_points <- subset(data_points, !is.na(sum))


# Transform projection system (British projections)
# shp <- spTransform(shp, "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs")
plot(data_points)

# Export shp file
head(shp_buff@data)
# writeOGR(shp_buff,"Z:/_SHARED_FOLDERS/Air Quality/Phase 2/DUST SEVIRI/R_scripts",
#          "Sum_Stats", driver = "ESRI Shapefile",
#          overwrite_layer = TRUE)


data_points <- shp_buff@data[,c("ID","sum")]
row.names(data_points) <- row.names(shp_buff)

shp_buff <- SpatialPolygonsDataFrame(shp_buff, data=data_points)

row.names(shp_buff)
row.names(data_points)


#### Write GeoJSON for Leaflet application ############################

# ----- Write data to GeoJSON
dir <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 2/DUST SEVIRI/R_scripts"
leafdat <- paste(dir, "/",  ".geojson_SUMMARY_STATS", sep="") 
leafdat

####  ATT !!!!! erase existing .geojson file when re-runing code ######
writeOGR(shp_buff, leafdat, layer="", driver="GeoJSON")  ## erase existing .geojson file when re-runing code 


#### Plot Jeojson with leaflet
SUMMARY_STATS <- readOGR("Z:/_SHARED_FOLDERS/Air Quality/Phase 2/DUST SEVIRI/R_scripts/.geojson_SUMMARY_STATS", "OGRGeoJSON")




map_SUMMARY_STATS <- leaflet(SUMMARY_STATS)

#### colors for map
qpal_SUMMARY <- colorQuantile("Reds", SUMMARY_STATS$sum, n = 7)

#### colors for legend (continuous)
pal_SUMMARY <- colorNumeric(
  palette = "Reds",
  domain = SUMMARY_STATS$sum)

popup_SUMMARY <- paste0("<p><strong>daily Emirate: </strong>", 
                        SUMMARY_STATS$ID, 
                         "<br><strong>AQI PM<sub>2.5</sub>: </strong>", 
                        SUMMARY_STATS$sum)


####### CREATE map #######################################################

map = leaflet(SUMMARY_STATS) %>% 
  addTiles(group = "OSM (default)") %>%
  addProviderTiles("OpenStreetMap.Mapnik", group = "Road map") %>%
  addProviderTiles("Thunderforest.Landscape", group = "Topographical") %>%
  addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
  addProviderTiles("Stamen.TonerLite", group = "Toner Lite") %>%
  
  
  # PM2.5 satellite data 
  addPolygons(stroke = TRUE, smoothFactor = 0.2, 
              fillOpacity = 0.5, 
              color = ~ qpal_SUMMARY(sum),
              weight = 2,
              popup = popup_SUMMARY,
              group = "SUMMARY_STATS") %>%


  # Layers control
  addLayersControl(
    baseGroups = c("Road map", "Topographical", "Satellite", "Toner Lite"),
    overlayGroups = c("SUMMARY_STATS"),
    options = layersControlOptions(collapsed = FALSE))

map


#### to export into html file, use the button in the Wiever window: 
#### "save as Web Page"...PM25_Sat_new

saveWidget(map,
           file="Z:/_SHARED_FOLDERS/Air Quality/Phase 2/DUST SEVIRI/R_scripts/Buffer_SUMS.html",
           selfcontained = FALSE)



