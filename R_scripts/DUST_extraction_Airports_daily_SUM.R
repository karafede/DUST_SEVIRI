
library(readr)
library(dplyr)
library(lubridate)
library(raster)
library(rgdal)
# install.packages("NISTunits", dependencies = TRUE)
library(NISTunits)
library(stringr)


setwd("F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/daily_sum_II_Method")
source("Z:/_SHARED_FOLDERS/Air Quality/Phase 2/DUST SEVIRI/R_scripts/extract_pnt_raster.R")


# load location of airport in the UAE

sites_Airports_UAE <- read.csv("F:/Historical_DUST/Airport_Locations_UAE.csv")



#############################################################################################
# read SUM of DAILY DUST EVENTS from STACKED Rasters ########################################
#############################################################################################
## make a function that reads each station at each time and extract points ##################
##############################################################################################


#################################################
#### II Method Met France Original ##############
#################################################

setwd("F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/daily_sum_II_Method")
filenames <- list.files(pattern = ".tif$")

# read rasters of the DAILY SUM of DUST EVENTS with SEVIRI data (II method)

i <- 7
# filenames <- filenames[i]

extracted_SUM_DUST <- NULL
DateTime_DUST <- NULL
site_DUST <- NULL

for (i in 1:length(filenames)) {

year <- str_sub(filenames[i], start= 1, end=-35)
month <- str_sub(filenames[i], start= 5, end=-33)
day <- str_sub(filenames[i], start= 7, end=-31)
DATE <- paste0(year,"-", month, "-", day)
TS <- as.Date(DATE)
class(TS)


 SUM_DAILY_DUST_raster <- raster(filenames[i])
 plot(SUM_DAILY_DUST_raster)

  EXTRACTED_DUST <- extract_points(SUM_DAILY_DUST_raster, sites_Airports_UAE)
  extracted_SUM_DUST = rbind(extracted_SUM_DUST, EXTRACTED_DUST)    
  DATETIME_DUST <- as.data.frame(rep(TS, nrow(sites_Airports_UAE)))           
  DateTime_DUST <- rbind(DateTime_DUST, DATETIME_DUST)
  SITE_DUST <- as.data.frame(sites_Airports_UAE$Site)
  site_DUST <- rbind(site_DUST, SITE_DUST)
  
 }

extracted_SUM_DUST <- cbind(DateTime_DUST, extracted_SUM_DUST, site_DUST)
colnames(extracted_SUM_DUST) <- c("DateTime", "SUM_DAILY_DUST", "station")


# save data-------------------------------------
write.csv(extracted_SUM_DUST, "F:/Historical_DUST/extracted_SUM_DAILY_DUST_UAE_Airports_II_Method.csv")
extracted_SUM_DUST <- read.csv("F:/Historical_DUST/extracted_SUM_DAILY_DUST_UAE_Airports_II_Method.csv")

##########################################################################################################
##########################################################################################################

#################################################
#### I Method ###################################
#################################################

# read rasters of the DAILY SUM of DUST EVENTS with SEVIRI data (I method)

setwd("F:/Historical_DUST/SEVIRI_DUST_MASK_outputs/daily_sum_I_Method")
filenames <- list.files(pattern = ".tif$")

i <- 7
# filenames <- filenames[i]

extracted_SUM_DUST <- NULL
DateTime_DUST <- NULL
site_DUST <- NULL

for (i in 1:length(filenames)) {
  
  year <- str_sub(filenames[i], start= 1, end=-22)
  month <- str_sub(filenames[i], start= 5, end=-20)
  day <- str_sub(filenames[i], start= 7, end=-18)
  DATE <- paste0(year,"-", month, "-", day)
  TS <- as.Date(DATE)
  class(TS)
  
  
  SUM_DAILY_DUST_raster <- raster(filenames[i])
  plot(SUM_DAILY_DUST_raster)
  
  EXTRACTED_DUST <- extract_points(SUM_DAILY_DUST_raster, sites_Airports_UAE)
  extracted_SUM_DUST = rbind(extracted_SUM_DUST, EXTRACTED_DUST)    
  DATETIME_DUST <- as.data.frame(rep(TS, nrow(sites_Airports_UAE)))           
  DateTime_DUST <- rbind(DateTime_DUST, DATETIME_DUST)
  SITE_DUST <- as.data.frame(sites_Airports_UAE$Site)
  site_DUST <- rbind(site_DUST, SITE_DUST)
  
}

extracted_SUM_DUST <- cbind(DateTime_DUST, extracted_SUM_DUST, site_DUST)
colnames(extracted_SUM_DUST) <- c("DateTime", "SUM_DAILY_DUST", "station")


# save data-------------------------------------
write.csv(extracted_SUM_DUST, "F:/Historical_DUST/extracted_SUM_DAILY_DUST_UAE_Airports_I_Method.csv")
extracted_SUM_DUST <- read.csv("F:/Historical_DUST/extracted_SUM_DAILY_DUST_UAE_Airports_I_Method.csv")

#######################
#### End of data extraction

####################################################################################################
####################################################################################################

############################################
####### time -series #######################
############################################

library(ggplot2)
library(scales)


extracted_SUM_DUST_I_Method <- read.csv("F:/Historical_DUST/extracted_SUM_DAILY_DUST_UAE_Airports_I_Method.csv")
extracted_SUM_DUST_II_Method <- read.csv("F:/Historical_DUST/extracted_SUM_DAILY_DUST_UAE_Airports_II_Method.csv")
names(extracted_SUM_DUST_I_Method)[names(extracted_SUM_DUST_I_Method) == 'SUM_DAILY_DUST'] <- 'SUM_DAILY_DUST_I_meth'
names(extracted_SUM_DUST_II_Method)[names(extracted_SUM_DUST_II_Method) == 'SUM_DAILY_DUST'] <- 'SUM_DAILY_DUST_II_meth'

str(extracted_SUM_DUST_I_Method)
str(extracted_SUM_DUST_II_Method)

extracted_SUM_DUST_I_Method$DateTime <- ymd(extracted_SUM_DUST_I_Method$DateTime)
extracted_SUM_DUST_II_Method$DateTime <- ymd(extracted_SUM_DUST_II_Method$DateTime)


##### I method ######################################################
# normalize according to the number of maximum scenes
# calculate number of hours with dust events

extracted_SUM_DUST_I_Method_old <- extracted_SUM_DUST_I_Method %>%
  filter(DateTime >=  "2004-03-18" & DateTime <= "2011-06-30") %>%
#  mutate(SUM_DAILY_DUST_I_meth = (SUM_DAILY_DUST_I_meth/63)*100)
  mutate(SUM_DAILY_DUST_I_meth = (SUM_DAILY_DUST_I_meth*(64/4)))


extracted_SUM_DUST_I_Method_recent <- extracted_SUM_DUST_I_Method %>%
  filter(DateTime >=  "2011-06-30") %>%
#  mutate(SUM_DAILY_DUST_I_meth = (SUM_DAILY_DUST_I_meth/96)*100) %>% 
mutate(SUM_DAILY_DUST_I_meth = (SUM_DAILY_DUST_I_meth*(96/4)))


extracted_SUM_DUST_I_Method <- rbind(extracted_SUM_DUST_I_Method_old,
                                     extracted_SUM_DUST_I_Method_recent)



##### II method MeteoFrance #################################################
# normalize according to the number of maximum scenes
# calculate number of hours with dust events

extracted_SUM_DUST_II_Method_old <- extracted_SUM_DUST_II_Method %>%
  filter(DateTime >=  "2004-03-18" & DateTime <= "2011-06-30") %>%
  #  mutate(SUM_DAILY_DUST_II_meth = (SUM_DAILY_DUST_II_meth/63)*100)
  mutate(SUM_DAILY_DUST_II_meth = (SUM_DAILY_DUST_II_meth*(64/4)))


extracted_SUM_DUST_II_Method_recent <- extracted_SUM_DUST_II_Method %>%
  filter(DateTime >=  "2011-06-30") %>%
  #  mutate(SUM_DAILY_DUST_I_meth = (SUM_DAILY_DUST_I_meth/96)*100) %>% 
  mutate(SUM_DAILY_DUST_II_meth = (SUM_DAILY_DUST_II_meth*(96/4)))


extracted_SUM_DUST_II_Method <- rbind(extracted_SUM_DUST_II_Method_old,
                                     extracted_SUM_DUST_II_Method_recent)


head(extracted_SUM_DUST_I_Method)
head(extracted_SUM_DUST_II_Method)


extracted_SUM_DUST_I_Method$DateTime <- as.POSIXct(extracted_SUM_DUST_I_Method$DateTime)
extracted_SUM_DUST_II_Method$DateTime <- as.POSIXct(extracted_SUM_DUST_II_Method$DateTime)


all_DUST_SUM <- extracted_SUM_DUST_I_Method %>%
  left_join(extracted_SUM_DUST_II_Method, by = c("DateTime", "station"))


# remove some stations with poor data
all_DUST_SUM <- all_DUST_SUM %>%
  filter(!station %in% c("DELMA", "DUBAI", "ZIRKU",
                         "ASH SHARIQAH SW", "RAS-AL-KHAIMA","SIR ABU NAIR"))



plot <- ggplot(all_DUST_SUM, aes(DateTime, SUM_DAILY_DUST_I_meth)) +
  theme_bw() +
  geom_line(aes(y = SUM_DAILY_DUST_II_meth, col = "SUM_DAILY_DUST_II_meth"), alpha=1, col="red") +
  geom_line(aes(y = SUM_DAILY_DUST_I_meth, col = "SUM_DAILY_DUST_I_meth"), alpha=1, col="blue") +
  scale_color_discrete(name = "Y series", labels = c("SUM_DAILY_DUST_II_meth", "SUM_DAILY_DUST_I_meth")) +
 # stat_smooth(method = "loess") +
  facet_wrap(~ station) +
  theme(strip.text = element_text(size = 12)) + 
  ylab(expression(paste("Duration of Dust (hours)"))) +
  theme(axis.title.x=element_blank(),
        axis.text.x  = element_text(angle=90, vjust=0.5, hjust = 0.5, size=10, colour = "black", face="bold")) +
  theme(axis.title.y = element_text(face="bold", colour="black", size=15),
        axis.text.y  = element_text(angle=0, vjust=0.5, size=10, colour = "black")) +
  scale_x_datetime(breaks = date_breaks("1 year"), labels = date_format("%Y"))
#  ylim(0, 100)
plot


#### save plot ###############################################################
##############################################################################

output_folder <- "F:/Historical_DUST/plots/"


png(paste0(output_folder,"Hours_of_dust_comparisons_methodologies.png"), width = 2000, height = 1000,
    units = "px", pointsize = 50,
    bg = "white", res = 200)
print(plot)
dev.off()


###################################################################################################

# plot only results from I method ###

plot <- ggplot(all_DUST_SUM, aes(DateTime, SUM_DAILY_DUST_I_meth)) +
  theme_bw() +
  geom_line(aes(y = SUM_DAILY_DUST_II_meth, col = "SUM_DAILY_DUST_II_meth"), alpha=1, col="black") +
#  geom_line(aes(y = SUM_DAILY_DUST_I_meth, col = "SUM_DAILY_DUST_I_meth"), alpha=1, col="blue") +
  scale_color_discrete(name = "Y series", labels = c("SUM_DAILY_DUST_II_meth", "SUM_DAILY_DUST_I_meth")) +
  # stat_smooth(method = "loess") +
  facet_wrap(~ station) +
  theme(strip.text = element_text(size = 12)) + 
  ylab(expression(paste("Duration of Dust (hours)"))) +
  theme(axis.title.x=element_blank(),
        axis.text.x  = element_text(angle=90, vjust=0.5, hjust = 0.5, size=8, colour = "black", face="bold")) +
  theme(axis.title.y = element_text(face="bold", colour="black", size=15),
        axis.text.y  = element_text(angle=0, vjust=0.5, size=10, colour = "black")) +
  scale_x_datetime(breaks = date_breaks("1 year"), labels = date_format("%Y"))
#  ylim(0, 100)
plot


##################
# save plot ######
##################

output_folder <- "F:/Historical_DUST/plots/"

png(paste0(output_folder,"Hours_of_dust_I_Method.png"), width = 2000, height = 1000,
    units = "px", pointsize = 50,
    bg = "white", res = 200)
print(plot)
dev.off()






plot <- ggplot(all_DUST_SUM, aes(x=SUM_DAILY_DUST_I_meth)) +
  theme_bw() +
  geom_histogram(binwidth=.005, colour="black", fill="white") +
  facet_wrap(~ station) +
  theme(strip.text = element_text(size = 12)) + 
  ylab(expression(paste("Duration of Dust (hours)"))) +
  xlab(expression(paste("Date"))) +
  theme(axis.title.x=element_blank(),
        axis.text.x  = element_text(angle=0, vjust=0.5, hjust = 0.5, size=10, colour = "black", face="bold")) +
  theme(axis.title.y = element_text(face="bold", colour="black", size=15),
        axis.text.y  = element_text(angle=0, vjust=0.5, size=10, colour = "black")) +
  geom_vline(aes(xintercept=0),  
             color="red", linetype="dashed", size=0.5)
plot



plot <- ggplot(all_DUST_SUM, aes(DateTime, SUM_DAILY_DUST_I_meth)) +
  theme_bw() +
  geom_bar(stat="identity") +
  facet_wrap(~ station) +
  theme(strip.text = element_text(size = 12)) + 
  ylab(expression(paste("Duration of Dust (hours)"))) +
  theme(axis.title.x=element_blank(),
        axis.text.x  = element_text(angle=90, vjust=0.5, hjust = 0.5, size=10, colour = "black", face="bold")) +
  theme(axis.title.y = element_text(face="bold", colour="black", size=12),
        axis.text.y  = element_text(angle=0, vjust=0.5, size=10, colour = "black")) +
  ylim(-0.5, 0.5)
plot


#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################
#################################################################################################





















# add 4 hours to WRF(UTC) DateTime ##############################################

str(extracted_WRF_Temp)

extracted_WRF_Temp <- extracted_WRF_Temp %>%
  mutate(DateTime = ymd_hms(DateTime))

str(extracted_WRF_Temp)

extracted_WRF_Temp <- extracted_WRF_Temp %>%
  mutate(DateTime = DateTime + 14400)

######################################################################################################
######################################################################################################

######################################################################################################
######################################################################################################

# merge extracted WRF-data with AQ data--------------------------------------------

str(All_AWS_data)


All_AWS_data <- All_AWS_data %>%
  merge(extracted_WRF_Temp, by = c("station", "DateTime"))


write.csv(All_AWS_data, "Z:/_SHARED_FOLDERS/Air Quality/Phase 2/Dust_Event_UAE_2015/AWS_2015 WEATHER/dust_event_outputs/AWS_WRFChem_Temp_Data_2015_4km.csv")

################################################################################
################################################################################

######## PLOT Time Series and correlations #####################################

library(dplyr)
library(readr)
library(lubridate)
library(ggplot2)
library(tidyr)
library(splines)
library(plyr)

# setwd("D:/Dust_Event_UAE_2015/AWS_2015 WEATHER/dust_event_outputs")
setwd("Z:/_SHARED_FOLDERS/Air Quality/Phase 2/Dust_Event_UAE_2015/AWS_2015 WEATHER/dust_event_outputs")

AWS_WRF_2015_Temp <- read.csv("AWS_WRFChem_Temp_Data_2015_4km.csv")

AWS_WRF_2015_Temp <- AWS_WRF_2015_Temp %>%
  mutate(DateTime = ymd_hms(DateTime))

str(AWS_WRF_2015_Temp)


AWS_WRF_2015_Temp_selected_Sites <- AWS_WRF_2015_Temp %>%
  filter(station %in% c("Al Faqa", "Madinat Zayed", "Hatta",
                        "Al Ain","Alkhazna", "Rezeen", "Abu Dhabi", "Al Dhaid"))

AWS_WRF_2015_Temp_selected_Sites <- AWS_WRF_2015_Temp %>%
  filter(station %in% c("Al Ain", "Umm Al Quwain","Al Faqa", 
                        "Madinat Zayed", "Abu Dhabi", "Mezaira"))


# change site names....into ANONIMIZED site names
# levels(AWS_WRF_2015_Temp_selected_Sites$station) <- gsub("^Al Dhaid$","I", levels(AWS_WRF_2015_Temp_selected_Sites$station))
# levels(AWS_WRF_2015_Temp_selected_Sites$station) <- gsub("^Al Faqa$","II", levels(AWS_WRF_2015_Temp_selected_Sites$station))
# levels(AWS_WRF_2015_Temp_selected_Sites$station) <- gsub("^Alkhazna$","III", levels(AWS_WRF_2015_Temp_selected_Sites$station))
# levels(AWS_WRF_2015_Temp_selected_Sites$station) <- gsub("^Hatta$","IV", levels(AWS_WRF_2015_Temp_selected_Sites$station))
# levels(AWS_WRF_2015_Temp_selected_Sites$station) <- gsub("^Madinat Zayed$","V", levels(AWS_WRF_2015_Temp_selected_Sites$station))
# levels(AWS_WRF_2015_Temp_selected_Sites$station) <- gsub("^Rezeen$","VI", levels(AWS_WRF_2015_Temp_selected_Sites$station))



###################################################################################################################
######### plot TIME-SERIES of AWS NCMS data data and WRF Temperature data #########################################
###################################################################################################################

jpeg('Z:/_SHARED_FOLDERS/Air Quality/Phase 2/Dust_Event_UAE_2015/AWS_2015 WEATHER/dust_event_outputs/NCMS_WRF_TEMPERATURE_TimeSeries_4km.jpg',
     quality = 100, bg = "white", res = 300, width = 18, height = 9, units = "in")
par(mar=c(4, 10, 9, 2) + 0.3)
oldpar <- par(las=1)


plot <- ggplot(AWS_WRF_2015_Temp, aes(DateTime, T_dry)) + 
  theme_bw() +
  geom_line(aes(y = T_dry, col = "T_dry"), alpha=1, col="red") +
  geom_line(aes(y = WRF_CHEM_Temp, col = "WRF_CHEM_Temp"), alpha=1, col="blue") +
  facet_wrap( ~ station) +
  theme(legend.position="none") + 
  theme(strip.text = element_text(size = 10)) + 
  ylab(expression(paste("Dry Temperature ", " (", ~degree~C, ")"))) +
  theme(axis.title.x=element_blank(),
        axis.text.x  = element_text(angle=0, vjust=0.5, hjust = 0.5, size=9, colour = "black", face="bold")) +
  theme(axis.title.y = element_text(face="bold", colour="black", size=13),
        axis.text.y  = element_text(angle=0, vjust=0.5, size=7, colour = "black")) +
  ylim(7, 45)  
plot


par(oldpar)
dev.off()

################################################

jpeg('Z:/_SHARED_FOLDERS/Air Quality/Phase 2/Dust_Event_UAE_2015/AWS_2015 WEATHER/dust_event_outputs/NCMS_WRF_TEMPERATURE_TimeSeries_selected_4km.jpg',
     quality = 100, bg = "white", res = 300, width = 18, height = 9, units = "in")
par(mar=c(4, 10, 9, 2) + 0.3)
oldpar <- par(las=1)


min <- as.POSIXct("2015-03-31 00:00:00") 
max <- as.POSIXct("2015-04-04 11:00:00") 

plot <- ggplot(AWS_WRF_2015_Temp_selected_Sites, aes(DateTime, T_dry)) + 
  theme_bw() +
  geom_line(aes(y = T_dry, col = "T_dry"), alpha=1, col="red", size =1) +
  geom_line(aes(y = WRF_CHEM_Temp, col = "WRF_CHEM_Temp"), alpha=1, col="blue", size =1) +
  facet_wrap( ~ station, ncol=2) +
  theme(legend.position="none") + 
  theme(strip.text = element_text(size = 30)) + 
  ylab(expression(paste("Temperature ", "(",~degree~C, ")"))) +
  theme(axis.title.x=element_blank(),
        axis.text.x  = element_text(angle=0, vjust=0.5, hjust = 0.5, size=28, colour = "black", face="bold")) +
  theme(axis.title.y = element_text(face="bold", colour="black", size=28),
        axis.text.y  = element_text(angle=0, vjust=0.5, size=28, colour = "black")) +
  ylim(7, 45)  +
  xlim(min, max) 
plot


par(oldpar)
dev.off()

######## STATISTICS #####################################################
####### equation ########################################################

# linear regression equation 

lm_eqn = function(m) {
  
  l <- list(a = format(coef(m)[1], digits = 2),
            b = format(abs(coef(m)[2]), digits = 2),
            r2 = format(summary(m)$r.squared, digits = 3));
  
  if (coef(m)[2] >= 0)  {
    eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2,l)
  } else {
    eq <- substitute(italic(y) == a - b %.% italic(x)*","~~italic(r)^2~"="~r2,l)    
  }
  
  as.character(as.expression(eq));                 
}


# plot correlation + statistics

plot <- ggplot(AWS_WRF_2015_Temp_selected_Sites, aes(x=WRF_CHEM_Temp, y=T_dry)) +
  theme_bw() +
  geom_point(size = 2.5, color='black') +    # Use hollow circles
  geom_smooth(method=lm) +  # Add linear regression line 
  ylab(expression(paste("Temperature ", " (",degree~C,") measurements"))) +
  xlab(expression(paste("Temperature ", " (",degree~C,") WRF-Chem"))) +
  ylim(c(15, 42)) + 
  xlim(c(15, 42)) +
  theme(axis.title.y = element_text(face="bold", colour="black", size=25),
        axis.text.y  = element_text(angle=0, vjust=0.5, size=23)) +
  theme(axis.title.x = element_text(face="bold", colour="black", size=25),
        axis.text.x  = element_text(angle=0, vjust=0.5, size=23)) +
  geom_text(aes(x = 33, y = 17, label = lm_eqn(lm(T_dry ~ WRF_CHEM_Temp, AWS_WRF_2015_Temp_selected_Sites))),
            size = 9,
            color = "red",
            parse = TRUE)
plot

# save plot
output_folder <- "Z:/_SHARED_FOLDERS/Air Quality/Phase 2/Dust_Event_UAE_2015/AWS_2015 WEATHER/dust_event_outputs/"

png(paste0(output_folder,"Temp_NCS_WRF_correlation_selected_sites.jpg"),
    width = 1200, height = 1050, units = "px", pointsize = 30,
    bg = "white", res = 150)
print(plot)
dev.off()



# summary STATISTICS ########3

fit <- lm(T_dry ~ WRF_CHEM_Temp,
          data = AWS_WRF_2015_Temp_selected_Sites)
summary(fit) # show results
signif(summary(fit)$r.squared, 5) ### R2



###################################################################################################################
###################################################################################################################
###################################################################################################################
###################################################################################################################
################### OLD STUFF ##############################################################
###################################################################################################################
###################################################################################################################

#### fit function and label for NCMS TEMPERATURE and WRF-CHEM data  ########################
#### this funtion FORCE regression to pass through the origin ###################

lm_eqn <- function(df){
  m <- lm(T_dry ~ -1 + WRF_CHEM_Temp, df);
  eq <- substitute(italic(y) == b %.% italic(x)*","~~italic(r)^2~"="~r2,
                   list(b = format(coef(m)[1], digits = 2),
                        r2 = format(summary(m)$r.squared, digits = 3)))
  as.character(as.expression(eq));
}


## this function includes the intercept~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# lm_eqn <- function(df){
#   m <- lm(Value ~  WRF_CHEM, df);
#   eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2,
#                    list(a = format(coef(m)[2], digits = 2),
#                         b = format(coef(m)[1], digits = 2),
#                         r2 = format(summary(m)$r.squared, digits = 3)))
#   as.character(as.expression(eq));
# }


################### PM10 versus WRF-chem Dust #############################


# plot with regression line-----

jpeg('Z:/_SHARED_FOLDERS/Air Quality/Phase 2/Dust_Event_UAE_2015/AWS_2015 WEATHER/dust_event_outputs/Temp_vs_WRF.jpg',    
     quality = 100, bg = "white", res = 200, width = 18, height = 9, units = "in")
par(mar=c(4, 10, 9, 2) + 0.3)
oldpar <- par(las=1)


# define regression equation for each season
 eq_Temp <- ddply(AWS_WRF_2015_Temp, .(station),lm_eqn)


# ggplot(PM25_AOD, aes(x=Val_AOD, y=Val_PM25, color = season)) +
ggplot(AWS_WRF_2015_Temp, aes(x=WRF_CHEM_Temp, y=T_dry)) +
  theme_bw() +
  # geom_point(size = 2) +
  geom_jitter(colour=alpha("black",0.15) ) +
  facet_wrap( ~ station, ncol=4) +
  theme(strip.text = element_text(size = 8)) + 
  scale_color_manual(values = c("#ff0000", "#0000ff", "#000000", "#ffb732")) + 
#  geom_smooth(method="lm") +  # Add linear regression line
  geom_smooth(method = "lm", formula = y ~ -1 + x) +  # force fit through the origin
  ylab(expression(paste("Dry Temperature ", " (", ~degree~C, ") measurements"))) +
  xlab(expression(paste("Dry Temperature ", " (", ~degree~C, ") WRF-Chem"))) +
  ylim(c(10, 42)) + 
  xlim(c(10, 42)) +
  theme(axis.title.y = element_text(face="bold", colour="black", size=12),
        axis.text.y  = element_text(angle=0, vjust=0.5, size=8)) +
  theme(axis.title.x = element_text(face="bold", colour="black", size=12),
        axis.text.x  = element_text(angle=0, vjust=0.5, size=10)) +
  
  geom_text(data = eq_Temp, aes(x = 35, y = 28, label = V1),
            parse = TRUE, inherit.aes=FALSE, size = 3, color = "black" )



par(oldpar)
dev.off()



