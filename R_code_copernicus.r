# R code for uploading and visualizing Copernicus data in R

# install.packages("ncdf4")
install.packages("ncdf4")
library(ncdf4)
library(raster)

# set the working directory
setwd("/Users/anareis/OneDrive/MECF_R_Project/lab/copernicus") # mac

# upload the data from copernicus in R
snow20211214 <- raster("c_gls_SCE_202112140000_NHEMI_VIIRS_V1.0.1.nc")
snow20211214
