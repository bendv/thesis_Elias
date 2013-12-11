# Elias Gebremeskel
# data dec,2013
## Calculate NDVI and Cloud masking
# packages
library(sp)
library(raster)
library(rgdal)
rm(list = ls())
## Directory 
setwd("E:/ndvi20122013" )
# Band 4 and 3 Files "TIFF"
band3_fl <- list.files(pattern=glob2rx("*B3.tif"), recursive=TRUE, ignore.case=TRUE)
band3_fl
band4_fl <- list.files(pattern=glob2rx("*B4.tif"), recursive=TRUE,ignore.case=TRUE)
band4_fl
# creating a character vector of output filenames with the same length to store the output
dir.create("E:/test-NDVI", showWarnings=FALSE)
Output_fname <- gsub("ndvi20122013", "test_NDVI",band3_fl )
Output_fname
# calculate NDVI using a "for" loop
for(i in 1:length(band3_fl)) {
  # bands data
  band3 <- raster(band3_fl[i])
  band4 <- raster(band4_fl[i])
}
# ndvi function
  ndvicalc <- function(x) {
    output <- ( b4-b3)/(b4+b3)
    return(output)
  }
  ndvi <- calc(band3_fl,fun =ndvicalc, filename = Output_fname[i], format="GTiff")
  plot(ndvi)
  ### Error in (function (classes, fdef, mtable)  : 
   # unable to find an inherited method for function 'calc' for signature '"character", "function"'

#option 2
ndvi <- overlay(band4, band3, fun=function(x,y){(x-y)/(x+y)}, filename = Output_fname[i], format = "GTiff",overwrite=TRUE)
plot(ndvi)
### Error in .getGDALtransient(x, filename = filename, options = options,  : 
                            ## filename exists; use overwrite=TRUE
# i tryied by adding the overwrite = True but it produce the below error
#Error in .local(.Object, ...) : 
  #`E:\ndvi20122013\LE71700552013101ASN00\LE71700552013101ASN00_B3.tif' does not exist in the file system,
#and is not recognised as a supported dataset name.
## Then here it eliminates the file b3 from the folder authomatically

## Cloud Mask
setwd ("E:/cloudmask_2012-2013")
cloudmask_list <- list.files("E:/cloudmask_2012-2013")
cloudmask_list
plot(raster(cloudmask_list[1]))
## create an output file name
  dir.create("E:/test-Cloudmask", showWarnings=FALSE)
  fname_mask <- gsub("E:/cloudmask_2012-2013", "test-Cloudmask",cloudmask_list )
  fname_mask
# make a loop for mask calculate 
  for(i in 1:length(cloudmask_list)) {
    # bands data
  ndvi20122013 <- raster(Output_fname[i])
  masking <- raster (cloudmask_list[i])
}
applyMask <- function( ndvi20122013 , masking, maskvalue=c(1, 2, 4, 255), filename=" fname_mask[i]") {
  if(is.null(maskvalue)) stop("Supply one or more values for maskvalue.")
  
  subNA <- function(x,y){x[y%in%maskvalue] <- NA; return(x)}
  
  target <- crop(ndvi20122013,masking)
  
  if(filename=="")
    output <- overlay(ndvi20122013, masking, fun=function(x,y) subNA(x,y))
  else
    output <- overlay(ndvi20122013, masking, fun=function(x,y) subNA(x,y), filename=filename)
  
  return(output)
}
 #End 
    