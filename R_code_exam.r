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
library(RStoolbox) # for putting raster objects inside ggplot2
library(ggplot2) # for constructing special plots 
library(viridis) # for color scales readable for colour-blind people
library(patchwork) # for composition of layouts in ggplot (mainly) with multiple panels
library(rgdal) # graphical data abstraction

# set the working directory
setwd("/Users/anareis/OneDrive/MECF_R_Project/exam")

#--- Importing Copernicus' data

# upload the Copernicus data of FCOVER (1km V2) in R using lapply() and raster()
# 1st create a list with all the five images (pattern "FCOVER") and assign to an object 
rlist <- list.files(pattern = "FCOVER") 
rlist # check output

# 2nd apply the raster() since there are single layers images
# import the single layers
import <- lapply(rlist,raster) # the eight files imported inside R
import # check output

# put all the images together with the stack()
vegstack <- stack(import)
vegstack # check output

# change the names of the variables to facilitate the interpretation
names(vegstack) <- c("FCOVER2006","FCOVER2010","FCOVER2015","FCOVER2016","FCOVER2017","FCOVER2018","FCOVER2019","FCOVER2020")

# plot the images with a palette
# creat the palette
cl<- colorRampPalette(c("brown","darkgoldenrod1","darkolivegreen4","darkolivegreen","darkgreen"))(100)
#plot the images and assign the color
plot(vegstack, col=cl) # it is not a good plot since does not foccus on the study area

# export the image (.png)
png("fcover.png")
plot(vegstack, col=cl)
dev.off() # close the image's window

#--- Focus on Cerrado's using crop() and ggplot+geom_polygon 

# 1st, Brazil's territory: longitude -80 to -30 and latitude -40 to 10
extbr <- c(-80, -30, -40, 10)

# then, the Cerrado's one: long -60 to -45 and lat -20 to -5
# extcerrado <- c(-60, -45, -20, -05)

# crop all the images (in the stack)
v_cropped <- crop(vegstack, extbr) # put the name of the variable you want to crop and the extension (coordinates)
v_cropped # check output

# and 
# vcerrado <- crop(vegstack, extcerrado) # put the name of the variable you want to crop and the extension (coordinates)
# vcerrado # check output

#--- Analysing first and last images

# assign to objects the variables from 2006 and 2020 (extract them from the stack)
veg2006 <- v_cropped$FCOVER2006
veg2020 <- v_cropped$FCOVER2020

veg2006 # check
veg2020 # check

# plot the vegetation cover in 2006 and in 2020
p_veg2006 <- ggplot() + 
                  geom_raster(veg2006, mapping = aes(x = x, y = y, fill = FCOVER2006)) +
                  scale_fill_viridis(option="plasma") + 
                  ggtitle("Fraction of green vegetation cover - January 2006")

p_veg2020 <- ggplot() + 
                  geom_raster(veg2020, mapping = aes(x = x, y = y, fill = FCOVER2020)) +
                  scale_fill_viridis(option="plasma") + 
                  ggtitle("Fraction of green vegetation cover - January 2020")

# build a plot with both images using the patchwork and export it
png("fcover_200620.png")
p_veg2006 - p_veg2020
dev.off() # close images' window

# analyse the difference between the two images 
# create a palette for this difference
cl <- colorRampPalette(c('darkred','darkred', 'darkred', 'darkred', 'aliceblue', 'aliceblue', 'darkgreen', 'darkgreen', 'darkgreen', 'darkgreen'))(100)

fcdif0620 <- veg2020 - veg2006

png("fcoverdif2006_20.png")
plot(fcdif0620, col=cl, main="Difference of FCOVER", sub="Between 2006 and 2020")

dev.off() # close the plot window

# let's see the distribution of each image using the hist() function
# plotting frequency distributions of data
hist(veg2006)
hist(veg2020)

# put them together and export the image
png("hist2006_20.png")
par(mfrow=c(1,2))
hist(veg2006)
hist(veg2020)
dev.off() # close window

# let's see the relationship between the values found in each of the maps/years - regression line
png("regression2006_20.png") # export the image
plot(veg2006, veg2020, xlim=c(0,1), ylim=c(0,1))
abline(0,1,col="red")
dev.off() #close window

# make a plot with all the histograms and all the regressions for all the variables, all together
par(mfrow=c(4,4))
hist(veg2006)
hist(veg2010)
hist(veg2015)
hist(veg2016)
hist(veg2017)
hist(veg2018)
hist(veg2019)
hist(veg2020)
plot(veg2006, veg2010, xlim=c(0,1), ylim=c(0,1))
plot(veg2006, veg2015, xlim=c(0,1), ylim=c(0,1))
plot(veg2006, veg2016, xlim=c(0,1), ylim=c(0,1))
plot(veg2006, veg2017, xlim=c(0,1), ylim=c(0,1))
plot(veg2006, veg2018, xlim=c(0,1), ylim=c(0,1))
plot(veg2006, veg2019, xlim=c(0,1), ylim=c(0,1))
plot(veg2006, veg2020, xlim=c(0,1), ylim=c(0,1))

#--- Importing the territory's boundaries: federation units and Cerrado's limits

# import the federation units' bounderies using readOGR() and the shape file from https://portaldemapas.ibge.gov.br/portal.php#homepage
# funits <- readOGR("BR_UF_2020.shp")
# plot(funits) # imported succesfully

# now, the Cerrado's border using the shape file from http://terrabrasilis.dpi.inpe.br/downloads/
cerrado <- readOGR("cerrado_area.shp")
#plot(cerrado) # imported succesfully

# now, use fortify() to get a dataframe format required by ggplot2
fcerrado <- fortify(cerrado)

#plot with ggplot function, group for correcting the polygon
fc2006_cerrado <- ggplot() + 
         geom_raster(veg2006, mapping = aes(x = x, y = y, fill = veg2006)) +
         scale_fill_viridis(option="plasma") + 
         geom_polygon(data=fcerrado,aes(x=long, y=lat, group=group), fill="transparent",color="black",lwd=0.8) +
         ggtitle("FCOVER in January 2006")

fc2020_cerrado <- ggplot() + 
         geom_raster(veg2020, mapping = aes(x = x, y = y, fill = veg2020)) +
         scale_fill_viridis(option="plasma") + 
         geom_polygon(data=fcerrado,aes(x=long, y=lat, group=group), fill="transparent",color="black",lwd=0.8) +
         ggtitle("FCOVER in January 2020")

fc2006_cerrado/fc2020_cerrado

# analyse the difference between the two images 
# create a palette for this difference
cl <- colorRampPalette(c('blue','white','red'))(100)

vcerradodif <- fc2006_cerrado - fc2020_cerrado ??????

plot(vcerradodif, col=cl)

dev.off() # close the plot window

#--- Leaf Area Index (LAI) 1km

#--- Importing Copernicus' data
# upload the Copernicus data in R using lapply() and raster()

# LAI V2 1km
# 1st create a list with all the five images (pattern "LAI") and assign to an object 
rlist2 <- list.files(pattern = "LAI") 
rlist2 # check output

# 2nd apply the raster() since there are single layers images
# import the single layers
import2 <- lapply(rlist2,raster)
import2 # check output

# put all the images together with the stack()
laistack <- stack(import2)
laistack # check output

# change the names of the variables to facilitate the interpretation
names(laistack) <- c("lai2000","lai2020")

# plot the images with a palette
# creat the palette
cl<- colorRampPalette(c('darkblue','yellow','red','black'))(100)
#plot the images and assign the color
plot(laistack, col=cl) # it is not a good plot since does not foccus on the study area

#--- Focus on Cerrado's bounder using crop() 

# crop all the images together in the stack
laibr <- crop(laistack, extbr)
laibr # check output

laicerrado <- crop(laistack, extcerrado) 
laicerrado # check output

#--- Making some tests with two variables (Brazil's territory)

# assign to objects the variables from 2016 and 2020 (extract them from the stack)
lai2000 <- laibr$lai2000
lai2020 <- laibr$lai2020

lai2000 # check
lai2020 # check

# plot the vegetation cover in 2016 and in 2020
plai2000 <- ggplot() + 
         geom_raster(lai2000, mapping = aes(x = x, y = y, fill = lai2000)) +
         scale_fill_viridis() + #default 
         ggtitle("Leaf Area Index in June 2000")

plai2020 <- ggplot() +
         geom_raster(lai2020, mapping = aes(x = x, y = y, fill = lai2020)) +
         scale_fill_viridis() + #default
         ggtitle("Leaf Area Index in June 2020")

# build a plot with both images using the patchwork
plai2000/plai2020

# analyse the difference between the two images 
# create a palette for this difference
cl <- colorRampPalette(c('blue','white','red'))(100)

laidif <- lai2000 - lai2020

plot(laidif, col=cl)

dev.off() # close the plot window

# let's see the distribution of each image using the hist() function
# plotting frequency distributions of data
hist(lai2000)
hist(lai2020)

# put them together
par(mfrow=c(1,2))
hist(lai2000)
hist(lai2020)

# let's see the relationship between the values found in each of the maps/years - regression line
plot(lai2000, lai2020, xlim=c(0,1), ylim=c(0,1))
abline(0,1,col="red")

#--- Making some tests with two variables (Cerrado's territory)

# assign to objects the variables from 2016 and 2020 (extract them from the stack)
laicerrado2000 <- laicerrado$lai2000
laicerrado2020 <- laicerrado$lai2020

laicerrado2000 # check
laicerrado2020 # check

# plot the vegetation cover in 2016 and in 2020
plaicerrado2000 <- ggplot() + 
         geom_raster(laicerrado2000, mapping = aes(x = x, y = y, fill = lai2000)) +
         scale_fill_viridis() + #default 
         ggtitle("LAI in Cerrado - Jan 2000")

plaicerrado2020 <- ggplot() +
         geom_raster(laicerrado2020, mapping = aes(x = x, y = y, fill = lai2020)) +
         scale_fill_viridis() + #default
         ggtitle("LAI in Cerrado - Jan 2020")

# build a plot with both images using the patchwork
plaicerrado2000/plaicerrado2020

# analyse the difference between the two images 
# create a palette for this difference
cl <- colorRampPalette(c('red', 'white','blue'))(100)

laicerradodif <- laicerrado2020 - laicerrado2000

plot(laicerradodif, col=cl)

dev.off() # close the plot window

# let's see the distribution of each image using the hist() function
# plotting frequency distributions of data
hist(lai2000)
hist(lai2020)

# put them together
par(mfrow=c(1,2))
hist(lai2000)
hist(lai2020)

#--- Analysing Soybean expansion in Cerrado
# importing two images from southern area of Maranhão e Piauí 
# image of 2002
soy2002 <- brick("soy_2002.jpeg") 
soy2002 # check output

# 3 bands: soy_2002.1, soy_2002.2, soy_2002.3
# plot the image with plotRGB
plotRGB(soy2002, r=1, g=2, b=3, stretch="Lin")

# soy_2002.1 = red
# soy_2002.2 = NIR
# soy_2002.3 = green

# image of 2018
soy2018 <- brick("soy_2018.jpeg") 
soy2018 # check output

# 3 bands: soy_2002.1, soy_2002.2, soy_2002.3
# plot the image with plotRGB
plotRGB(soy2018, r=1, g=2, b=3, stretch="Lin")

# soy_2002.1 = red
# soy_2002.2 = NIR
# soy_2002.3 = green
