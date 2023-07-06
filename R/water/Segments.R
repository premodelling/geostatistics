# Title     : Segments.R
# Objective : Segments
# Created by: greyhypotheses
# Created on: 06/07/2023


rm(list = ls())

# functions
source(file = file.path(getwd(), 'R', 'algorithms', 'encoding', 'UTM.R'))
source(file = file.path(getwd(), 'R', 'algorithms', 'encoding', 'Geocoding.R'))


Segments <- function () {

  # setting the reference coordinates
  degrees <- AddressGeocoding(address = 'River Thames, England')
  utm <- UTM(longitude = degrees$longitude, latitude = degrees$latitude)

  # A basin
  basin <- sf::st_read(dsn = file.path(getwd(),'data', 'shapes', 'catchments', 'thames',
                                       'district', 'WFD_River_Basin_Districts_Cycle_3.shp'))
  diagram <- st_transform(basin, crs = utm)

  # An illustration of the basin
  map <- tm_shape(diagram) +
    tm_layout(main.title = 'Basi', frame = FALSE) +
    tm_borders(lwd = 0.5)
  map



}