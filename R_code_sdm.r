install.packages(c("sdm","rgdal"))
library(sdm)
library(raster) # predictors
library(rgdal) # species: an array of x, y points x0, y0, x1y1...

# species data
file <- system.file("external/species.shp", package="sdm")

file

species <- shapefile(file) # exactly as the raster function for raster files

# how many occurrences are there? Subset a DataFrame
presences <- species[species$Occurrence == 1,]
absences <- species[species$Occurrence == 0,]

# plot!
plot(species, phc=19)

# plot presences and absences
plot(presences, phc=19, col="blue")
plot(absences, phc=19, col="red")

# let's look the at predictors
path <- system.file("external", package="sdm")

lst <- list.files(path, pattern='asc', full.names=T)

# you can use the lapply function with the raster function but in this case 
preds <- stack(lst)

# plot preds
cl <- colorRampPalette(c('blue','orange','red','yellow')) (100)
plot(preds, col=cl)

# day 2
# importing the source
# set the working directory
setwd("/Users/anareis/OneDrive/MECF_R_Project/lab")

# using the function source, wich read R code from a file
source("R_code_source_sdm.r")

# in the theoretical slide of SDMs we should use individuals of the species and predictors    

preds

# there are the predictors: elevation, precipitation, temperature, vegetation

# let's explain to the software what are the training and predictors data 
datasdm <- sdmData(train=species, predictors=preds)

m1 <- sdm(Occurrence~temperature+elevation+precipitation+vegetation, data=datasdm, methods="glm")
# there are several methods that can be used. The Linear distribution is the most common one. When theere are several variables (as predictors), there is a generalized linear model (GLM) and it's based on the fact that there is a normal distribution. If there isn't a normal distribution, it's a generalized additive model and non-paramethrics data

# 12/01/22
# make the raster output layer
p1 <- predict(m1, newdata=preds)

plot(p1, col=cl)
points(presences, pch=19)

# we can make a final stack with the first prediction and the final map of the probability of distribution
s1 <- stack(preds, p1)
plot(s1, col=cl)

# it's possible to change the names of the stack, looking at the previous graph, which are:
names(s1) <- c('Elevation', 'Precipitation', 'Temperature', 'Vegetation', 'Probability')
# and plot the new stack
plot(s1, col=cl)
