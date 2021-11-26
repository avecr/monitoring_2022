# R code for chemical cycling study
# time series of NO2 change in Europe during the lockdown 

library(raster)

# set the working directory

setwd("/Users/anareis/OneDrive/MECF_R_Project/lab/en/") # mac

en01 <- raster("EN_0001.png")
# for all the informations of the data
# what is the range of the sata?
en01

# https://www.google.com/search?q=R+colours+names&tbm=isch&ved=2ahUKEwiF-77Z1bX0AhULtKQKHQ3WDWYQ2-cCegQIABAA&oq=R+colours+names&gs_lcp=CgNpbWcQAzIECAAQEzoHCCMQ7wMQJzoICAAQCBAeEBNQiQhYnwxgwg1oAHAAeACAAUqIAZYDkgEBNpgBAKABAaoBC2d3cy13aXotaW1nwAEB&sclient=img&ei=vKKgYYWtOovokgWNrLewBg&bih=526&biw=1056#imgrc=OtMzJfyT_OwIiM
cl <- colorRampPalette(c("red","orange","yellow"))(100)

# plot the NO2 values of January 2020 by the cl palette
plot(en01, col=cl)

# import the data form March - EN13
en13 <- raster("EN_0013.png")
en13
plot(en13, col=cl)

# build a multiframe window with two rows and one column with the par function
par(mfrow=c(2,1))
plot(en01, col=cl)
plot(en13, col=cl)

# import all the images
en01 <- raster("EN_0001.png")
en02 <- raster("EN_0002.png")
en03 <- raster("EN_0003.png")
en04 <- raster("EN_0004.png")
en05 <- raster("EN_0005.png")
en06 <- raster("EN_0006.png")
en07 <- raster("EN_0007.png")
en08 <- raster("EN_0008.png")
en09 <- raster("EN_0009.png")
en10 <- raster("EN_0010.png")
en11 <- raster("EN_0011.png")
en12 <- raster("EN_0012.png")
en13 <- raster("EN_0013.png")

# plot all the data together
par(mfrow=c(4,4))
plot(en01, col=cl)
plot(en02, col=cl)
plot(en03, col=cl)
plot(en04, col=cl)
plot(en05, col=cl)
plot(en06, col=cl)
plot(en07, col=cl)
plot(en08, col=cl)
plot(en09, col=cl)
plot(en10, col=cl)
plot(en11, col=cl)
plot(en12, col=cl)
plot(en13, col=cl)

# make a stack
EN <- stack(en01,en02,en03,en04,en05,en06,en07,en08,en09,en10,en11,en12,en13)

#plot the stack alltogether 
plot(EN, col=cl)

# plot only the first image with the stack function
# check the stack names
EN
plot(EN$EN_0001, col=cl)

# let's plot a RGB space 
plotRGB(EN, r=1, g=7, b=13, strech="lin") # red layer=beggining of lockdown, blue=intermediary Feb, green=end Mar

