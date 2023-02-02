# Enhancing the Google Open Buildings layer for South Sudan for host community and refugee sampling for the UNHCR Forced Displacement Survey - UNITY and UPPER NILE - REFUGEES and HOSTS

# To help understand selection probabilities, create groups/neighborhoods of nearby building objects to those selected in the sample

setwd("C:/Users/BROCK/OneDrive - UNHCR/Documents/South Sudan Scoping/SSD-Building-Distance")
library(lubridate)
library(sf)
library(tidyr)
library(tmap)
library(rgeos)
library(dplyr)
library(ggplot2)
library(readr)
library(ggmap)

gob.en. <- readr::read_csv("SSD Unity Upper Nile Refugees and Hosts Google Open Buildings enhanced.csv",T)

gob.en <- st_as_sf(gob.en.,coords=c("longitude","latitude")) %>% 
  st_set_crs(4326) %>%  st_transform(20135) 

# Refugees, example sample of n on OBJECTID
n <- 3000
ref.en <- subset(gob.en, gob.en$inside_per!="outside")
refsam <- sample(ref.en$OBJECTID,n,replace=F)
rsm <- match(ref.en$OBJECTID,refsam)
ref.en$sample<-NA
ref.en$sample <- ifelse(is.na(rsm)==T,"no","yes")
table(ref.en$sample)

# For each sampled building object inside a refugee camp perimeter, identify all those that are within threshold.m meters also within the perimeter

threshold.m <- 20

i <- 1
  tds <- subset(ref.en,ref.en$OBJECTID==refsam[i])
  tdmat <- st_distance(tds,ref.en)
  neis <- which(as.vector(tdmat)<threshold.m)
  nei <- neis[neis!=which(ref.en$OBJECTID==refsam[i])]
  nbh <- ref.en[c(which(ref.en$OBJECTID==refsam[i]),nei),]
  nbh$sam.nei <- c("sample",rep("neighbour",length(nbh$OBJECTID)-1))
  
# Check
tmap_mode("view")
tm_basemap("OpenStreetMap") +
  tm_shape(nbh)  + tm_dots(col = "sam.nei", palette=rainbow(length(unique(nbh$sam.nei)),alpha=0.5))

tm_basemap("Esri.WorldImagery") +
  tm_shape(nbh)  + tm_dots(col = "sam.nei", palette=rainbow(length(unique(nbh$sam.nei)),alpha=0.5))

# For each sample, output neighbour dataset - best format?

# Host communities, example sample of 3000 on OBJECTID
# Repeat for outside