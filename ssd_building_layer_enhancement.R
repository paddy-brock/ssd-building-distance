# December 2022 and January 2023

# 1. Enhancing the Google Open Buildings layer for South Sudan
# For host community and refugee sampling for the Forced Displacement Survey

setwd("C:/Users/BROCK/OneDrive - UNHCR/Documents/South Sudan Scoping/SSD-Building-Distance")

library(sf)
library(tidyr)
library(tmap)

# Read in the UNHCR layers for South Sudan including settlement boundaries

# Read in SSD Google Open Buildings layer

# Camp proximity
# Calculate distance of each building to nearest camp (and tag by camp)
# Centroid and nearest edge
 
# Find centroid of polygon

# Measure distance to nearest polygon edge  

# Calculate distance to all other camp centroids
# Calculate a proxy indicator of distance to all camps, e.g. proportion of 1st to 2nd/3rd/4th/5th distance difference of the 1st distance - split into 1/2 and 1/2345


# Calculate other features?
# e.g. building density within buffer
# e.g. distance to nearest path/road, e.g. WFP HDX data
# e.g. distance to service locations, e.g. UNHCR borehole data?




# 2. Quality assuring the enumeration data from the South Sudan National Bureau of Statistics (pending data from NBS)
# For host community sampling for the Forced Displacement Survey

# GRID3 UNFPA layer:
# https://data.grid3.org/maps/GRID3::grid3-south-sudan-gridded-population-estimates-version-2-0/about
# Use this to estimate population density per enumeration area

