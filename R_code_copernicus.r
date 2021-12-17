# R code for uploading and visualizing Copernicus data in R

# install.packages("ncdf4")
install.packages("ncdf4")
library(ncdf4)
library(raster)
library(RStoolbox)
library(ggplot2)
library(viridis)
library(patchwork)

# set the working directory
setwd("/Users/anareis/OneDrive/MECF_R_Project/lab/copernicus") # mac

# upload the data from copernicus in R
snow20211214 <- raster("c_gls_SCE_202112140000_NHEMI_VIIRS_V1.0.1.nc")
# how many layers are inside Copernicus data:
snow20211214

# class      : RasterLayer 
# dimensions : 5900, 36000, 212400000  (nrow, ncol, ncell)
# resolution : 0.01, 0.01  (x, y)
# extent     : -180, 180, 25, 84  (xmin, xmax, ymin, ymax)
# crs        : +proj=longlat +datum=WGS84 +no_defs 
# source     : c_gls_SCE_202112140000_NHEMI_VIIRS_V1.0.1.nc 
# names      : Snow.Cover.Extent -> name of the layer that will be used in the aes()
# z-value    : 2021-12-14 
# zvar       : sce 

# plot the data 
plot(snow20211214)

# use colorRampPalette to change colors. Use a palette that is used on R, respecting the colour-blind palette
cl <- colorRampPalette(c('dark blue','blue','light blue'))(100)
plot(snow20211214, col=cl)

# one example of a bad palette that colour-blind people cannot see
cl <- colorRampPalette(c('red','green','blue'))(100) # do not use this palette

# use the ggplot + geom_raster because we're working with a raster package
# here the aes will be used to show the snow cover 
# geom_bar for histograms
ggplot() + geom_raster(snow20211214, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent)) 

# ggplot function with viridis
ggplot() + geom_raster(snow20211214, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent)) + scale_fill_viridis()

# possible to choose the palette. Here the "cividis" were choosen (see the arcticle about colour-blind people and science arcticles)
ggplot() + geom_raster(snow20211214, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent)) + scale_fill_viridis("cividis") + ggtitle("cividis palette")


#### day 2

# Compare two images downloaded from Copernicus 
# Use the lapply function with rlist

rlist <- list.files(pattern="SCE") # the pattern taken from the images' names is "SCE"
rlist

# raster function for single layers and brick function for several layers
list_rast <- lapply(rlist, raster)
list_rast

snowstack <- stack(list_rast)
snowstack

# we're going to use two variables (see the names in R)
ssummer <- snowstack$Snow.Cover.Extent.1
swinter <- snowstack$Snow.Cover.Extent.2
# check the variables
ssummer
swinter

# plot the snow cover during the summer 
ggplot() + geom_raster(ssummer, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent.1)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during August 2021")

# plot the snow cover during the winter
ggplot() + geom_raster(swinter, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent.2)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during December 2021")

# let's patchwork them together 

p1 <- ggplot() + geom_raster(ssummer, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent.1)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during August 2021")

p2 <- ggplot() + geom_raster(swinter, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent.2)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during December 2021")

p1/p2

# let's crop the image on a certain area using crop() function

# longitude from 0 to 20
# latitude from 30 to 50
ext <- c(0, 20, 30, 50)
# stack_cropped <- crop() will crop the whole stack, and 

ssummer_cropped <- crop(ssummer, ext) # put the name of the variable you want to crop and the extension (coordinates)
swinter_cropped <- crop(swinter, ext)

# use ggplot!
p1_cropped <- ggplot() + geom_raster(ssummer_cropped, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent.1)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during August 2021 cropped")

p2_cropped <- ggplot() + geom_raster(swinter_cropped, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent.2)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during December 2021 cropped")

p1_cropped/p2_cropped
