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

AlternativeAreaGrid <- function (area) {

  points <- st_make_grid(area, cellsize = 2000, what = 'centers')

  liberia.inside <- st_intersects(points, area, sparse = FALSE)
  points <- points[liberia.inside]
  frame <- data.frame(X = as.numeric(st_coordinates(points)[, 1]),
                      Y = as.numeric(st_coordinates(points)[, 2])) %>%
    st_as_sf(coords = c('X', 'Y'))
  st_crs(frame) <- st_crs(area)$srid

  return(frame)

}