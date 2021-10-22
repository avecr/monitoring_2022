# This is my first code in github 

# Here are the input data
# Costanza data on streams
water <- c(100, 200, 300, 400, 500)

# Marta data on fishes genomes
fishes <- c(10, 50, 60, 100, 200)

# plot the diversity o fishes (y) versus the amount of water (x)
# the function is used with arguments inside 
plot(water, fishes)

# the data that we developed can be storage in a table
# a table in R is called data frame 

streams <- data.frame(water, fishes)

# from now on we are going to import and/export data

# setwd("/Users/anareis/OneDrive/MECF_R_Project/lab")
setwd("/Users/anareis/OneDrive/MECF_R_Project/lab")

# let's export our table!
# https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/write.table
write.table(streams, file="my_first_table.txt")

# some collegues did send us a table How to import it in R?
read.table("my_first_table.txt")

# let's assign it ot an object inside R
anatable <- read.table("my_first_table.txt")

# the first statistics for lazy beautiful people
summary(anatable)

# Marta does not like water
# Marta wants to get info only on fishes
summary(anatable$fishes)

# histogram 
hist(anatable$fishes)
hist(anatable$water)
