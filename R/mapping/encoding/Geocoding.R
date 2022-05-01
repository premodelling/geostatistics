# Title     : Geocoding.R
# Objective : Geocoding
# Created by: greyhypotheses
# Created on: 30/04/2022



AddressGeocoding <- function (address) {

  queries <- data.frame(address = address)

  # the function geo(.) outlines the <method> options
  places <- geocode(queries, address = address, method = 'osm') %>%
    data.frame()

  latest <- dplyr::rename(places, 'longitude' = 'long', 'latitude' = 'lat')
  latest <- latest %>%
    sf::st_as_sf(coords = c('longitude','latitude'), crs = 'EPSG:4326', remove = FALSE)

  return(latest)

}
