#-----------------------------------------------------
# Example of how to use the subsetScenes() function
#-----------------------------------------------------

library(raster)
library(rgdal)

# load in a SpatialPolygonsDataFrame (shapefile)
allFeatures <- readOGR(dsn="path/to/polygon/data/nameOfFile.shp", layer="nameOfLayer")

# select the first polygon from this object
poly <- allFeatures[1,]

# migrate to folder with reference scenes (eg. SPOT5 or RapidEye)
setwd("path/to/your/data")

# assuming data is in GeoTiff format, list all files in this directory with the .tif extension
fl <- list.files(pattern=glob2rx("*.tif"))

# if there are subdirectories, add recursive=TRUE argument
fl <- list.files(pattern=glob2rx("*.tif"), recursive=TRUE)

# which of these scenes have data overlapping with the single polygon above?
overlapScenes <- selectScenes(poly, fl)
print(overlapScenes)

# what if we add a buffer (which I've called 'padding' in this function) of 100m?
overlapScenes <- selectScenes(poly, fl, padding=100)
print(overlapScenes)

# make a list of subsetted (cropped) rasters based on this polygon
subsets <- subsetScenes(poly, fl, padding=100)
# this outputs a list of raster objects
class(subsets)
subsets

# check out the first raster and compare to the polygon
plot(subsets[[1]])
plot(poly, add=TRUE)
