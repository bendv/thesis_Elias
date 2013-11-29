getSceneinfoSPOT <- function(sceneID)
{
  # parse scene information based on SPOT5 sceneIDs
  # see getSceneinfo() for more information
  
  sensor <- substr(sceneID, 1, 1)
  j <- substr(sceneID, 2, 4)
  k <- substr(sceneID, 5, 7)
  date <- as.Date(substr(sceneID, 8, 13), format="%y%m%d")
  
  info <- data.frame(sensor=sensor, j=j, k=k, date=date)
  return(info)
}
