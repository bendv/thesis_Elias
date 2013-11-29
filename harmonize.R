harmonize <- function(x){
  # crop raster objects to the intersecting extent
  # required before creating a brick (if extents differ)
  
  # arguments:
    # x - a list of raster layers
  
  # no support for raster bricks
  classes <- unique(lapply(x, class))
  if(length(classes) > 1 | classes!="RasterLayer"){
    stop("harmonize() only supports RasterLayers at this time.\n")
  }
  
  # determine union extent
  e <- intersectExtent(x)
  
  # crop all inputs to this common extent
  y <- lapply(x, FUN=function(a) crop(a, e))
  
  return(y)
}
