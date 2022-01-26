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
fcoverstack <- stack(import)
fcoverstack # check output

# change the names of the variables to facilitate the interpretation
names(fcoverstack) <- c("fcover2016","fcover2017","fcover2018","fcover2019","fcover2020")
                      
#--- Making some tests with two variables 

# assign to objects the variables from 2016 and 2020 (extract them from the stack)
vegetation2016 <- fcoverstack$fcover2016
vegetation2020 <- fcoverstack$fcover2020

vegetation2016 # check
vegetation2020 # check

# plot the vegetation cover in 2016
ggplot() + geom_raster(ssummer, mapping = aes(x = x, y = y, fill = Snow.Cover.Extent.1)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during August 2021")



# crop the image on Brazil's territory

# longitude from -80 to -30
# latitude from -40 to 10
ext <- c(-80, -30, -40, 10)
# stack_cropped <- crop() this will crop the whole stack, and then single variables (layers) can be extracted

test_cropped <- crop(test, ext) # put the name of the variable you want to crop and the extension (coordinates)
test_cropped # check output


