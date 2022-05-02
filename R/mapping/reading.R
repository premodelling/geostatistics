# Title     : reading.R
# Objective : Reading geographic/spatial files
# Created by: greyhypotheses
# Created on: 28/04/2022


#' Reading
#'
#' Note:
#'      * st_read(): data.frame, read_sf(): tibble
#'      * By default rnaturalearth:: returns objects of class Spatial*.  The objects can be
#'        converted into sf objects via st_as_sf()
#'


rm(list = ls())



# data
data(world)
class(world)



# shp
world <- st_read(system.file('shapes/world.shp', package = 'spData'))
class(world)
world <- read_sf(system.file('shapes/world.shp', package = 'spData'))
class(world)



# gpkg
f <- system.file('shapes/world.gpkg', package = 'spData')
world <- read_sf(f, quiet = TRUE)
class(world)
nz <- read_sf(f, query = 'SELECT * FROM world WHERE name_long = "New Zealand"')
class(nz)
read_sf(f, query = 'SELECT * FROM world WHERE FID = 1')



# rnaturalearth: https://cloud.r-project.org/web/packages/rnaturalearth/index.html
nz <- rnaturalearth::ne_countries(country = 'New Zealand')
class(nz)
nz <- st_as_sf(nz)
class(nz)



# geodata: https://github.com/rspatial/geodata/
india <- geodata::gadm(country = 'India', level = 1, path = tempdir(), version = '4.0')
class(india)
india <- st_as_sf(india)
class(india)
plot(india[, 'COUNTRY'])
