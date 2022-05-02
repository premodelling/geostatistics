# Title     : objects.R
# Objective : Simple Features objects
# Created by: greyhypotheses
# Created on: 29/04/2022


#' Creating an sf class object
#' the sf class: geometries + non-geographic attributes
#'

# simple features geometry object
london_point <- sf::st_point(x = c(0.1, 51.5))
class(london_point)

# simple features columns object
london_geometry <- st_sfc(london_point) %>%
  st_set_crs(value = 'EPSG:4326')
class(london_geometry)

# data.frame object
london_attributes <- data.frame(
  name = 'London', temperature = 25, date = as.Date(x = '2017-06-21'))
class(london_attributes)

# simple feature
london_sf <- sf::st_sf(london_attributes, geometry = london_geometry)
class(london_sf)











