# Title     : AreaGrid.R
# Objective : Area grid creation
# Created by: greyhypotheses
# Created on: 15/05/2022

BasicAreaGrid <- function (area) {

  points <- st_make_grid(area, cellsize = 2000, what = 'centers')

  liberia.inside <- st_intersects(points, area, sparse = FALSE)
  points <- points[liberia.inside]
  points <- st_coordinates(points)

  return(points)

}
