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


  # Polygon
  basin <- sf::st_read(dsn = file.path(getwd(),'data', 'shapes', 'catchments', 'thames',
                                       'district', 'WFD_River_Basin_Districts_Cycle_3.shp'))
  diagram <- st_transform(basin, crs = utm)
  map <- tm_shape(diagram) +
    tm_layout(main.title = 'Basi', frame = FALSE) +
    tm_borders(lwd = 0.5)
  map


  # Coordinates
  # utils::read.csv()
  # readr::read_csv()
  url <- 'https://raw.githubusercontent.com/thirdreading/experiment/develop/warehouse/hydrometry/references/gazetteer.csv'
  stations <- data.table::fread(url, header = TRUE, encoding = 'UTF-8')


  # setting the reference coordinates
  frame <- st_as_sf(stations, coords = c('longitude', 'latitude')) %>%
    st_set_crs(value = 'EPSG:4326')
  frame$longitude <- stations$longitude
  frame$latitude <- stations$latitude


  # transforming
  frame <- st_transform(frame, crs = paste0('EPSG:', utm))
  frame$utm_x <- as.numeric(st_coordinates(frame, UTM)[, 1])
  frame$utm_y <- as.numeric(st_coordinates(frame, UTM)[, 2])



  # ...
  T <- st_intersects(frame, diagram, sparse = FALSE)
  frame$thames <- as.integer(T)



}



















