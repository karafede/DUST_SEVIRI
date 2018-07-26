#!/bin/bash


path=/research/SEVIRI_data_Raw_data/
date=$1
echo $date
rem_date=$date                 #`date -d"$date - 8 days" +%Y%m%d`
echo $rem_date

for parm in HRV  R01  R02  R03  T04  T07  T08  T09  T10  T11 ; do

      rm ${path}/${parm}/${rem_date}*_MSG4_Test_${parm}.img 
      rm ${path}/${parm}/${rem_date}*_MSG4_Test_${parm}.hdr 
      rm ${path}/${parm}/${rem_date}*_MSG4_Test_${parm}.geo.img 
      rm ${path}/${parm}/${rem_date}*_MSG4_Test_${parm}.geo.hdr 

done
exit
