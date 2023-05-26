# Title     : Projected.R
# Objective : Projected
# Created by: greyhypotheses
# Created on: 25/05/2023


#'
#' @note class(projected)
#'
#'
Projected <- function (blob) {

  projected <- st_transform(blob, crs = 'EPSG:27700')

  properties <- sf::st_crs(projected)

  diagram <- tm_shape(projected) +
    tm_layout(frame = FALSE, inner.margins = c(0.1, 0.1, 0.1, 0.1)) +
    tm_dots(size = 0.65, alpha = 0.35, border.lwd = 0)

  return(list(diagram = diagram, properties = properties, blob = projected))

}