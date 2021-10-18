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
