# Title     : Rasters.R
# Objective : Rasters
# Created by: greyhypotheses
# Created on: 26/05/2023


Rasters <- function (blob) {

  # This creates, gets or sets a SpatExtent
  template <- terra::rast(terra::ext(blob), resolution = 500,
                          crs = st_crs(blob)$wkt)

  counts <- rasterize(vect(blob), template, fun = 'length')

  tm_shape(counts) +
    tm_layout(frame = FALSE, inner.margins = c(0.1, 0.1, 0.1, 0.1),
              legend.position = c('right', 'bottom')) +
    tm_raster(title = '', colorNULL = 'white')
  
}