# Title     : querying.R
# Objective : Querying
# Created by: greyhypotheses
# Created on: 30/04/2022


#' Querying the details of a CRS/SRID
#'  CRS: Coordinate Reference System
#'  SRID: Spatial Reference Identifier
#' CRS & SRID are synonyms.

vector <- read_sf(system.file('shapes/world.gpkg', package = 'spData'))
sf::st_crs(x = vector)
sf::st_crs(x = vector)$IsGeographic
sf::st_crs(x = vector)$units_gdal
sf::st_crs(x = vector)$srid
sf::st_crs(x = vector)$proj4string

raster <- terra::rast(system.file('raster/srtm.tif', package = 'spDataLarge'))
cat(terra::crs(raster))








