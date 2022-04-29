# Title     : projected.R
# Objective : A projected map with graticules
# Created by: greyhypotheses
# Created on: 28/04/2022


rm(list = ls())


# data
data(world)
class(world)
names(world)


# https://proj-tmp.readthedocs.io/en/docs/operations/projections/index.html
# Eckert IV
world.projected <- sf::st_transform(world, crs = '+proj=eck4')

# https://r-spatial.github.io/sf/reference/index.html
centroids <- sf::st_centroid(x = world.projected, of_largest_polygon = TRUE)

# https://www.rdocumentation.org/packages/graphics/versions/3.6.2/topics/par
par(mar = c(0, 0, 0, 0))

# a layer
plot(world.projected['continent'], reset = FALSE, main = '', key.pos = NULL)

# https://r-spatial.github.io/sf/reference/st_graticule.html
g <- st_graticule()
g <- st_transform(g, crs = '+proj=eck4')

# a layer
plot(g$geometry, add = TRUE, col = 'lightgrey')

# a layer
# https://www.rdocumentation.org/packages/graphics/versions/3.6.2/topics/par
cex <- sqrt(world$pop) / 10000
plot(sf::st_geometry(centroids), add = TRUE, cex = cex, lwd = 2, graticule = TRUE)


