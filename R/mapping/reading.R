# Title     : reading.R
# Objective : Reading geographic/spatial files
# Created by: greyhypotheses
# Created on: 28/04/2022


rm(list = ls())


# data
data(world)
class(world)
names(world)


# world$geom is a list column
str(world)


# reading
initial <- st_read(system.file('shapes/world.shp', package = 'spData'))
alternative <- read_sf(system.file('shapes/world.shp', package = 'spData'))