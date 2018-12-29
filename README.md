# DUST_SEVIRI
## An ensemble of R scripts to process satellite data from the geostationary satellite SEVIRI. The Infrared and Visible bands are processed from raw **.img** files. True color (RGB) and false color images are generated to display daytime and nighttime images. The processing also includes an algorithm to track DUST presents in the atmosphere.
## The sripts are for operational data processing on LINUX machines, but they can also run on a Windows server. Bash codes are also reported (.sh extension).

See below for more details:

True color-RGB (daytime) and infrared images (nighttime) of the atmosphere are generated every ~ 40 minutes with 15 minutes images scenes. On the top of each satellite image, a DUST MASK is generated according to the <strong> MeteoFrance </strong> and/or <strong> EUMETSAT </strong> algorithm.

Bash codes to run the R scripts to generate dust masks and RGB images are: execute_SEVIRI_mask.sh (daytime) and execute_SEVIRI_mask_NIGHT.sh (nighttime). The operational codes processing the SEVIRI data are: 

## EUMETSAT method
<strong> DUST_SEVIRI_img_I_method_FK_Op.R </strong> (daytime)
<strong> DUST_SEVIRI_img_NIGHT_I_method_FK_Op.R </strong> (nighttime)
 
## MeteoFrance
<strong> DUST_SEVIRI_img_NIGHT_II_method_MetFr_FK_Op.R </strong> (daytime)
<strong> DUST_SEVIRI_img_II_method_MetFr_FK_Op.R </strong> (nighttime)

Only DUST MASK images (without being overlaid to color images) are generated with these two scripts. 

## EUMETSAT method
<strong> MASK_DUST_SEVIRI_I_method_FK_Op.R </strong> (daytime)
## MeteoFrance
<strong> MASK_DUST_SEVIRI_img_II_method_MetFr_FK_Op.R </strong> (nighttime)


The above two scripts are controlled by the bash script <strong> latest_MASK.sh </strong> that is also issuing the email alert when SUST is detected in a 100 km buffer around a location of your choice.
The script <strong> execute_SEVIRI_solar_zenith.sh </strong> runs the R code <strong> Solar_Zenith_SEVIRI.R </strong> that extract the solar zenith angle from SEVIRI metadata in order to set the angle at which the sunrise occurs.

Please hit me up if you need further clarifications
