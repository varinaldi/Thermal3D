library(lidR)
library(sf)
library(tidyverse)

set_lidr_threads(3)


l2017 = readLAS('GIview_lidar2017.las')

fp = read_sf('batterry_bldg.geojson') %>%  
  st_transform(crs(l2017)) %>% 

bbox = st_as_sfc(st_bbox(fp))

las_mn = clip_roi(l2017, bbox)

xyz = las_mn@data[,1:3]

write.csv(xyz, 'gi_view_pointcloud.csv', row.names = FALSE)

plot(las_mn, bg = 'white')

