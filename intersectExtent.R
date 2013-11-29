intersectExtent <- function(x){
  # output an extent object representing the union of all extents
  # arguments:
  # x - either a list of rasterLayers, sp objects, or Extent objects
  
  # check if input is a list
  if(!is.list(x)){
    stop("x should be a list of RasterLayers, sp objects or Extent objects.\n")
  }
  
  # check object classes in list
  classes <- unique(unlist(sapply(x, class)))
  if(length(classes) > 1 | !classes %in% c("RasterLayer", "RasterBrick", "RasterStack", "Extent", "SpatialPolygons", "SpatialPolygonsDataFrame")){
    stop("x should be a list of RasterLayers, sp objects or Extent objects.\n")
  }
  
  # extract extents
  if(classes=="Extent"){
    e <- x
  } else {
    e <- lapply(x, extent)
  }
  
  # define intersecting Extent
  isectxmin <- max(unlist(lapply(e, xmin)))
  isectxmax <- min(unlist(lapply(e, xmax)))
  isectymin <- max(unlist(lapply(e, ymin)))
  isectymax <- min(unlist(lapply(e, ymax)))
  isecte <- extent(c(isectxmin, isectxmax, isectymin, isectymax))
  
  return(isecte)
}
