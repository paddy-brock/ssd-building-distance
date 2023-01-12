# ssd-building-distance
Enhancing the Google Open Buildings layer for South Sudan for host community and refugee sampling for the UNHCR Forced Displacement Survey

Combine Google Open Buildings data with UNHCR settlement perimeter data to:
- identify building objects (possible households) in camps to support refugee sampling
- allow for stratified sampling of building objects by distance to nearest refugee camp

Area: Unity and Upper Nile states

Tags building objects by whether inside or outside of UNHCR settlement perimeters.

Calculates distance of building objects outside perimeters to the nearest perimeter (and tags which is the nearest perimeter).
Assumption: have removed the IDP settlement Bentiu from these calculations, as it is an IDP settlement. NB that some of the building objects in south west Unity are closer to this settlement than to the refugee camps to the north east in Unity identified as their closest matches in the output dataset.

Adds a tag for estimated building area to identify very large and small ones for priority visual checking.

## Necessary additionas

Inclusion of refugee households in other states

Once sample is drawn, identify and plot nearest other google open buildings objects for calculation of sample weights

## Possible elaborations
Enhanced measure of proxmity of building objects to settlements (e.g. composite index including information on nearest 5 settlements rather than just closest)

Test how useful a proxy the last detection date in the Google Open Buildings data is to prioritise visual checking.

Integrate the WFP road and path data to estimate distnace to nearest road/path https://data.humdata.org/dataset/south-sudan-road-network

## Next step: quality assuring the enumeration data from the South Sudan National Bureau of Statistics (pending data from NBS)
GRID3 UNFPA layer:
https://data.grid3.org/maps/GRID3::grid3-south-sudan-gridded-population-estimates-version-2-0/about

Use this to compare population density estimates per enumeration area


