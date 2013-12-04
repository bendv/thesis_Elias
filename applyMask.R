applyMask <- function(target, mask, maskvalue=c(), filename="", ...)
{
  # applies a mask over an image
  # this is similar to mask() from the raster package, but allows for other mask values to be specified
  # Args:
    # - target: target raster to be masked (NA to be assigned to specific pixels)
    # - mask: raster object representing a mask to be applied
    # - maskvalue: vector of values for which an NA should be assigned to the target raster where these values are encountered in the mask
    # - filename: (optional). Write output to file.
    # - ...: other optional arguments to be passed to overlay(), including writeRaster()

  # Check if at least one value has been supplied to maskvalue
  if(is.null(maskvalue)) stop("Supply one or more values for maskvalue.")
  
  # small function to assign NA to any pixel with a value found in the maskvalue vector
  subNA <- function(x,y){x[y%in%maskvalue] <- NA; return(x)}
  
  # crop the target raster to the extent of the mask
  target <- crop(target, mask)
  
  # apply subNA() function within an overlay() and optionally write to file
  if(filename=="")
    output <- overlay(target, mask, fun=function(x,y) subNA(x,y))
  else
    output <- overlay(target, mask, fun=function(x,y) subNA(x,y), filename=filename, ...)
  
  return(output)
}
