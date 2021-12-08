library(lidR)
library(tidyverse)
library(sf)


f = file.path('las2017',list.files('las2017', pattern = '.las'))

# use this only for processing 2017 data
s = c('980192', '980195', '980197', '980190')
f = f[str_detect(f, paste(s, collapse = '|'))]

# read first lidar in file list
las = readLAS(f[1])


for (i in 2:length(f)){
  
  l = readLAS(f[i])
  
  las = rbind(las,l)
  
}


# function to remove noise
filterNoise = function(las, sensitivity)
{
  p95 <- grid_metrics(las, ~quantile(Z, probs = 0.95), 10)
  las <- merge_spatial(las, p95, "p95")
  las <- filter_poi(las, Z < p95*sensitivity)
  las$p95 <- NULL
  return(las)
}


l = filterNoise(las, 1.9) %>% filter_poi( Z>2)

# writeLAS(l, 'GIview_lidar2017.las')




