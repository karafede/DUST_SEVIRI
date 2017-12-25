#!/bin/bash


mainPath=/home/mariners/SEVIRI_DUST/   dest_folder=/home/mariners/RGB_masks_MetFr_tif/

cd $mainPath
# Rscript ${mainPath}/DUST_SEVIRI_img_II_method_MetFr_FK_Op.R
Rscript ${mainPath}/DUST_SEVIRI_img_I_method_FK_Op.R

# rsync -avz ${dest_folder}/*.tif pvernier@atlas-prod.minet.ae:/home/pvernier/scripts_cron/SEVIRI_dust_RGB 
# rsync -avz ${dest_folder}/*.tif fkaragulian@cesam-uat:/home/pvernier/scripts_cron/SEVIRI_dust_RGB 