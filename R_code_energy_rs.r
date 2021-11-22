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

# day 2 

#image of 2006 

l2006 <- brick("defor2_.jpeg")
l2006

# plotting the imported image of 2006 
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")

# defor1_.1 = NIR
# defor1_.2 = red
# defor1_.3 = green

# par function to put two or more images in the same frame 
# two rows and one column 

par(mfrow=c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")

# let's calculate energy in 1992
# close the previows window
dev.off() 
dvi1992 <- l1992$defor1_.1 - l1992$defor1_.2
# choose the color palette
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) # specifying a color scheme
plot(dvi1992, col=cl)

# now let's do the same for the 2006 image
# here it isn't necessary to use again the function dev.off since we'll use the same framework
dvi2006 <- l2006$defor2_.1 - l2006$defor2_.2
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) # specifying a color scheme
plot(dvi2006, col=cl)

# differencing two images of energy in two different times
dvidif <- dvi1992 - dvi2006
# plot the results
cld <- colorRampPalette(c('blue','white','red'))(100) 
plot(dvidif, col=cld)

# final plot: original images, DVIs, and final DVIs difference (total of five images)
# use the par function to plot all the five images in the same frame
par(mfrow=c(3,2))
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)

# put the images in a pdf file
pdf("energy.pdf")
par(mfrow=c(3,2))
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)
dev.off() # dev.off here it is need to close the pdf file

# put the images in a pdf file, but this time one following the other
pdf("dvi.pdf")
par(mfrow=c(3, 1))
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)
dev.off()
