# R code for uploading and visualizing Copernicus data in R

# install.packages("ncdf4")
install.packages("ncdf4")
library(ncdf4)
library(raster)
library(RStoolbox)
library(ggplot2)
library(viridis)

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

