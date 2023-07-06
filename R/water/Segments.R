# Title     : Segments.R
# Objective : Segments
# Created by: greyhypotheses
# Created on: 06/07/2023



#' Segments
#'
#' @param catchment
#' @param utm
#'
Segments <- function (frame, catchment, utm) {

  # Polygon
  basin <- sf::st_read(dsn = file.path(getwd(),'data', 'shapes', 'catchments', catchment,
                                       'district', 'WFD_River_Basin_Districts_Cycle_3.shp'))
  diagram <- st_transform(basin, crs = utm)
  map <- tm_shape(diagram) +
    tm_layout(main.title = 'Basin', frame = FALSE) +
    tm_borders(lwd = 0.5)
  map


  # ...
  T <- st_intersects(frame, diagram, sparse = FALSE)
  frame$place <- as.integer(T)
  colnames(frame)[colnames(frame) == 'place'] <- catchment

}



















