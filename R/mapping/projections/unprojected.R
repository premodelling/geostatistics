# Title     : unprojected.R
# Objective : An unprojected map
# Created by: greyhypotheses
# Created on: 28/04/2022


rm(list = ls())


# data
data(world)
class(world)
names(world)


# https://www.rdocumentation.org/packages/graphics/versions/3.6.2/topics/par
# mar = c(bottom, left, top, right)
par(mar = c(0, 0, 0, 0))


# key.pos: 1 bottom, 2 left, 3 top, 4 right
plot(world['continent'], reset = FALSE, key.pos = 1)

# extra
cex <- sqrt(world$pop) / 10000
centroids <- st_centroid(world, of_largest = TRUE)
plot(st_geometry(centroids), add = TRUE, cex = cex)