## Elias Gebremeskel
## Date _ oct 2013
# Thesis Project- Assessing Local Expert Data Quality for Forest Monitoring
     #    A Case of Kafa, Ethiopia
## producing Land Sat Time series of Kafa Forest
#################################################
########################################################################
rm(list = ls())
setwd("E:/Thesis/Geo_script/R Thesis")
datdir <- file.path("E:/Thesis/Geo_script/R Thesis")
datdir <- "data"
## Important packages
 #library(rasta)
library(raster)
library(rgdal)
library(rgeos)
library(sp)
library(maptools)
library(ggplot2)
library(rasterVis)
# Installing the file --polygones
# Reading Kaffa Shapfile
kaffashapefile <- readOGR("E:/Thesis/Geodata_ethiopia", "Kafa_Shapfile")
# Project the shapfile
kaffaproj <- CRS("+proj=utm +zone=36 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
kaffa <- spTransform(kaffashapefile , kaffaproj)
plot(kaffa)
boundary <- extent(kaffa)
# reading Rangers Mobile polygone shapfile
poly <- readOGR("E:/Thesis/Geodata_ethiopia", "ranger_mobile_poly" )
proj4string(poly) <- CRS("+proj=utm +zone=36 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
kaffapoly <- spTransform(poly , polyproj)
plot(poly)
# reading Rangers Mobile points shapfile
points <-  readOGR("E:/Thesis/Geodata_ethiopia", "ranger_mobile_point")
plot(points)
head(points)
pointdf <- as.data.frame(points)
proj4string(points) <- CRS("+proj=utm +zone=36 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
# Test polygone shapfile in Tura
polytest <- readOGR("E:/Thesis/Geodata_ethiopia", "Tura")
polytestproj <- CRS("+proj=utm +zone=36 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
kaffapolytest <- spTransform(polytest , polytestproj )
plot(kaffapolytest)
# Creat stack/brick for the LS time series images
## Read , list and creat layer stack
list <- list.files("E:/Thesis/data_from_Ben/Kafa", pattern = "*.tif", full.name = TRUE)
list
plot(raster(list[856]))
 # stack/brick
Kafa <- stack(x=list[1:785])
Kafa
writeRaster(x= Kafa,filename = "E:/Thesis/data_from_Ben/Kafa.grd2", datatype= "INT2S",overwrite=TRUE)

## Data processing
data(kafa)
dates <- substr(names(kafa), 10, 16)
print(as.Date(dates, format="%Y%j"))
## identify the dates and years
sceneID <- names(kafa)
sceneinfo <- getSceneinfo(sceneID)
sceneinfo$date
sceneinfo$year <- factor(substr(sceneinfo$date, 1, 4), levels = c(1999:2013))
## Test tura polygone
polytura <- readOGR("E:/Thesis/Geodata_ethiopia", "Tura")
polyturaproj <- CRS("+proj=utm +zone=36 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
kaffapolytura <- spTransform(polytura, polyturaproj) 
plot(kaffapolytura)
polyboundtura <- extent(kaffapolytura )
## convert scale 
kafa <- kafa/10000
## calculate mean NDVI
meanNDVITS1 <- extract(tura,polyboundtura, fun=mean, na.rm = TRUE)
plot(meanNDVITS1)
## Data frame
df1 <- data.frame(date = sceneinfo$date,  sensor = sceneinfo$sensor,  ndvi = as.numeric(meanNDVITS1))
## Plot TS
ggplot(data = df1 , aes(x = date, y = ndvi)) + 
  geom_point() + 
  geom_line()
### test two







