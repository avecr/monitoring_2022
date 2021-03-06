# R_code_quantitative_estimates_land_cover.r
# quantitative estimation of the amount of land cover lost in the tropical forest near to Rio Peixoto (MT)

install.packages(gridExtra)
install.packages(patchwork)
library(raster)
library(RStoolbox) #use that only for the classification process 
library(ggplot2)
library(gridExtra)
library(grid.arrange) # put several graphs in the same multiframe

# set the working directory
setwd("/Users/anareis/OneDrive/MECF_R_Project/lab") # mac

# brick

# 1st list the files available using list.files() with the pattern "defort"
# use the two images in the lab folder (defor.1 and 2) 
rlist <- list.files(pattern="defor") 
rlist

# 2nd lappy: apply a function to a list (rlist and brick function to import entire satellite images)
list_rast <- lapply(rlist, brick) #lapply(x, FUN)
list_rast # see separatly the two images separatly 
 
plot(list_rast[[1]]) # instead of using the "$", use the "colchetes"

# assign the list_rast[[1]] into a object just to be simpler
l1992 <- list_rast[[1]]

# defor: NIR 1, red 2, green 3
plotRGB(l1992, r=1, g=2, b=3) # in this case, evertyhing will become red, since the NIR is in the top of the red component in the RGB

# assign and plot the image of 2006
l2006 <- list_rast[[2]]
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# now, let's estimate the amount of land cover lost using the classification (unsuperClass)
# a final map with two classifications: forest and agricultural areas 

# unsuperClass() states if there are meaninfull groups in the file
l1992c <- unsuperClass(l1992, nClasses=2)
l1992c

plot(l1992c$map) 
# depending on how the sets are classified in the computer, might be differences in the colors 
# value 1 = forest
# value 2 = agricultural areas and water

# how many pixels inside my map are agricultural/forest areas? Use frequencies
# total amount of pixels in this case: 341292 (shown in R)

freq(l1992c$map)
# value  count
# [1,]     1 306334
# [2,]     2  34958
# forest (class 1) = 306334
# agricultural areas and water (class 2) = 34958

# let's check the proportions of forest/agricultural areas
total <- 341292
propforest <- 306334 / total
propagri <- 34958 / total

# propagri: 0.1024284 ~ 0.10
# propforest: 0.8975716 ~ 0.90

# buid a dataframe
cover <- c("Forest", "Agriculture")
prop1992 <- c(propforest, propagri)
# prop1992 <- c(0.8975716, 0.1024284)

proportion1992 <- data.frame(cover, prop1992) # proportion of pixels in 1992
proportion1992 # real proportions/values of cover (forest) and agriculture

#         cover  prop1992
# 1      Forest 0.8975716
# 2 Agriculture 0.1024284

# make a histogram with the values found (cover+prop1992) // functions ggplot2() + geom_bar()
ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white") # identity use the values as they are

# classification of 2006 // Unsupervised classification
# repeat the code with the data from 2006

l2006c <- unsuperClass(l2006, nClasses=2)
l2006c

plot(l2006c$map) 

freq(l2006c$map)
# value  count
# [1,]     1 178098
# [2,]     2 164628
# forest (class 1)
# agricultural areas and water (class 2)

total2006 <- 342726
propforest2006 <- 178098 / total2006
propagri2006 <- 164628 / total2006

cover <- c("Forest", "Agriculture")
prop1992 <- c(propforest, propagri)
prop2006 <- c(propforest2006, propagri2006)

proportion2006 <- data.frame(cover, prop2006) # proportion of pixels in 1992
proportion2006

proportion <- data.frame(cover, prop1992, prop2006)

proportion # number of prof Rocchini
# cover  prop1992  prop2006
# 1      Forest 0.8982982 0.5233744
# 2 Agriculture 0.1017018 0.4766256

ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white") # identity use the values as they are

ggplot(proportion, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white") # identity use the values as they are


p1 <- ggplot(proportion, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)
p2 <- ggplot(proportion, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)

# recall gridExtra instead of grid.arrange which is the function 
library(gridExtra)

# plot two graphs with gridExtra package
grid.arrange(p1, p2, nrow=1)

# change the graphs scale to the same so it could be better to compared adding the "ylim()" argument
ggplot(proportion, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)
ggplot(proportion, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)

# the gridExtra package is being supplanted by the fancy patchwork one
library(patchwork)

# or with patchwork pachage
p1+p2

# patchwork is working even with raster data, but they should be plotted with
# instead of using plotRGB we are going to use ggRGB
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin") # this is the plot that we are used to it
ggRGB(l1992, r=1, g=2, b=3)
ggRGB(l1992, r=1, g=2, b=3, stretch="lin") # new way to plot using the ggRGB function and the linear stretch
ggRGB(l1992, r=1, g=2, b=3, stretch="hist") # histogram
ggRGB(l1992, r=1, g=2, b=3, stretch="sqrt") # compact the data using the square route. In stastistics, use sqrt or percentage to avoid the extreme numbers
ggRGB(l1992, r=1, g=2, b=3, stretch="log") # REMEMBER: in R, log means ln (in base e, not 10)

# use patchwork to plot the data all together
gp1 <- ggRGB(l1992, r=1, g=2, b=3, stretch="lin") 
gp2 <- ggRGB(l1992, r=1, g=2, b=3, stretch="hist") 
gp3 <- ggRGB(l1992, r=1, g=2, b=3, stretch="sqrt") 
gp4 <- ggRGB(l1992, r=1, g=2, b=3, stretch="log")
gp1+gp2+gp3+gp4

# multitemporal patchwork
gp1 <- ggRGB(l1992, r=1, g=2, b=3)
gp5 <- ggRGB(l2006, r=1, g=2, b=3)

gp1+gp5 # one beside the other

gp1/gp5 # one on the top of the other



