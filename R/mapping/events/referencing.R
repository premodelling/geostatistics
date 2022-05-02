# Title     : referencing.R
# Objective : Referencing
# Created by: greyhypotheses
# Created on: 02/05/2022



#' Referencing
#'
#' Herein:
#'      The setting of CRS/SRID terms.
#'      Note, the longitude/latitude CRS is almost always EPSG:4326.
#'

london <- data.frame(longitude = 0.1, latitude = 51.5) %>%
  st_as_sf(coords = c('longitude','latitude'), crs = 4326)
london
st_is_longlat(london)

london <- data.frame(longitude = 0.1, latitude = 51.5) %>%
  st_as_sf(coords = c('longitude','latitude')) %>%
  st_set_crs(value = 'EPSG:4326')
london
st_is_longlat(london)

london <- data.frame(longitude = 0.1, latitude = 51.5) %>%
  st_as_sf(coords = c('longitude','latitude'))
st_crs(london) <- 'EPSG:4326'
london
st_is_longlat(london)
