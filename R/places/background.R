# Title     : background.R
# Objective : Background notes
# Created by: greyhypotheses
# Created on: 28/04/2022


rm(list = ls())

# functions
source(file = file.path(getwd(), 'R', 'mapping', 'encoding', 'UTM.R'))
source(file = file.path(getwd(), 'R', 'mapping', 'encoding', 'Geocoding.R'))

# data
data(world)
class(world)
names(world)

# world$geom is a list column
str(world)

# plot
plot(world)

# characteristics
summary(world[, 'lifeExp'])

# subsetting ... note, geometry columns are 'sticky'
world[1:2, 1:3]

# a selection of maps
plot(world[, c('continent', 'region_un', 'subregion', 'type')])
plot(world[, 'pop'], main = 'population')

# layers
frame <- world[world$continent == 'Asia', ]
asia <- sf::st_union(frame)
plot(world['pop'], main = 'population', reset = FALSE)
plot(asia, add = TRUE, col = 'red')

# setting the reference coordinates
degrees <- AddressGeocoding(address = 'Dodoma, Tanzania')
degrees
utm <- UTM(longitude = degrees$longitude, latitude = degrees$latitude)
utm
