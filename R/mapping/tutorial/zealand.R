# Title     : zealand.R
# Objective : New Zealand
# Created by: greyhypotheses
# Created on: 01/05/2022



rm(list = ls())


# data
f <- system.file('shapes/world.gpkg', package = 'spData')
world <- read_sf(f, quiet = TRUE)

# curious
read_sf(f, query = 'SELECT * FROM world WHERE FID = 1')

# new zealand
nz <- read_sf(f, query = 'SELECT * FROM world WHERE name_long = "New Zealand"')
plot(nz)

nz <- ne_countries(country = 'New Zealand')
class(nz)
nz <- st_as_sf(nz)
class(nz)
plot(nz[, 'admin'])











