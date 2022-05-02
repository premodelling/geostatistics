# Title     : reading.R
# Objective : Reading geographic/spatial files
# Created by: greyhypotheses
# Created on: 28/04/2022


rm(list = ls())



# data
data(world)
class(world)



# ... shp
#     st_read(): data.frame, read_sf(): tibble
world <- st_read(system.file('shapes/world.shp', package = 'spData'))
class(world)
world <- read_sf(system.file('shapes/world.shp', package = 'spData'))
class(world)


# ... gpkg
f <- system.file('shapes/world.gpkg', package = 'spData')
world <- read_sf(f, quiet = TRUE)
class(world)
nz <- read_sf(f, query = 'SELECT * FROM world WHERE name_long = "New Zealand"')
class(nz)
read_sf(f, query = 'SELECT * FROM world WHERE FID = 1')



# ... by default rnaturalearth returns objects of class Spatial*
# ... the objects can be converted into sf objects via st_as_sf()
nz <- rnaturalearth::ne_countries(country = 'New Zealand')
class(nz)
nz <- st_as_sf(nz)
class(nz)


# ... https://github.com/rspatial/geodata/
Z <- geodata::gadm(country = 'India', level = 1, path = tempdir(), version = '4.0')
class(Z)
india <- st_as_sf(Z)
plot(india[, 'COUNTRY'])


