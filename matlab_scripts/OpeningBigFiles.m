clc
clear

n1 = datenum(2012,04,01);
n2 = datenum(2012,04,30);

DateVectorNewYear = datevec(n1);
Year = DateVectorNewYear(1);
NewYear = datenum(Year,01,01);
d1 = n1 - NewYear + 1;
d2 = n2 - NewYear + 1;

Newfile = matfile('Dust_daily_SDF_2012_4to6_end.mat');
July2012 = Newfile.Dust_daily_each_time_step(d1:d2,1:96);