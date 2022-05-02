# Title     : buffering.R
# Objective : Buffering
# Created by: greyhypotheses
# Created on: 02/05/2022



#' Buffering
#'
#' Herein:
#'      unreferenced: reference system absent
#'      geographic: unprojected
#'      projected: https://www.earthdatascience.org/courses/use-data-open-source-python/
#'                      + intro-vector-data-python/spatial-data-vector-shapefiles/
#'                          + geographic-vs-projected-coordinate-reference-systems-python

unreferenced <- data.frame(longitude = 0.1, latitude = 51.5) %>%
  st_as_sf(coords = c('longitude','latitude')) %>%
  st_buffer(dist = 1)

geographic.thin <- data.frame(longitude = 0.1, latitude = 51.5) %>%
  st_as_sf(coords = c('longitude','latitude'), crs = 'EPSG:4326') %>%
  st_buffer(dist = 1e5, max_cells = 1000)

geographic.jagged <- data.frame(longitude = 0.1, latitude = 51.5) %>%
  st_as_sf(coords = c('longitude','latitude'), crs = 'EPSG:4326') %>%
  st_buffer(dist = 1e5, max_cells = 100)

sf::sf_use_s2(use_s2 = FALSE)
geographic.disabled <- data.frame(longitude = 0.1, latitude = 51.5) %>%
  st_as_sf(coords = c('longitude','latitude'), crs = 'EPSG:4326') %>%
  st_buffer(dist = 1e5)
sf::sf_use_s2(use_s2 = TRUE)

projected <-  data.frame(x = 530000, y = 180000) %>%
  st_as_sf(coords = c('x', 'y'), crs = 'EPSG:27700') %>%
  st_buffer(dist = 1e5)

