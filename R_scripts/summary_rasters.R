

library(raster)

setwd("F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/TERRA_time")

patt <- ".tif"
filenames <- list.files(pattern = patt) 

i <- 3

for (i in 1:length(filenames)) {
r <- raster(filenames[i])
# r <- raster("20150331_SEVIRI_TERRA_time.tif")
plot(r)

values <- getValues(r)
SUM <- sum(values, na.rm = TRUE)
print(i)
print(SUM)


}

#################################################################################

library(raster)

setwd("F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/AQUA_time")

patt <- ".tif"
filenames <- list.files(pattern = patt) 

i <- 3

for (i in 1:length(filenames)) {
  r <- raster(filenames[i])
 # r <- raster("20100331_SEVIRI_AQUA_time.tif")
  plot(r)
  
  values <- getValues(r)
  SUM <- sum(values, na.rm = TRUE)
  print(i)
  print(SUM)
  
}

#################################################################################

library(raster)

setwd("F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/daily_sum")

patt <- ".tif"
filenames <- list.files(pattern = patt) 

i <- 25

for (i in 1:length(filenames)) {
  r <- raster(filenames[i])
  plot(r)
  
  values <- getValues(r)
  SUM <- sum(values, na.rm = TRUE)
  print(i)
  print(SUM)
  
}


##################################################################################
