#---------------------------------------------------------------------------------------
# Example using harmonize() to harmonize raster extents
# This is useful if you are creating a rasterBrick but compareRaster() returns an error
#---------------------------------------------------------------------------------------

library(raster)

# migrate to raster data folder (e.g. individual landsat ndvi layers)
setwd('path/to/your/landsat/data')

# find all .tif files in this folder
fl <- list.files(pattern=glob2rx("*.tif"))

# ...or if there are subfolders, use recursive=TRUE
fl <- list.files(pattern=glob2rx("*.tif"), recursive=TRUE)

# make a list object containing raster objects of all these files
images <- lapply(fl, raster)
# check it out
images
plot(images[[1]])
plot(images[[2]])
#...etc....


# if these rasters have different extents, it will not be possible to make a brick from them
# find out which extent is common between all rasters (overlapping extent)
intersectExt <- intersectExtent(images)
# outputs a single extent
print(intersectExt)

# you can use this extent to crop() each raster individually
# or use this shortcut function to harmonize their extents
cropImages <- harmonize(images)
# check it out
cropImages
plot(cropImages[[1]])
...etc....

# now you can put all of these raster layers into a brick
b <- brick(cropImages[[1]], cropImages[[2]], cropImages[[3]], ....etc....)

# that was not very effecient. Here's a shortcut
b <- do.call("brick", cropImages)

# check it out
b
nlayers(b)
plot(b, 1:9)
#...etc....

