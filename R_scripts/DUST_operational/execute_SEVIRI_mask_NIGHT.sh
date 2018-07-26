#!/bin/bash


# mainPath=/home/mariners/SEVIRI_DUST/   dest_folder=/home/mariners/RGB_masks_MetFr_tif/
mainPath=/home/mariners/SEVIRI_DUST/   dest_folder=/home/mariners/RGB_masks_tif/
dest_folder_RECREMA=/home/mariners/RECREMA_MASKS_DUST/

cd $mainPath
# Rscript ${mainPath}/DUST_SEVIRI_img_NIGHT_II_method_MetFr_FK_Op.R
Rscript ${mainPath}/DUST_SEVIRI_img_NIGHT_I_method_FK_Op.R

# copy files to RECREMA server for MOCCAE website
scp ${dest_folder_RECREMA}/*.tif cesamuser@masdar-stratobus:/data_moccae/weather_aq/CESAM/Dust_track/

rsync -avz ${dest_folder}/*.tif pvernier@atlas-prod.minet.ae:/home/pvernier/scripts_cron/SEVIRI_dust_RGB 
rsync -avz ${dest_folder}/*.tif fkaragulian@cesam-web-prod:/data/scripts_cron/SEVIRI_dust_RGB 
rsync -avz ${dest_folder}/*.tif fkaragulian@cesam-web-uat:/data/scripts_cron/SEVIRI_dust_RGB 
rsync -avz ${dest_folder}/*.tif fkaragulian@cesam-web-dev:/data/scripts_cron/SEVIRI_dust_RGB 
