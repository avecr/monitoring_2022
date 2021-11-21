# R code for estimating energy in ecosystems
# install_packages("raster")
# install_packages("rgdal")
 
library(raster)
library(rgdal)
 
# set the working directory
setwd("/Users/anareis/OneDrive/MECF_R_Project/lab")
 
# importing the data
l1992 <- brick("defor1_.jpeg") # image of 1992
 
# image of 1992
l1992

# Bands: defor1_.1, defor1_.2, defor1_.3
# plotRGB
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")

# defor1_.1 = NIR
# defor1_.2 = red
# defor1_.3 = green


