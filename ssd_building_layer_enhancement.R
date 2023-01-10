# Enhancing the Google Open Buildings layer for South Sudan for host community and refugee sampling for the UNHCR Forced Displacement Survey

setwd("C:/Users/BROCK/OneDrive - UNHCR/Documents/South Sudan Scoping/SSD-Building-Distance")
library(lubridate)
library('sf')
library('tidyr')
library(tmap)
library(rgeos)

# Read in SSD Google Open Buildings layer, Re-format (inc, removing Torit and Magwi)
ssd_gob <- read.csv("building layer export.csv",T)[,1:7]
ssd_gob$OBJECTID <- as.factor(ssd_gob$OBJECTID)
ssd_gob$date <- ym(ssd_gob$last_detection_date)
ssd_gob2 <- subset(ssd_gob,ssd_gob$latitude>7)
gob <-na.omit(ssd_gob2)

# Project the GOB layer and make spatial object
sp_gob <- st_as_sf(gob,coords=c("longitude","latitude")) %>% 
  st_set_crs(4326) %>%  st_transform(20135) 

# check
tmap_mode("view")
 tm_basemap("OpenStreetMap") +
  tm_shape(sp_gob) + tm_dots(col = "black")

# UNHCR camp boundaries, re-project to match Google Open Buildings
per <- st_read("ssd perimeters.shp")
st_crs(per)
sp_per <- per %>% st_transform(20135) 

# Tag building points and in/out of perimeters (including names when inside)
in.p <- st_join(sp_gob,sp_per)
sp_gob$inside.per <- in.p$name
sp_gob$inside.per <- ifelse((is.na(sp_gob$inside.per)==T), "outside",sp_gob$inside.per)

# check
table(sp_gob$inside.per)
 tm_basemap("OpenStreetMap") +
  tm_shape(sp_gob) + tm_dots(col = "inside.per", palette=rainbow(length(unique(sp_gob$inside.per)),alpha=0.5))

# For those outside, distance to nearest perimeter
sp_gob_out <- subset(sp_gob, is.na(sp_gob$inside.per)==T)
d.mat <- st_distance(sp_gob, sp_per)
data.frame(d.mat[,1],sp_gob$inside.per)
sp_gob_min_d <- NA
sp_gob_min_d_sett <- NA
sett.names <- unique(sp_per$name)

for (i in 1:length(d.mat[,1])){
  sp_gob$min_d[i] <- min(d.mat[i,])
  sp_gob$min_d_sett[i] <- sett.names[which(d.mat[i,]==min(d.mat[i,]))]
}

# check
tmap_mode("view")
 tm_basemap("OpenStreetMap") +
  tm_shape(sp_gob) + tm_dots(col = "min_d_sett", palette=rainbow(length(unique(sp_gob$min_d_sett)),alpha=0.5))
 


# st_nearest...
# st_nearest_feature() - test this with point inside polygon to see if get negative distance
# if this doesn'


# Camp proximity
# Calculate distance of each building to nearest camp (and tag by camp)
# Centroid and nearest edge
 
# Find centroid of polygon (sf... st_centroid)

# Measure distance to nearest polygon edge  (sf st_nearest or st_distance)

# Calculate distance to all other camp centroids
# Calculate a proxy indicator of distance to all camps, e.g. proportion of 1st to 2nd/3rd/4th/5th distance difference of the 1st distance - split into 1/2 and 1/2345


# Calculate other features?
# e.g. building density within buffer
# e.g. distance to nearest path/road, e.g. WFP HDX data
# e.g. distance to service locations, e.g. UNHCR borehole data?

# Final processing: add a flag using any of these features that could reliable be used (based on testing data) to exclude buildings from sample set

####
####
####

# Quality assuring the enumeration data from the South Sudan National Bureau of Statistics (pending data from NBS)
# For host community sampling for the Forced Displacement Survey

# GRID3 UNFPA layer:
# https://data.grid3.org/maps/GRID3::grid3-south-sudan-gridded-population-estimates-version-2-0/about
# Use this to estimate population density per enumeration area

