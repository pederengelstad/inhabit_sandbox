library(raster)
library(rgdal)
library(tidyverse)
library(sp)
library(rgeos)
library(sf)

# Make sure to polygonize FDAWs first...

# List species folders
# dirs = list.dirs(path = "E:/Users/engelstad/USGS/data/20190723", full.names = T, recursive = F)
dirs = list.dirs(path = "C:/Users/peder/Documents/USGS/Data/", full.names = T, recursive = F)
dirs[1]
conus = readOGR("C:/Users/peder/Documents/GitHub/Repositories/inhabit_sandbox/CONUS_4269/CONUS_4269.shp")
# conus = readOGR("E:/Users/engelstad/GitHub/inhabit_sandbox/CONUS_4269/CONUS_4269.shp")

for(d in dirs[1]){
  
  # Process FDAW
  kde = readOGR(list.files(d, pattern = 'kde_tmp.shp', full.names = T))
  kde = spTransform(kde, CRSobj = crs(conus))
  clip = rgeos::gIntersection(kde, conus)
  clip = SpatialPolygonsDataFrame(Sr = clip, data = data.frame(data = 1))
  writeOGR(obj = clip, 
           layer = "kde", 
           driver = "ESRI Shapefile", 
           dsn = paste0(d,'/kde.shp'))
  
  # Clean things up
  # if(file.exists(paste0(d, '/kde.shp'))) unlink(list.files(d, pattern = 'kde_tmp*', full.names = T))
  
  # Convert presence points to shapefile
  csv = read.table(file = list.files(d, pattern = 'MDS', full.names = T), 
                   header = T, sep = ',', stringsAsFactors = F) %>%
    filter(responseBinary == 1) %>%
    select(X, Y) %>%
    mutate(X = as.numeric(X), Y = as.numeric(Y))
  
  pts = SpatialPointsDataFrame(coords = csv, data = csv, 
                               proj4string = crs('+proj=aea +lat_1=20 +lat_2=60 +lat_0=40 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs)'))
  
  pts = spTransform(pts, CRSobj = crs(conus))
  pts = sf::st_as_sf(pts)
  clip = sf::st_as_sf(clip)
  pts.out = sf::st_intersection(pts, clip)
  st_write(pts.out, dsn = paste0(d, "/pts.sqlite"), layer = "pts")
}
