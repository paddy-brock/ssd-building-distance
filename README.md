# ssd-building-distance
Enhancing the Google Open Buildings layer for South Sudan for host community and refugee sampling for the UNHCR Forced Displacement Survey

Area: Unity and Upper Nile states

Combine Google Open Buildings data with UNHCR settlement perimeter data to:
- identify building objects (possible housholds) in camps to support refugee sampling
- allow for stratified sampling of building objects by distance to nearest refugee camp

Tags building objects by whether inside or outside of UNHCR settlement perimeters.

Calculates distance of building objects outside perimeters to the nearest perimeter (and tags which is the nearest perimeter).
Assumption: have removed the IDP settlement Bentiu from these calculations, as it is an IDP settlement. NB that some of the building objects in south west Unity are closer to this settlement than to the refugee camps to the north east in Unity identified as their closest matches in theoutput dataset.

Adds a tag for estimated building area to identify very large and small ones for priority visual checking.

## Possible elaborations
Enhanced measure of proxmity of building objects to settlements (e.g. composite index including information on nearest 5 settlements rather than just closest)

Test how useful a proxy the last detection date in the Google Open Buildings data is to priotise visual checking.

Include the WFP road and path data to include distnace to nearest road/path https://data.humdata.org/dataset/south-sudan-road-network

## Next step: quality assuring the enumeration data from the South Sudan National Bureau of Statistics (pending data from NBS)
GRID3 UNFPA layer:
https://data.grid3.org/maps/GRID3::grid3-south-sudan-gridded-population-estimates-version-2-0/about

Use this to compare population density estimates per enumeration area

### GPT3 feedback for making the code more robust, efficient and reproducible
Clearly documenting the code with comments explaining what each section of the code is doing and why.
Use more meaningful variable names that reflect the data they hold.
Use the readr::read_csv() function instead of read.csv() for reading in the csv file, as it is more efficient and can handle large datasets.
Use the sf::st_crs() function to set the Coordinate Reference System (CRS) of the data, rather than hardcoding the CRS in the code.
Use the dplyr::filter() and dplyr::select() function to subset the data rather than subset() function.
Use the tmap_mode("plot") to generate the final maps, rather than tmap_mode("view").
Use the ggplot2::geom_density() instead of ggplot2::geom_histogram() to show the distribution of distance from camp.
Use library(data.table) instead of data.frame() when creating data frame of distance matrix, to make it more efficient.
Use the stringr::str_to_title() function to format the names of the settlement for better readability.
Use the dplyr::group_by() and dplyr::summarize() to calculate the area of buildings.
