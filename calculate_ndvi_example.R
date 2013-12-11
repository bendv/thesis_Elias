# calculating NDVI for many rasters

# set your working directory
setwd("...")

# look for all band 3 and band 4 filenames
b3fl <- list.files(pattern=glob2rx("*B3.tif"), recursive=TRUE, full.names=TRUE)
b3fl <- list.files(pattern=glob2rx("*B4.tif"), recursive=TRUE, full.names=TRUE)

# create the output filenames
# use the original filename, but remove the "B3" or "B4" tags
# eg. if the filename is "LE7170055..._B3.tif", you want to remove the last 6 characters and replace it to give:
    # "LE7170055..._ndvi.tif", or something like that.
outfl <- paste(substr(b3fl, 1, nchar(b3fl)-7), "ndvi.tif", sep="")
# check the filenames (and adjust if they don't look ok!)
pring(outfl)

# make a for() loop. For each iteration of the loop, you will perform the following steps:
  # 1. Read in one band 3 and band 4 raster layer
  # 2. Create an ndvi raster layer using overlay()
  # 3. Write the new raster layer to file (you can do this inside overlay(), of course)
  # 4. Optional: print a message to let you know where in the for loop you are
  
for(i in 1:length(b3fl)){
  # read in bands 3 and 4 to raster objects
  b3 <- raster(b3fl[i])
  b4 <- raster(b4fl[i])
  
  # calculate ndvi and write to file
  ndvicalc <- function(b3, b4) {
    output <- (b4-b3)/(b4+b3)
    return(output)
  }
  
  ndvi <- overlay(b3, b4, fun=function(x, y){ndvicalc(x, y)}, filename=outfl[i], format="GTiff")

  # print a status message
  cat("Created ndvi layer: ", i, " of ", length(b3fl), ".\n", sep="")
}
