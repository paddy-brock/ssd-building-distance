# Enhancing the Google Open Buildings layer for South Sudan for host community and refugee sampling for the UNHCR Forced Displacement Survey

setwd("C:/Users/BROCK/OneDrive - UNHCR/Documents/South Sudan Scoping/SSD-Building-Distance")
library(lubridate)
library(sf)
library(tidyr)
library(tmap)
library(rgeos)
library(dplyr)
library(ggplot2)

# Quality assuring the enumeration data from the South Sudan National Bureau of Statistics (pending data from NBS) GRID3 UNFPA layer
# https://data.grid3.org/maps/GRID3::grid3-south-sudan-gridded-population-estimates-version-2-0/about

# Use this to compare population density estimates per enumeration area