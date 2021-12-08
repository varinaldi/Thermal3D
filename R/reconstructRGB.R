library(lidR)
library(sf)
library(tidyverse)


pts = read_csv('xyz_color.csv',col_names = F) %>% 
  `names<-`(c('X', 'Y','Z'))

rgb = read_csv('rgb_color.csv',col_names = F) %>%
  `names<-`(c('R', 'G','B')) %>% 
  mutate_all( funs(as.integer))



recons = LAS(pts)

reconsRGB <- add_lasrgb(recons, rgb$R, rgb$G, rgb$B)


## read viewshed data 
vw = raster('viewshed30_1.tif') %>% 
  projectRaster(crs = st_crs(2263)$proj4string) %>% 
  focal( w=matrix(1,nrow=3,ncol=3), fun=max)


#
## add viewshed to liDAR point Cloud
lview = reconsRGB %>%
  merge_spatial( vw, "vw")



lview@data$R[lview@data$vw < 1] <- 0
lview@data$G[lview@data$vw < 1] <- 0
lview@data$B[lview@data$vw < 1] <- 0


# plot(lview, color = 'RGB', bg = 'white')



write.csv(lview@data, 'Battery_park_XYZRGB.csv', row.names = F)
