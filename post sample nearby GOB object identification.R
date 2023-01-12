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

# Refugees, example sample of 3000 on OBJECTID
gob.en <- readr::read_csv("SSD Unity Upper Nile Google Open Buildings enhanced.csv",T)
ref.en <- subset(gob_en, gob_en$inside_per!="outside")
refsam <- sample(ref_en$OBJECTID,3000,replace=F)



# For each location in sample, find and label 


# Host communities, example sample of 3000 on OBJECTID