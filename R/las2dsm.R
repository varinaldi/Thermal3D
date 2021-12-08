library(lidR)
library(sf)
library(tidyverse)

l = readLAS('GIview_lidar2017.las') 


dsm = grid_canopy(l, res = 5, p2r(0.6))

dsm[is.na(dsm)]<-0


dsm = dsm %>% projectRaster(crs = st_crs(32118)$proj4string)

writeRaster(dsm, 'batteryDSM.tif', overwrite=TRUE)

