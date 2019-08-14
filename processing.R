library(raster)
library(rgdal)
library(tidyverse)
# Update species name in zonal stats


csv = as_tibble(read.csv(file = "C:/Users/peder/Documents/USGS/Data/amurpeppervine/amurpeppervine_zonal.csv",
           header=T, sep=",")) %>%
  # select(-X) %>%
#   mutate(Species = "Amur peppervine")
# write.csv(csv, file = "C:/Users/peder/Documents/GitHub/Repositories/inhabit_sandbox/species/amurpeppervine/amurpeppervine_zonal.csv")

tolower(gsub(pattern = "\\s", '', gsub("'", replacement = '', x = "Bishop's goutweed")))

setwd("C:/Users/peder/Documents/GitHub/Repositories/inhabit_sandbox/species/")
list.files(path = './amurpeppervine/', pattern = 'zonal', full.names = T)
