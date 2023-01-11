# Enhancing the Google Open Buildings layer for South Sudan for host community and refugee sampling for the UNHCR Forced Displacement Survey

setwd("C:/Users/BROCK/OneDrive - UNHCR/Documents/South Sudan Scoping/SSD-Building-Distance")
library(lubridate)
library(sf)
library(tidyr)
library(tmap)
library(rgeos)
library(dplyr)

# SSD Google Open Buildings data (provided by UNHCR GIS team), re-format
ssd_gob <- read.csv("building layer export.csv",T)[,1:7]
ssd_gob$OBJECTID <- as.factor(ssd_gob$OBJECTID)
ssd_gob$date <- ym(ssd_gob$last_detection_date)

# Remove Magwi and Torit (as these are areas where returnees will be sampled)
ssd_gob2 <- subset(ssd_gob,ssd_gob$latitude>7)
gob <-na.omit(ssd_gob2)

# Project the GOB data as spatial object
sp_gob <- st_as_sf(gob,coords=c("longitude","latitude")) %>% 
  st_set_crs(4326) %>%  st_transform(20135) 

# Check
#tmap_mode("view")
# tm_basemap("OpenStreetMap") +
#  tm_shape(sp_gob) + tm_dots(col = "black")

# UNHCR camp perimeters, project to match Google Open Buildings
per <- st_read("ssd perimeters.shp")
st_crs(per)
sp_per1 <- per %>% st_transform(20135)

# Remove Benitu POC IDP settlement
sp_per <- subset(sp_per1,sp_per1$name!="Bentiu POC")

# Tag buildings as in or out of perimeters (including identifying which when inside)
in.p <- st_join(sp_gob,sp_per)
sp_gob$inside_per <- in.p$name
sp_gob$inside_per <- ifelse((is.na(sp_gob$inside_per)==T), "outside",sp_gob$inside_per)

# Check
table(sp_gob$inside_per)
# tm_basemap("OpenStreetMap") +
#  tm_shape(sp_gob) + tm_dots(col = "inside_per", palette=rainbow(length(unique(sp_gob$inside_per)),alpha=0.5))

# For those outside, distance to nearest perimeter, and identify which
sp_gob_out <- subset(sp_gob, is.na(sp_gob$inside_per)==T)
d.mat <- st_distance(sp_gob, sp_per)
data.frame(d.mat[,1],sp_gob$inside_per)
sp_gob_min_d <- NA
sp_gob_min_d_sett <- NA
sett.names <- unique(sp_per$name)

for (i in 1:length(d.mat[,1])){
  sp_gob$min_d[i] <- min(d.mat[i,])
  sp_gob$min_d_sett[i] <- sett.names[which(d.mat[i,]==min(d.mat[i,]))]
}

# Check
#tmap_mode("view")
# tm_basemap("OpenStreetMap") +
#  tm_shape(sp_gob) + tm_dots(col = "min_d_sett", palette=rainbow(length(unique(sp_gob$min_d_sett)),alpha=0.5))

# Minimum distance distribution
par(mfrow=c(2,2))
hist(sp_gob$min_d,main ="All",xlab="dist to nearest refugee settlement (m)")
hist(subset(sp_gob,sp_gob$min_d>0)$min_d,main=">0m",xlab="dist to nearest refugee settlement (m)")
hist(subset(sp_gob,sp_gob$min_d>1000)$min_d,main=">1000m",xlab="dist to nearest refugee settlement (m)") 
hist(subset(sp_gob,sp_gob$min_d>10000)$min_d,main=">10000m",xlab="dist to nearest refugee settlement (m)") 

# Buildings identified inside these refugee settlements
table(sp_gob$inside_per)

# Buildings outside these found to be nearest to these refugee settlements
table(sp_gob$min_d_sett)

# Estimated building area could be helpful at extremes
par(mfrow=c(2,2))
hist(sp_gob$area_in_meters,main ="All",xlab="Area (m)")
hist(subset(sp_gob,sp_gob$area_in_meters<1000)$area_in_meters,main ="<1000",xlab="Area (m)")
hist(subset(sp_gob,sp_gob$area_in_meters<100)$area_in_meters,main ="<100",xlab="Area (m)")
hist(subset(sp_gob,sp_gob$area_in_meters<50)$area_in_meters,main ="<50",xlab="Area (m)")

# Suggest tagging those greater than 44 and smaller than 8, not to exclude, but perhaps to prioritize for visual checking, this would highlights approx 0.05 and 0.95 percentiles
q05 <- quantile(sp_gob$area_in_meters, probs = 0.05)[[1]]
q95 <- quantile(sp_gob$area_in_meters, probs = 0.95)[[1]]

sp_gob$building_size_percentile <- NA

for(i in 1:length(sp_gob$area_in_meters)){
  sp_gob$building_size_percentile[i] <-   ifelse(sp_gob$area_in_meters[i]<q05, "small",
                                                 ifelse(sp_gob$area_in_meters[i]>q95, "large", "medium"))
}

# Check
par(mfrow=c(1,1))
boxplot(log(sp_gob$area_in_meters)~sp_gob$building_size_percentile)

# Google Buildings confidence measure doesn't look useful in this context, based on some random sample visual inspection, suggest don't filter/prioritize using this
hist(sp_gob$confidence)

# Prepare for export
ssd_gob3 <- data.frame("OBJECTID"=ssd_gob$OBJECTID,"latitude"=ssd_gob$latitude,"longitude"=ssd_gob$longitude)
out.ds <- left_join(data.frame(sp_gob), ssd_gob3, by = "OBJECTID")

str(sp_gob)
str(data.frame(sp_gob))
str(ssd_gob3)
names(out.ds)[6] <- "reformatted_date"

# move geometry to last
out.d <- out.ds[, c(1:6,8:13,7)]
str(out.d)

# Export
write.csv(out.d,"SSD Unity Upper Nile Google Open Buildings enhanced.csv",row.names=F)