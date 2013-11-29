selectScenes <- function(obj, targ, padding=NULL, verbose=TRUE)
{
  # select scenes (filenames) wth extents overlapping that of a given spatial object
  # args:
  # obj: the object whose extent will be checked
  # can be a raster, spatial object, or an extent object
  # targ: either a character vector of image filenames or an object of type list containing images to be tested
  # padding: Additional area surrounding the extent to be included. Units depend on the projection of obj
  # verbose: send status reports to the console?
  
  # set padding (if not already done)
  if(!is.numeric(padding)){
    padding <- 0
  }
  
  # adjust extent of the input object
  e <- extent(obj)
  e <- extent(c(xmin(e) - padding,
                xmax(e) + padding,
                ymin(e) - padding,
                ymax(e) + padding))
  
  
  # check if targ is a list of rasters or a vector of filenames
  if(is.character(targ)){
    # in this case, return a character vector of files to be used
    # this can be passed to the subset function (wraps around this fn)
    
    # define a logical vector to correspond to targ
    fits <- logical()
    for(i in 1:length(targ)){
      b <- raster(targ[i])
      
      if(projection(b) != projection(obj)){
        warning(targ[i], " projection does not match obj. ", targ[i], " skipped.\n")
      }
      else{
        if(is.null(intersect(e, extent(b)))){
          fits[i] <- FALSE
          if(verbose){
            cat(targ[i], " does not overlap with obj extent.\n")
          }
        } else {
          fits[i] <- TRUE
          if(verbose){
            cat(targ[i], " overlaps with obj extent. Added to list.\n")
          }
        }
      }
    }
    # names of files to use
    keepscenes <- targ[which(fits)]
  }
  else if (is.list(targ)){
    # in this case, return another list with only rasters that fit
    # this list can be passed to subset fn (wrapped around this fn) for further processing
    keepscenes <- lapply(targ, FUN=function(x){
      if(is.null(intersect(e, extent(x))))
        NULL
      else{
        x
      }
    })
  }
  else{
    # if the wrong object type for targ is supplied
    stop("targ must be either a character vector (filenames) or a list of raster layers.")
  }
  
  # if keepscenes is a list, remove all NULL elements
  if(is.list(keepscenes)){
    keepscenes <- keepscenes[-which(unlist(lapply(keepscenes, is.null)))]
  }
  
  return(keepscenes)
}
