# R code for the final examination of MECF
# R code for the analysis of the vegetation cover and its association with land use in the Brazilian biome Cerrado
# previously downloaded the Copernicus' data from 2016 to 2020 (FCover 1km V2)
#  images, one per year (same month - January - and same period of detection)

#--- Packages, libraries and working directoryvegetation
# to analyse the data, the following packages must be installed
# install.packages("ncdf4") 
# install.packages("raster")
# install.packages(gridExtra) # has been replaced by the patchwork one!
# install.packages("patchwork")
# install.packages("viridis")
# install.packages("rgdal")

# and then their libraries must be recalled
library(ncdf4) # for managing Copernicus data
library(raster) # for creating a RasterLayer
library(RStoolbox) # tools for remote sensing data analysis
library(ggplot2) # for constructing special plots 
library(viridis) # for color scales readable for colour-blind people
library(patchwork) # for composition of layouts in ggplot (mainly) with multiple panels
library(rgdal) # ?????

# set the working directory
setwd("/Users/anareis/OneDrive/MECF_R_Project/exam")

#--- Importing Copernicus' data
# upload the Copernicus data in R using lapply() and raster()

# 1st create a list with all the five images (pattern "FCOVER") and assign to an object 
rlist <- list.files(pattern = "FCOVER") 
rlist # check output

# 2nd apply the raster() since there are single layers images
# import the single layers
import <- lapply(rlist,raster) # the eight files imported inside R
import # check output

# put all the images together with the stack()
fcstack <- stack(import)
fcstack # check output

# change the names of the variables to facilitate the interpretation
names(fcstack) <- c("fc2016","fc2017","fc2018","fc2019","fc2020")

#--- Focus on Brazil's territory using crop() 

# longitude from -80 to -30
# latitude from -40 to 10
ext <- c(-80, -30, -40, 10)

# crop all the images in the stack
fc_cropped <- crop(fcstack, ext) # put the name of the variable you want to crop and the extension (coordinates)
fc_cropped # check output

#--- Making some tests with two variables 

# assign to objects the variables from 2016 and 2020 (extract them from the stack)
vegetation2016 <- fc_cropped$fc2016
vegetation2020 <- fc_cropped$fc2020

vegetation2016 # check
vegetation2020 # check

# plot the vegetation cover in 2016 and in 2020
p2016 <- ggplot() + 
         geom_raster(vegetation2016, mapping = aes(x = x, y = y, fill = fc2016)) + 
         scale_fill_viridis(option="viridis") + 
         ggtitle("Vegetation cover in January 2016")

p2020 <- ggplot() + geom_raster(vegetation2020, mapping = aes(x = x, y = y, fill = fc2020)) + scale_fill_viridis(option="viridis") + ggtitle("Vegetation cover in January 2020")

# build a plot with both images using the patchwork
p2016/p2020

dev.off() # close the plot window

#--- 
