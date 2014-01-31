# Run Bfastmonitor on a single pixel

# get the tura dataset (from geoscripting course) from github
library(devtools)
install_git("http://github.com/bendv/tura")
library(tura)

library(raster)

plot(tura, 1:9)

# make sure layer names correspond to Landsat sceneID's
names(tura)

# getSceneinfo() is also in tura package
s <- getSceneinfo(names(tura))
s

# make a vector of dates (needed later when using bfast)
dates <- s$date

# load bfast package
# install.packages("bfast", repos="http://cran.r-project.org")
library(bfast)

# plot one layer of tura so you can select a pixel
plot(tura, 6)

# extract a pixel time series from here
# e.g. if you already know the cell# 
ts <- as.vector(tura[1000])
plot(ts)

# ...or if you know the x,y coordinates [make sure the projection is correct!]
xy <- matrix(c(823350, 831990), nc = 2)
n <- cellFromXY(tura, xy)
ts <- as.vector(tura[n])

## Optional: you can just take the time series data from ETM+ (Landsat 7) to make the plots look cleaner
ts <- ts[which(s$sensor != "TM")]
plot(ts)
# but them make sure you adjust s and dates to correspond
dates <- dates[which(s$sensor != "TM")]
s <- s[which(s$sensor != "TM"), ]

# the values on the y-axis are very high because they were rescaled by 10000
# scale them back to 'real' NDVI values
ts <- ts / 10000
plot(ts)

# now that we have a time series vector and a dates vector, we have to make the ts "regular"
regts <- bfastts(ts, dates, type="irregular")
plot(regts)
points(regts)
# notice that there is now a correct date on the time axis

# now we can run bfastmonitor on regts
# here, we will use a monitoring period starting after 2005 (so it will only look for change after that time)
# you can adjust this to what you like using the 'monperiod' argument
# e.g. if you want to start monitoring on 1 January 2009, then say 'monperiod = c(2009, 1)'
bfm <- bfastmonitor(regts, start = c(2005, 1), formula = response ~ trend + harmon,
                    order = 1)
# the bfastmonitor output contains alot of information
summary(bfm)
# e.g. the original input data is stored there
bfm$data
# the linear model output
bfm$model
# the monitoring period parameters (start and end of monitoring period)
bfm$monitor
# breakpoints (if any)
bfm$breakpoint
# magnitude
bfm$magnitude

# you can also plot a bfastmonitor object to visualize the output
plot(bfm)

# try with a different monitoring period
bfm2 <- bfastmonitor(regts, start = c(2009, 1), formula = response ~ trend + harmon,
                    order = 1)
bfm2$breakpoint
bfm2$magnitude
plot(bfm2)

# you can also try some other parameters of bfastmonitor() to see how it affects the results
?bfastmonitor

# see (& cite) the following paper for bfastmonitor: 
# Verbesselt, J.P. , Zeileis, A. , Herold, M. (2012). Near real-time disturbance detection using satellite image time series. Remote Sensing of Environment 123 (2012). - ISSN 0034-4257 - p. 98 - 108.
