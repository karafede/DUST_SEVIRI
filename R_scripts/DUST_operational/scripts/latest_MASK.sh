#!/bin/bash

# generate mask of dust only at DAYTIME
mainPath_script=/home/mariners/SEVIRI_DUST/ 
cd $mainPath_script
Rscript ${mainPath_script}/MASK_DUST_SEVIRI_I_method_FK_Op.R
# Rscript ${mainPath_script}/MASK_DUST_SEVIRI_img_II_method_MetFr_FK_Op.R


mainPath=/home/mariners/MASKS/
cd $mainPath 

# select the latest file
ls -t1 |  head -n 1

latest_file=$(ls -t | head -n 1)
echo $latest_file


# subset only the date and time
latest_time=${latest_file:0:12}
echo $latest_time

python /home/mariners/SEVIRI_DUST/scripts/seviri_dust_alert.py ${latest_time}