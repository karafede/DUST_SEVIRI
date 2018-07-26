

setwd("/home/mariners/RECREMA_MASKS_DUST/")
RECREMA_dir_SEVIRI_MASK_DUST <- "/home/mariners/RECREMA_MASKS_DUST/"

##################
# remove files ###
##################
files_DUST <- list.files(RECREMA_dir_SEVIRI_MASK_DUST, ".tif$")
if (file.exists(files_DUST)) file.remove(files_DUST) 




