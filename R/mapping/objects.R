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
london_geometry <- st_sfc(london_point, crs = 4326)
class(london_geometry)

# data.frame object
london_attributes <- data.frame(
  name = 'London', temperature = 25, date = as.Date(x = '2017-06-21'))
class(london_attributes)

# simple feature
london_sf <- sf::st_sf(london_attributes, geometry = london_geometry)
class(london_sf)



#' Setting the CRS/SRID
#' Note, the longitude/latitude CRS is almost always EPSG:4326.
#'

london <- data.frame(longitude = 0.1, latitude = 51.5) %>%
  st_as_sf(coords = c('longitude','latitude'), crs = 4326)
london
st_is_longlat(london)


london <- data.frame(longitude = 0.1, latitude = 51.5) %>%
  st_as_sf(coords = c('longitude','latitude')) %>%
  st_set_crs('EPSG:4326')
london
st_is_longlat(london)


london <- data.frame(longitude = 0.1, latitude = 51.5) %>%
  st_as_sf(coords = c('longitude','latitude'))
st_crs(london) <- 'EPSG:4326'
london
st_is_longlat(london)



#' Buffering
#'
#' unreference: CRS absent
#' geographic: unprojected

unreferenced <- data.frame(longitude = 0.1, latitude = 51.5) %>%
  st_as_sf(coords = c('longitude','latitude')) %>%
  st_buffer(dist = 1)

geographic <- data.frame(longitude = 0.1, latitude = 51.5) %>%
  st_as_sf(coords = c('longitude','latitude'), crs = 4326) %>%
  st_buffer(dist = 1e5)

projected <-  data.frame(x = 530000, y = 180000) %>%
  st_as_sf(coords = c('x', 'y'), crs = 'EPSG:27700') %>%
  st_buffer(dist = 1e5)






