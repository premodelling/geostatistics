# Title     : Waters.R
# Objective : Waters
# Created by: greyhypotheses
# Created on: 26/05/2023



#' Liberia's waters
#'

Waters <- function (utm, grounds) {

  liberia.wl <- st_read(dsn = file.path(getwd(), 'data/shapes/Liberia/LBR_wat/LBR_water_lines_dcw.shp'))
  st_crs(x = liberia.wl)
  st_is_longlat(x = liberia.wl)
  liberia.wl <- st_transform(liberia.wl, crs = utm)
  st_crs(x = liberia.wl)

  diagram <- grounds +
    tm_shape(liberia.wl) +
    tm_lines(col = 'blue',
             palette = 'dodgerblue3',
             title.col = 'Waterways',
             alpha = 0.35)
  print(diagram)

  return(liberia.wl)

}
