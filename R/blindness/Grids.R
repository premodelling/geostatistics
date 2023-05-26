# Title     : Grids.R
# Objective : Grids
# Created by: greyhypotheses
# Created on: 26/05/2023



#' Grids
#'

Grids <- function (utm, liberia.adm0, liberia.wl) {


  # a grid that has a resolution of 2 km by 2 km
  liberia.grid <- sf::st_make_grid(liberia.adm0, cellsize = 2000, what = 'centers')
  class(liberia.grid)
  diagram <- tm_shape(liberia.grid) +
    tm_layout(main.title = 'Liberia', frame = FALSE) +
    tm_dots() +
    tm_shape(liberia.adm0) +
    tm_borders(lwd = 2)
  print(diagram)



  # the grid cells within Liberia ONLY
  liberia.inside <- sf::st_intersects(liberia.grid, liberia.adm0, sparse = FALSE)
  liberia.grid <- liberia.grid[liberia.inside]
  class(liberia.grid)
  diagram <- tm_shape(liberia.grid) +
    tm_layout(main.title = 'Liberia', frame = FALSE) +
    tm_dots() +
    tm_shape(liberia.adm0) +
    tm_borders(lwd = 2)
  print(diagram)



  # per grid cell ... the distance between the grid cell's centre point and each water line, subsequently
  # the minimum distance
  distances <- apply(sf::st_distance(liberia.grid, liberia.wl), MARGIN = 1, FUN = min)/1000
  class(distances)
  length(distances)

  liberia.grid.data <- cbind(st_coordinates(liberia.grid), distances)
  class(liberia.grid.data)
  colnames(liberia.grid.data) <- c('x', 'y', 'distances')
  colnames(liberia.grid.data)

  terrains <- terra::rast(liberia.grid.data, type = 'xyz', crs = paste0('EPSG:', utm))
  diagram <- tm_shape(terrains) +
    tm_layout(main.title = 'Liberia', frame = FALSE) +
    tm_raster(title = 'Distance from \nclosest waterway (km)') +
    tm_shape(liberia.adm0) +
    tm_borders(lwd = 0) +
    tm_shape(liberia.wl) +
    tm_lines(col = 'blue',
             palette = 'dodgerblue3',
             alpha = 0.35)
  print(diagram)

  terra::writeRaster(x = terrains, filename = file.path(getwd(), 'images/liberia.tif'), overwrite = TRUE, filetype = 'GTiff')
  terra::writeRaster(x = terrains, filename = file.path(getwd(), 'images/liberia.sgi'), overwrite = TRUE, filetype = 'SGI', datatype='INT1U')

}

