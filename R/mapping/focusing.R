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


# expandBB: numeric; fractional values for expanding the bounding box in each
# direction (bottom, left, top, right)
india <- world[world$name_long == 'India', ]
china <- world[world$name_long == 'China', ]

plot(sf::st_geometry(india), add = TRUE, expandBB = c(0, 0.2, 0.1, 1), col = 'grey', lwd = 3)
plot(sf::st_geometry(china), add = TRUE)


# ?the use of [0] to keep only the geometry column
plot(asia[0], add = TRUE)






