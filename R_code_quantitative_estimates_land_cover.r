# R_code_quantitative_estimates_land_cover.r
# quantitative estimation of the amount of land cover lost in the tropical forest near to Rio Peixoto (MT)

library(raster)
library(RStoolbox)
library(ggplot2)

# set the working directory
setwd("/Users/anareis/OneDrive/MECF_R_Project/lab") # mac

# brick

# 1st list the files available using list.files() with the pattern "defort"
# use the two images in the lab folder (defor.1 and 2) 
rlist <- list.files(pattern="defor") 

# 2nd lappy: apply a function to a list (rlist and brick function to import entire satellite images)
list_rast <- lapply(rlist, brick)
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
prop1992 <- c(0.8975716, 0.1024284)

proportion1992 <- data.frame(cover, prop1992) # proportion of pixels in 1992
proportion1992 # real proportions/values of cover (forest) and agriculture

#         cover  prop1992
# 1      Forest 0.8975716
# 2 Agriculture 0.1024284

# make a histogram with the values found (cover+prop1992) // functions ggplot2() + geom_bar()
ggplot2(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white") # identity use the values as they are

