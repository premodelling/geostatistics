# Title     : Segments.R
# Objective : Segments
# Created by: greyhypotheses
# Created on: 06/07/2023



#' Segments
#'
#' @param catchment
#' @param utm
#'
Segments <- function (catchment, frame, utm) {

  # Polygon
  basin <- sf::st_read(dsn = file.path(getwd(),'data', 'shapes', 'catchments', catchment,
                                       'districts', 'WFD_River_Basin_Districts_Cycle_3.shp'))
  diagram <- sf::st_transform(basin, crs = utm)
  map <- tmap::tm_shape(diagram) +
    tmap::tm_layout(main.title = 'Basin', frame = FALSE) +
    tmap::tm_borders(lwd = 0.5)
  map


  # ...
  T <- sf::st_intersects(frame, diagram, sparse = FALSE)
  frame$place <- as.integer(T)
  colnames(frame)[colnames(frame) == 'place'] <- catchment

  reduced <- frame[, c('station_id', catchment)]

  return (sf::st_drop_geometry(reduced))

}



















