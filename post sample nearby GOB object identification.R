# Enhancing the Google Open Buildings layer for South Sudan for host community and refugee sampling for the UNHCR Forced Displacement Survey

setwd("C:/Users/BROCK/OneDrive - UNHCR/Documents/South Sudan Scoping/SSD-Building-Distance")
library(lubridate)
library(sf)
library(tidyr)
library(tmap)
library(rgeos)
library(dplyr)
library(ggplot2)
library(readr)

# After sample of building objects as proxy households has been drawn, create groups of nearby building objects
# These should be provided to enumerators such that they can identify whether they are associated with households
# This information collected by enumerators should then be used to calculate sample weights

# Refugees, example sample of n on OBJECTID
gob.en. <- readr::read_csv("SSD Unity Upper Nile Google Open Buildings enhanced.csv",T)
gob.en <- st_as_sf(gob.en.,coords=c("longitude","latitude")) %>% 
  st_set_crs(4326) %>%  st_transform(20135) 
ref.en <- subset(gob.en, gob_en$inside_per!="outside")
n <- 3000
refsam <- sample(ref.en$OBJECTID,n,replace=F)
rsm <- match(ref.en$OBJECTID,refsam)
ref.en$sample<-NA
ref.en$sample <- ifelse(is.na(rsm)==T,"no","yes")
table(ref.en$sample)

# For each sampled building object, identify all those that are within threshold.m meters
threshold.m <- 20

# calculate distances

for(i in 1:length(refsam)){
  tds <- subset(ref.en,ref.en$OBJECTID==refsam[i])
  tdmat <- st_distance(tds,ref.en)
}



# Host communities, example sample of 3000 on OBJECTID