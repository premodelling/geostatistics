# Title     : zealand.R
# Objective : New Zealand
# Created by: greyhypotheses
# Created on: 01/05/2022


# I/O, Borders, File Formats, etc.:https://geocompr.robinlovelace.net/read-write.html
# tm_layout(): https://www.rdocumentation.org/packages/tmap/versions/3.3-3/topics/tm_layout


# cleaning-up
rm(list = ls())


# data
f <- system.file('shapes/world.gpkg', package = 'spData')


# curious
world <- read_sf(f, quiet = TRUE)
read_sf(f, query = 'SELECT * FROM world WHERE FID = 1')



# New Zealand: Option I
#
nz <- read_sf(f, query = 'SELECT * FROM world WHERE name_long = "New Zealand"')
plot(nz[, 'name_long'], main = 'New Zealand')



# New Zealand: Option II
#
# ... by default rnaturalearth returns objects of class Spatial*
# ... the objects can be converted into sf objects via st_as_sf()
nz <- rnaturalearth::ne_countries(country = 'New Zealand')
class(nz)
nz <- st_as_sf(nz)
class(nz)

# the administrative boundaries
tm_shape(nz) +
  tm_layout(frame = FALSE) +
  tm_fill()









