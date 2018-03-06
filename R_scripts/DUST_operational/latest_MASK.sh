#!/bin/bash

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