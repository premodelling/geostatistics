# Title     : referencing.R
# Objective : Referencing
# Created by: greyhypotheses
# Created on: 02/05/2022



#' Referencing
#'
#' Herein:
#'      The setting of CRS (Coordinate Reference System) / SRID (Spatial Reference Identifier) terms.  CRS & SRID
#'      are synonyms.  And, inspecting CRS/SRID characteristics.
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



vector <- read_sf(system.file('shapes/world.gpkg', package = 'spData'))
sf::st_crs(x = vector)
sf::st_crs(x = vector)$IsGeographic
sf::st_crs(x = vector)$units_gdal
sf::st_crs(x = vector)$srid
sf::st_crs(x = vector)$proj4string



raster <- terra::rast(system.file('raster/srtm.tif', package = 'spDataLarge'))
cat(terra::crs(raster))
