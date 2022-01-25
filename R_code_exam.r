# R code for the final examination of MECF
# R code for the analysis of the burnt area in the Brazilian biome Cerrado
# previously downloaded the Copernicus' data from 2014 to 2021 (Burned Area 300m V1)
# 8 images, one per year (same month - September - and same period of detection)

#--- Packages, libraries and working directory
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

# 1st create a list with all the 8 images (pattern "BA300") and assign to an object 
blist <- list.files(pattern = "BA300") 
blist # check output

# 2nd apply the raster() since there are single layers images
# import the single layers
import <- lapply(blist,raster) # the eight files imported inside R
import # check output







<- brick("c_gls_BA300_202109300000_GLOBE_PROBAV_V1.1.1.nc")

test # check output

# crop the image on Brazil's territory

# longitude from -80 to -30
# latitude from -40 to 10
ext <- c(-80, -30, -40, 10)
# stack_cropped <- crop() this will crop the whole stack, and then single variables (layers) can be extracted

test_cropped <- crop(test, ext) # put the name of the variable you want to crop and the extension (coordinates)
test_cropped # check output







