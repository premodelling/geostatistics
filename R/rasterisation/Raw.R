# Title     : Raw.R
# Objective : Raw
# Created by: greyhypotheses
# Created on: 24/05/2023



Raw <- function () {

  library(tmap)


  cycle_hire_osm <- spData::cycle_hire_osm


  properties <- sf::st_crs(cycle_hire_osm)


  diagram <- tm_shape(cycle_hire_osm) +
    tm_layout(main.title = 'Cycle Points', main.title.position = 0.125,
              frame = FALSE, inner.margins = c(0.1, 0.1, 0.1, 0.1)) +
    tm_dots(size = 0.85, alpha = 0.35, border.lwd = 0)



  return(list(diagram = diagram, properties = properties))
}