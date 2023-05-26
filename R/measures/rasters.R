# Title     : rasters.R
# Objective : Rastering
# Created by: greyhypotheses
# Created on: 28/05/2022


# Example: River Blindness Experiment
drc <- st_read(dsn = file.path(getwd(), 'data', 'shapes', 'drc', 'COD_adm', 'COD_adm0.shp'))
class(drc)
st_crs(drc)
drc <- st_transform(drc, crs = 'EPSG:3857')
class(drc)
st_crs(drc)
tm_shape(drc) +
  tm_layout(frame = FALSE) +
  tm_borders()

instances <- read.csv(file = file.path(getwd(), 'data', 'frames', 'experiment', 'instances.csv'))
instances <- sf::st_as_sf(instances, coords = c('x', 'y'), crs = 'EPSG:3857')
instances$x <- as.numeric(st_coordinates(instances)[, 1])
instances$y <- as.numeric(st_coordinates(instances)[, 2])

sample <- read.csv(file = file.path(getwd(), 'data', 'frames', 'experiment', 'features.csv'))
sample <- sample %>%
  dplyr::select(features.index, x, y, AnnualPrecip)
features <- sf::st_as_sf(sample, coords = c('x', 'y'), crs = 'EPSG:3857')
features$x <- as.numeric(st_coordinates(features)[, 1])
features$y <- as.numeric(st_coordinates(features)[, 2])
class(features)
tm_shape(features) +
  tm_layout(frame = FALSE) +
  tm_dots()

template <- terra::rast(terra::ext(drc), resolution = 5000, crs = sf::st_crs(drc)$wkt)
points <- terra::rasterize(vect(features), template, field = 'AnnualPrecip', fun = mean)
class(points)

estimates <- terra::extract(points, terra::vect(instances), method = 'bilinear') %>%
  dplyr::select(!ID) %>%
  unlist() %>%
  as.numeric()
