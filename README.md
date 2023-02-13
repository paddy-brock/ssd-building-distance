# ssd-building-distance
Enhancing the Google Open Buildings layer for South Sudan for host community and refugee sampling for the UNHCR Forced Displacement Survey

Combine Google Open Buildings data with UNHCR settlement perimeter data to:
- identify building objects (possible households) in camps to support refugee sampling
- allow for sampling of building objects by distance to nearest refugee camp

Tags building objects by whether inside or outside of UNHCR settlement perimeters in Unity and Upper Nile states.

Calculates distance of building objects outside perimeters to the nearest perimeter (and tags which is the nearest perimeter) to allow for the sampling of host community building objects by proximity to refugee camps.

Assumption: have removed the IDP settlement Bentiu, as it is an IDP settlement. NB that some of the building objects in south west Unity are closer to this settlement than to the refugee camps to the north east in Unity identified as their closest matches in the output dataset.

Adds a tag for estimated building area to identify very large and small ones for priority visual checking.

Separate process under development to identify all building objects within a threshold distance of sampled building objects to be used in the field to collect additional data to inform selection probability and weights.

## NB

Inclusion of refugee households in other states is not possible using this approach because there are no polygon extents available for those camps.

## Possible elaborations
Enhanced measure of proxmity of building objects to settlements (e.g. composite index including information on nearest 5 settlements rather than just closest).

Test how useful a proxy the last detection date in the Google Open Buildings data is to prioritise visual checking.

Integrate the WFP road and path data to estimate distance to nearest road/path https://data.humdata.org/dataset/south-sudan-road-network.
