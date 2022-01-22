# here we will learn how to make a quantitative application to copernicus data
# monitor the ice melt in Greenland
# Proxy: Land Surface Temperature (LST) of Copernicus Program

# install.packages(raster)

library(raster)
library(ggplot2)
library(RStoolbox)
library(patchwork)
library(viridis)

# set the working directory
setwd("/Users/anareis/OneDrive/MECF_R_Project/lab/greenland/") # mac

# create a list with all the potential files which are stored in R, starting from a pattern 
rlist <- list.files(pattern = "lst")
rlist # check the output

# apply the raster function since there are single layers of lst
# import the single layers
import <- lapply(rlist,raster) # so here the four files will be imported inside R
import # check

# now, the four files will be "stacked", put the data all together
tgr <- stack(import)
tgr # check

# let's plot the stack using the palette cl
cl <- colorRampPalette(c("blue","light blue","pink","yellow"))(100)
plot(tgr, col=cl)

# ggplot of the first and final images 2000 vs. 2015
# ggplot first function to open our window
# 2000
p1 <- ggplot() +
geom_raster(tgr$lst_2000, mapping=aes(x=x, y=y, fill=lst_2000)) +
scale_fill_viridis(option="magma") +
ggtitle("LST 2000")

# 2015
p2 <- ggplot() +
geom_raster(tgr$lst_2015, mapping=aes(x=x, y=y, fill=lst_2015)) +
scale_fill_viridis(option="magma") +
ggtitle("LST 2015")

# let's plot them together
p1+p2

# let's see the distribution of each image using the hist() function (histogram of a given data values)
# plotting frequency distributions of data
dev.off() # to clean the previous window
hist(tgr$lst_2000)
hist(tgr$lst_2015)

# put them all together
par(mfrow=c(1,2))
hist(tgr$lst_2000)
hist(tgr$lst_2015)

# plot the hist for all the images
par(mfrow=c(2,2))
hist(tgr$lst_2000)
hist(tgr$lst_2005)
hist(tgr$lst_2010)
hist(tgr$lst_2015)

# let's see the relationship between the values found in each of the maps/years - regression line
# abline function to chose the interception (b) and the slope (b) and  of the formula
dev.off() # close the window
plot(tgr$lst_2010, tgr$lst_2015, xlim=c(12500,15000), ylim=c(12500,15000))
abline(0,1,col="red")

# make a plot with all the histograms and all the regressions for all the variables, all together
par(mfrow=c(4,4))
hist(tgr$lst_2000)
hist(tgr$lst_2005)
hist(tgr$lst_2010)
hist(tgr$lst_2015)
plot(tgr$lst_2010, tgr$lst_2015, xlim=c(12500,15000), ylim=c(12500,15000))
plot(tgr$lst_2010, tgr$lst_2000, xlim=c(12500,15000), ylim=c(12500,15000))
plot(tgr$lst_2010, tgr$lst_2005, xlim=c(12500,15000), ylim=c(12500,15000))

# another solution: use the pairs function which creates a scatterplot matrices
pairs(tgr)
