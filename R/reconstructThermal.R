library(lidR)
library(sf)
library(tidyverse)


pts = read_csv('xyz.csv',col_names = F) %>% 
  `names<-`(c('X', 'Y','Z'))

temp = read_csv('thermal_temp.csv',col_names = F) %>%
  `names<-`(c('Temperature'))



recons = LAS(cbind(pts, temp))



## read viewshed data 
vw = raster('viewshed.tif') %>% 
  projectRaster(crs = st_crs(2263)$proj4string) %>% 
  focal( w=matrix(1,nrow=3,ncol=3), fun=max)


#
## add viewshed to liDAR point Cloud
lview = recons %>%
  merge_spatial( vw, "vw")


lview@data$Temperature[lview@data$vw < 1] <- 0


# plot(lview, color = 'Temperature', colorPallete = heat.colors(100), bg = 'white')

write.csv(lview@data, 'Battery_park_XYZ_Temp.csv', row.names = F)
