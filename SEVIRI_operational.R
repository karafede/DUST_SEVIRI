
library(RNetCDF)
library(rgdal)
library(ncdf4)
library(raster)
library(stringr)

# list .nc files
setwd("F:/Operational_DUST/NetCDF")

patt <- ".nc"
filenames <- list.files(pattern = patt)
filenames <- sort(filenames, decreasing = TRUE)
# chose the most recent filename
filenames <- filenames[1] 

# gerate a time sequence for a given day every 15 minuntes

# open the NetCDF file and look at the length of the time (number of scenes)
seviri_file <- nc_open(filenames)
var_value <- ncvar_get(seviri_file)
n = dim(var_value)[3]

time <- Sys.time()
year <- str_sub(time, start = 0, end = -16)
month <- str_sub(time, start = 6, end = -13)
day <- str_sub(time, start = 9, end = -10)
start <- as.POSIXct(paste0(year,"-",month,"-", day, " ", "00:","00:","01"))
interval <- 15 #minutes
end <- start + as.difftime(1, units="days")
TS <- seq(from=start, by=interval*60, to=end-1)
name <- str_sub(filenames, start = 1, end = -4)

# select only the time-range corresponding to the number of scenes ##
### UTC time #####
TS <- TS[1:n]


dir.create("tif_images")
current_dir <- getwd()


# inizialise an empty raster to stack ALL HOURS together in an unique raster 

 import_nc_seviri <- function(filenames){

## !we are importing HDF5 files....different structure!!! ----------------------
  seviri_file <- nc_open(filenames)
  name_vari <- names(seviri_file$var)
  name <- str_sub(filenames, start = 1, end = -4)
  
  
###### read the DUST FLAG variable (only)

     var_value <- ncvar_get(seviri_file)
     LON <- ncvar_get(seviri_file,"lon")
     LAT <- ncvar_get(seviri_file,"lat")
     
     xmn= min(LON)
     xmx=max(LON)
     ymn=min(LAT)
     ymx=max(LAT)
    
     # i = 22
   
  for (i in 1:dim(var_value)[3]){      # time dimension (always 96 scenes over one day)
    r <- raster((var_value[ , , i]), xmn, xmx, ymn,  ymx, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
    plot(r)
    name_time <- TS[i]
    year <- str_sub(name_time, start = 0, end = -16)
    month <- str_sub(name_time, start = 6, end = -13)
    day <- str_sub(name_time, start = 9, end = -10)
    hour <- str_sub(name_time, start = 12, end = -7)
    minutes <- str_sub(name_time, start = 15, end = -4)
    seconds <- str_sub(name_time, start = 18, end = -1)
    DateTime <- paste0(year,"_",month,"_", day,"_", hour, "_", minutes, "_", seconds)
    # save rasters
    writeRaster(r, paste0(current_dir, "/tif_images/",DateTime,".tif") , options= "INTERLEAVE=BAND", overwrite=T)

  }

}

 
 BBB <- lapply(filenames, import_nc_seviri) 
 


#########################################################################################
#########################################################################################

# library(leaflet)
# library(webshot)
# library(htmlwidgets)
# library(RColorBrewer)
# library(raster)
# library(classInt)
# library(stringr)
# 
# # set directory where we want to save the images
# setwd("D:/Dust_Event_UAE_2015/SEVIRI_20150402_outputs/I_method/images_png")
# 
# # save images as webshot from leaflet
# # reload rasters by band or layers (96 scenes)
# 
# # gerate a time sequence for a given day every 15 minuntes
# 
# # start <- as.POSIXct("2015-03-29")
# # start <- as.POSIXct("2015-03-30")
# # start <- as.POSIXct("2015-03-31")
# # start <- as.POSIXct("2015-04-01")
# # start <- as.POSIXct("2015-04-02")
# # start <- as.POSIXct("2015-04-03")
# start <- as.POSIXct("2015-04-04")
# 
# interval <- 15 #minutes
# end <- start + as.difftime(1, units="days")
# TS <- seq(from=start, by=interval*60, to=end-1)
# 
# # i <- 4
# 
# for (i in 1:96) {
# 
#     # load the stacked raster with all the 96 images
#   # SEVIRI_STACK_image <- raster("D:/Dust_Event_UAE_2015/SEVIRI_20150402_outputs/I_method/Seviri_20150329_I_Method_stack.tif", band = i)
#   # SEVIRI_STACK_image <- raster("D:/Dust_Event_UAE_2015/SEVIRI_20150402_outputs/I_method/Seviri_20150330_I_Method_stack.tif", band = i)
#   # SEVIRI_STACK_image <- raster("D:/Dust_Event_UAE_2015/SEVIRI_20150402_outputs/I_method/Seviri_20150331_I_Method_stack.tif", band = i)
#   # SEVIRI_STACK_image <- raster("D:/Dust_Event_UAE_2015/SEVIRI_20150402_outputs/I_method/Seviri_20150401_I_Method_stack.tif", band = i)
#   # SEVIRI_STACK_image <- raster("D:/Dust_Event_UAE_2015/SEVIRI_20150402_outputs/I_method/Seviri_20150402_I_Method_stack.tif", band = i)
#   # SEVIRI_STACK_image <- raster("D:/Dust_Event_UAE_2015/SEVIRI_20150402_outputs/I_method/Seviri_20150403_I_Method_stack.tif", band = i)
#    SEVIRI_STACK_image <- raster("D:/Dust_Event_UAE_2015/SEVIRI_20150402_outputs/I_method/Seviri_20150404_I_Method_stack.tif", band = i)
#   
# 
#   # SEVIRI_STACK_image <- raster("D:/Dust_Event_UAE_2015/SEVIRI_20150402_outputs/I_method/Seviri_20150402_I_Method_stack.tif", band = i)
# plot(SEVIRI_STACK_image)
# 
# name_time <- TS[i]
# 
# min_seviri <- 0
# max_seviri <- 1
# 
# pal_SEVIRI <- colorNumeric(c("#ffffff", "#ff0000"),
#                         c(min_seviri, max_seviri), na.color = "transparent")
# 
# # define popup for time scene
# "h1 { font-size: 4px;}"
#  content <- paste('<h1><strong>', name_time,'', sep = "")
# 
# 
# # file <- "https://www.dropbox.com/s/dxffq8kvgvfb0tn/RGB_20150402_203.jpg?raw=1"
# # 
# # content <- paste("<style> div.leaflet-popup-content {width:auto !important;}</style>",
# #                  "<h2><strong>", name_time,'', sep = "", 
# #                  "<img width=300, heigh=330 src = ", file, ">")
# 
# map <- leaflet() %>% 
#   addTiles() %>% 
#   addTiles(group = "OSM (default)") %>%
#   addProviderTiles("OpenStreetMap.Mapnik", group = "Road map") %>%
#   addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
#   addProviderTiles("Stamen.TonerLite", group = "Toner Lite") %>%
#   
#   addPopups(32, 38, content,
#             options = popupOptions(closeButton = FALSE)) %>%
#  
#   addRasterImage(SEVIRI_STACK_image, 
#                  colors = pal_SEVIRI, 
#                  opacity = 0.5, group = "SEVIRI") %>%
#     addLayersControl(
#     baseGroups = c("Road map", "Toner Lite","Satellite"),
#     overlayGroups = "SEVIRI",
#     options = layersControlOptions(collapsed = TRUE))
# 
# ## This is the png creation part
# saveWidget(map, 'temp.html', selfcontained = FALSE)
# webshot('temp.html', file = paste0(str_sub(name_time, start = 1, end = -10), "_",
#                                    str_sub(name_time, start = 12, end = -7), "_",
#                                    str_sub(name_time, start = 15, end = -4),
#                                    ".png"), vwidth = 900, vheight = 900,
#         cliprect = 'viewport')
# 
# webshot('temp.html', file = "prova.png", vwidth = 900, vheight = 900,
#         cliprect = 'viewport')
# 
# }
 
 

# to make a movie.......
# to use with ImageMagik using the commnad line cmd in windows
# cd into the directory where there are the png files

# magick -delay 100 -loop 0 *.png SEVIRI_DUST_event_02_April_2015.gif

##-------COMBINE TWO ANIMATION IN ONE FILE #####---------------------------------

# magick -delay 100 -loop 0 *.png SEVIRI_DUST_event_02_April_2015_MASK.gif
# magick -delay 100 -loop 0 *.jpg SEVIRI_DUST_event_02_April_2015_RGB.gif



# separate frames of SEVIRI_DUST_event_02_April_2015_MASK.gif--------
# magick SEVIRI_DUST_event_02_April_2015_MASK.gif -coalesce a_%04d.gif  


# separate frames of SEVIRI_DUST_event_02_April_2015_RGB.gif--------
# magick SEVIRI_DUST_event_02_April_2015_RGB.gif -coalesce b_%04d.gif 
