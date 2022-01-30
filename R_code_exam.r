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
dev.off() # close window

# export the image (.png)
#png("fcover.png")
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
#png("fcover_200620.png")
p_veg2006 - p_veg2020
dev.off() # close images' window

# analyse the difference between the two images 
# create a palette for this difference
cldif <- colorRampPalette(c('darkred','darkred', 'darkred', 'darkred', 'aliceblue', 'aliceblue', 'darkgreen', 'darkgreen', 'darkgreen', 'darkgreen'))(100)

fcdif0620 <- veg2020 - veg2006

#png("fcoverdif2006_20.png")
plot(fcdif0620, col=cl, main="Difference of FCOVER", sub="Between 2006 and 2020")

dev.off() # close the plot window

# checked 30/01

# let's see the distribution of each image using the hist() function
# plotting frequency distributions of data
hist(veg2006)
hist(veg2020)

# put them together and export the image
#png("hist2006_20.png")
par(mfrow=c(1,2))
hist(veg2006)
hist(veg2020)
dev.off() # close window

# let's see the relationship between the values found in each of the maps/years - regression line
#png("regression2006_20.png") # export the image
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
geom_raster(veg2006, mapping = aes(x = x, y = y, fill = FCOVER2006)) +
scale_fill_viridis(option="plasma") +
geom_polygon(data=fcerrado,aes(x=long, y=lat, group=group), fill="transparent",color="black",lwd=0.8) +
ggtitle("FCOVER in January 2006")

fc2020_cerrado <- ggplot() + 
         geom_raster(veg2020, mapping = aes(x = x, y = y, fill = FCOVER2020)) +
         scale_fill_viridis(option="plasma") + 
         geom_polygon(data=fcerrado,aes(x=long, y=lat, group=group), fill="transparent",color="black",lwd=0.8) +
         ggtitle("FCOVER in January 2020")

# and export the dif
#png("fcovercerrado2006_20.png")
fc2006_cerrado - fc2020_cerrado
dev.off()

# analyse the difference between the two images
cerradodif2006_20 <- ggplot() + 
         geom_raster(fcdif0620, mapping = aes(x = x, y = y, fill = layer)) +
         geom_polygon(data=fcerrado,aes(x=long, y=lat, group=group), fill="transparent",color="black",lwd=0.8) +
         scale_fill_viridis(option="plasma") +
         ggtitle("Dif FCOVER in Cerrado 2006-2020")

# plot and export
# png("fcovercerradodif2006_20.png")
cerradodif2006_20
dev.off() # close the plot window
         
# make a plot with fcover in Cerrado in 2006 and 2020, and the dif 
# png("fcovercerrado0620.png")
fc2006_cerrado / fc2020_cerrado / cerradodif2006_20
dev.off() # close the plot window

# checked 30/01!!! 

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
names(laistack) <- c("lai2006","lai2020")

# plot the images with cl palette
#plot the images and export it
png("lai2006_20.png")
plot(laistack, col=cl) # it is not a good plot since does not foccus on the study area
dev.off() # close window

# crop all the images together in the stack
lai <- crop(laistack, extbr)
lai # check output

# assign to objects the variables from 2016 and 2020 (extract them from the stack)
l2006 <- lai$lai2006
l2020 <- lai$lai2020

l2006 # check
l2020 # check

# assign objetcs to the ggplot of 2016 and 2020 with the Cerrado's boundaries
l2006_plot <- ggplot() +          
            geom_raster(l2006, mapping = aes(x = x, y = y, fill = lai2006)) +
            scale_fill_viridis(option="magma") + 
            geom_polygon(data=fcerrado,aes(x=long, y=lat, group=group), fill="transparent",color="black",lwd=0.8) +
            ggtitle("LAI in January 2006")

l2020_plot <- ggplot() +
            geom_raster(l2006, mapping = aes(x = x, y = y, fill = lai2006)) +
            scale_fill_viridis(option="magma") +
            geom_polygon(data=fcerrado,aes(x=long, y=lat, group=group), fill="transparent",color="black",lwd=0.8) +
            ggtitle("LAI in January 2020")

l2006_plot / l2020_plot # check
dev.off()

# and analyse the difference between the two images
ldif <- l2020 - l2006
ldif # check names: layer

ldif_plot <- ggplot() +
            geom_raster(ldif, mapping = aes(x = x, y = y, fill = layer)) +
            scale_fill_viridis(option="magma") +
            geom_polygon(data=fcerrado,aes(x=long, y=lat, group=group), fill="transparent",color="black",lwd=0.8) +
            ggtitle("Difference of LAI 2006-2020")

# make a plot with l2006, l2020, and ldif 
#png("lcerrado0620.png")
l2006_plot / l2020_plot / ldif_plot
dev.off() # close the plot window

# checked 30/01!!

# let's see the distribution of each image using the hist() function
# plotting frequency distributions of data
hist(l2006, maxpixels=1000000)
hist(l2006)
hist(l2020)

# put them together
par(mfrow=c(1,2))
hist(l2006)
hist(l2020)

# let's see the relationship between the values found in each of the maps/years - regression line
plot(l2006, l2020, xlim=c(0,1), ylim=c(0,1))
abline(0,1,col="red")

#--- Analysing Soybean expansion in the "Matopiba" region in Cerrado

# use the DVI to measure the "greenness" of the biome  
# importing two images from Google Earth (both from the same period - december)
# image of 2006
soy2006 <- brick("gearth1.jpg") 
soy2006 # check output: 3 bands - gearth1.1, gearth1.2, gearth1.3

# plot the image with plotRGB
plotRGB(soy2006, r=1, g=2, b=3, stretch="Lin")
# with certanty, the NIR is in the gearth1.1 band. Possibly, the other bands could be:
# gearth1.2 = red
# gearth1.3 = green

# image of 2020
soy2020 <- brick("gearth2.jpg") 
soy2020 # check output: 3 bands - gearth2.1, gearth2.2, gearth2.3

# plot the image with plotRGB
plotRGB(soy2020, r=1, g=2, b=3, stretch="Lin")
# with certanty, the NIR is in the gearth1.1 band. Possibly, the other bands could be:
# gearth2.2 = red
# gearth2.3 = green

# calculate the DVI of 2006 and 2020
dvi2006 <- soy2006$gearth1.1 - soy2006$gearth1.2

# choose the color palette
dvicl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)

plot(dvi2006, col=dvicl)

# now the 2020 image
dvi2020 <- soy2020$gearth2.1 - soy2020$gearth2.2

plot(dvi2020, col=dvicl)

# make the difference between the two images
dvidif <- dvi2006 - dvi2020

# plot the results
dcl <- colorRampPalette(c('blue','white','red'))(100) 
plot(dvidif, col=cld)

# final plot with par(): original images, DVIs, and final DVIs difference (total of five images)
#png("soymatopiba.png")
par(mfrow=c(3,2))
plotRGB(soy2006, r=1, g=2, b=3, stretch="Lin")
plotRGB(soy2020, r=1, g=2, b=3, stretch="Lin")
plot(dvi2006, col=dvicl)
plot(dvi2020, col=dvicl)
plot(dvidif, col=cld)
dev.off()
