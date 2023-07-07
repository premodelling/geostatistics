# Title     : Intersections.R
# Objective : Intersections
# Created by: greyhypotheses
# Created on: 06/07/2023



#' Segments
#'
#' @param district: The name of a river basin  district
#' @param frame: Which records of <frame> lie within the district?
#' @param utm: Universal Transverse Mercator code
#'
Intersections <- function (district, frame, utm) {


  # Polygon
  basin <- sf::st_read(dsn = file.path(getwd(),'data', 'shapes', 'basin', 'districts', district,
                                       'WFD_River_Basin_Districts_Cycle_3.shp'))
  diagram <- sf::st_transform(basin, crs = utm)
  map <- tmap::tm_shape(diagram) +
    tmap::tm_layout(main.title = 'Basin', frame = FALSE) +
    tmap::tm_borders(lwd = 0.5)
  map


  # Points of <frame> within <diagram>
  T <- sf::st_intersects(frame, diagram, sparse = FALSE)
  frame$place <- as.integer(T)
  colnames(frame)[colnames(frame) == 'place'] <- district


  # Focusing on firld <station_id>, and the district field, only.
  reduced <- frame[, c('station_id', district)]


  return (sf::st_drop_geometry(reduced))

}



















