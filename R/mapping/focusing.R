# Title     : focusing.R
# Objective : Focusing on an area
# Created by: greyhypotheses
# Created on: 28/04/2022


rm(list = ls())


# data
data(world)
class(world)
names(world)


# layers
frame <- world[world$continent == 'Asia', ]
asia <- sf::st_union(frame)


# asia
plot(asia, main = '', reset = FALSE)


# numeric; fractional values for expanding the bounding box in each
# direction (bottom, left, top, right)
india <- world[world$name_long == 'India', ]
plot(sf::st_geometry(india), expandBB = c(0, 0.2, 0.1, 1), col = 'grey', lwd = 3)
plot(asia[0], add = TRUE)

