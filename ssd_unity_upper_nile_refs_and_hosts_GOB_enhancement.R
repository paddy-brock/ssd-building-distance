# Enhancing the Google Open Buildings layer for South Sudan for host community and refugee sampling for the UNHCR Forced Displacement Survey - UNITY and UPPER NILE - REFUGEES and HOSTS

setwd("C:/Users/BROCK/OneDrive - UNHCR/Documents/South Sudan Scoping/SSD-Building-Distance")
library(lubridate)
library(sf)
library(tidyr)
library(tmap)
library(rgeos)
library(dplyr)
library(ggplot2)

# SSD Google Open Buildings data (provided by UNHCR GIS team), re-format
ssd.gob <- read.csv("building layer export.csv",T)[,1:7]
ssd.gob$OBJECTID <- as.factor(ssd.gob$OBJECTID)
ssd.gob$date <- ym(ssd.gob$last_detection_date)

# Remove Magwi and Torit (as these are areas where returnees will be sampled)
ssd.gob2 <- subset(ssd.gob,ssd.gob$latitude>7)
gob <-na.omit(ssd.gob2)

# Project the GOB data as spatial object
sp.gob <- st_as_sf(gob,coords=c("longitude","latitude")) %>% 
  st_set_crs(4326) %>%  st_transform(20135) 

# Check
tmap_mode("view")
 tm_basemap("OpenStreetMap") +
  tm_shape(sp.gob) + tm_dots(col = "black")

# UNHCR camp perimeters, (provided by UNHCR GIS team), project to match Google Open Buildings
per <- st_read("ssd perimeters.shp")
st_crs(per)
sp.per1 <- per %>% st_transform(20135)

# Remove Benitu POC IDP settlement
sp.per <- subset(sp.per1,sp.per1$name!="Bentiu POC")

# Tag buildings as in or out of perimeters (including identifying which when inside)
in.p <- st_join(sp.gob,sp.per)
sp.gob$inside_per <- in.p$name
sp.gob$inside_per <- ifelse((is.na(sp.gob$inside_per)==T), "outside",sp.gob$inside_per)

# Check
table(sp.gob$inside_per)
 tm_basemap("OpenStreetMap") +
  tm_shape(sp.gob) + tm_dots(col = "inside_per", palette=rainbow(length(unique(sp.gob$inside_per)),alpha=0.5))

# For those outside, distance to nearest perimeter, and identify which
sp.gob_out <- subset(sp.gob, is.na(sp.gob$inside_per)==T)
d.mat <- st_distance(sp.gob, sp.per)
data.frame(d.mat[,1],sp.gob$inside_per)
sp_gob_min_d <- NA
sp_gob_min_d_sett <- NA
sett.names <- unique(sp.per$name)

sp.gob$min_d <- apply(d.mat, 1, min)
sp.gob$min_d_sett <- sett.names[apply(d.mat, 1, which.min)]
sp.gob$min_d_sett <- ifelse(sp.gob$inside_per!="outside","inside",sp.gob$min_d_sett)

# Check
tmap_mode("view")
 tm_basemap("OpenStreetMap") +
  tm_shape(sp.gob) + tm_dots(col = "min_d_sett", palette=rainbow(length(unique(sp.gob$min_d_sett)),alpha=0.5))

# Minimum distance distribution of building objects outside refugee settlements
sp.gob %>% filter(min_d > 0) %>%
  ggplot() + geom_histogram(aes(x=min_d), binwidth = 1000, alpha = 0.6, colour = "black") + 
  theme_bw() + xlab("Distance from camp (m)")

# Buildings identified inside these refugee settlements
table(sp.gob$inside_per)

# Buildings outside these found to be nearest to these refugee settlements
table(sp.gob$min_d_sett)

# Estimated building area could be helpful at extremes
sp.gob %>% filter(area_in_meters <100) %>%
ggplot() + geom_histogram(aes(x=area_in_meters), binwidth = 1, alpha = 0.6, colour = "black") + 
  theme_bw() + xlab("Estimates area (m)")

# Suggest tagging those greater than 44 and smaller than 8, not to exclude, but perhaps to prioritize for visual checking, this would highlights approx 0.05 and 0.95 percentiles
q05 <- quantile(sp.gob$area_in_meters, probs = 0.05)[[1]]
q95 <- quantile(sp.gob$area_in_meters, probs = 0.95)[[1]]

sp.gob$building_size_percentile <- NA
sp.gob$building_size_percentile <-  ifelse(sp.gob$area_in_meters < q05, "small",
                                           ifelse(sp.gob$area_in_meters > q95, "large", "medium"))

# Check
par(mfrow=c(1,1))
boxplot(log(sp.gob$area_in_meters)~sp.gob$building_size_percentile)

# Google Buildings confidence measure doesn't look useful in this context, based on some random sample visual inspection, suggest don't filter/prioritize using this
hist(sp.gob$confidence)

# Add admin categories for each building object

ad1 <- st_read("ssd admin 1.shp")
st_crs(ad1)
ad1 <- ad1 %>% st_transform(20135)
in.ad1 <- st_join(sp.gob,ad1)
sp.gob$adm1 <- in.ad1$ADM1_EN

ad2 <- st_read("ssd admin 2.shp")
st_crs(ad2)
ad2 <- ad2 %>% st_transform(20135)
in.ad2 <- st_join(sp.gob,ad2)
sp.gob$adm2 <- in.ad2$ADM2_EN

ad3 <- st_read("ssd admin 3.shp")
st_crs(ad3)
ad3 <- ad3 %>% st_transform(20135)
in.ad3 <- st_join(sp.gob,ad3)
sp.gob$adm3 <- in.ad3$ADM3_EN

# Count the building objects for hosts in Pariang and Maban

table(sp.gob$adm2)
table(subset(sp.gob,sp.gob$inside_per=="outside")$adm2)
table(subset(sp.gob,sp.gob$inside_per!="outside")$adm2)
table(sp.gob$inside_per)

# Prepare for export ... FIX ... columns different
ssd.gob3 <- data.frame("OBJECTID"=ssd.gob$OBJECTID,"latitude"=ssd.gob$latitude,"longitude"=ssd.gob$longitude)
out.ds <- left_join(data.frame(sp.gob), ssd.gob3, by = "OBJECTID")

str(sp.gob)
str(data.frame(sp.gob))
str(ssd.gob3)
names(out.ds)[6] <- "reformatted_date"

# put geometry at end
out.d <- out.ds[, c(1:6,8:16,7)]
str(out.d)

# Export
write.csv(out.d,"SSD Unity Upper Nile Refugees and Hosts Google Open Buildings enhanced.csv",row.names=F)
