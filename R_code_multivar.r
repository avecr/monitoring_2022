# this code will be used for the statistical analysis of different ecological levels (communities, populations and individuals)

# the package used is the vegan package, which means "vegetation analysis", but it contains statistics used also with animals  
install.packages("vegan")

library(vegan)

# set the working directory
setwd("/Users/anareis/OneDrive/MECF_R_Project/lab")

# reload the data (from the lab folder) that it's going to be used, in this case, a "rdata" which is a project with all the data inside it  
load("biomes_multivar.rdata")

# list files inside this dataset with the ls function (list of objects)
ls()

# to see the components of each one of a certain dataset (eg "biomes"), just need to right the data name
biomes # matrix of plots versus species

biomes_types # biome type per each plot sampled

# make use of the trended correspondence analysis in R decorana funtion
multivar <- decorana(biomes)
multivar # to see output: there are 4 axis (DCA1, DCA2, DCA3, DCA4)
# with the 1st (highest amount of variability) and 2nd axis, we have a total variability of 81%. So, it is possible to compact the system to two axis (DCA1 and DCA2)

# using both axis to plot
plot(multivar)

# plot the type of the biome to check if those species are really present in that biome
# let's take a look at the grouping of species. Are them in the same biome?
# first, we are going to attach function to attach the biomes types
attach(biomes_types)
# here we make ellipses to group the species of a certain biome (ordiellipse function), and the collum "type" is going to be used
ordiellipse(multivar, type, col=c("black","red","green","blue"), kind="ehull", lwd=3) # the colors were chosen randomly and represents the 4 biomes under study

# going to use the ordispider function now: basically, it joins in the label the single plots
ordispider(multivar, type, col=c("black","red","green","blue"), label=T)

# let's see how the abundances of the individuals are connected to each other
# we're going to the community level, thus the sdm package must be installed
# this is in the "R_code_sdm.r"
