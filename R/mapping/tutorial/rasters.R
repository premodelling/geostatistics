# Title     : rasters.R
# Objective : Rastering
# Created by: greyhypotheses
# Created on: 28/05/2022


# Example: Cycle Hire
cycle_hire_osm <- spData::cycle_hire_osm
class(cycle_hire_osm)
sf::st_crs(cycle_hire_osm)
tm_shape(cycle_hire_osm) +
  tm_layout(main.title = 'Cycle Points', frame = FALSE) +
  tm_dots()

cycle_hire_osm_projected <- st_transform(cycle_hire_osm, crs = 'EPSG:27700')
class(cycle_hire_osm_projected)
sf::st_crs(cycle_hire_osm_projected)

raster_template <- rast(ext(cycle_hire_osm_projected), resolution = 1000,
                        crs = st_crs(cycle_hire_osm_projected)$wkt)
class(raster_template)
terra::crs(raster_template) %>% cat()

counts <- rasterize(vect(cycle_hire_osm_projected), raster_template, fun = 'length')
class(counts)
tm_shape(counts) +
  tm_layout(main.title = 'Cycle Points', frame = FALSE) +
  tm_raster(title = '\nCapacity')


# Example: Riiver Blindness Experiment
drc <- st_read(dsn = 'data/shapes/drc/COD_adm/COD_adm0.shp')
class(drc)
st_crs(drc)
drc <- st_transform(drc, crs = 'EPSG:3857')
class(drc)
st_crs(drc)
tm_shape(drc) +
  tm_layout(frame = FALSE) +
  tm_borders()

instances <- read.csv(file = 'data/frames/experiment/instances.csv')
instances <- sf::st_as_sf(instances, coords = c('x', 'y'), crs = 'EPSG:3857')
instances$x <- as.numeric(st_coordinates(instances)[, 1])
instances$y <- as.numeric(st_coordinates(instances)[, 2])

sample <- read.csv(file = 'data/frames/experiment/features.csv')
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
