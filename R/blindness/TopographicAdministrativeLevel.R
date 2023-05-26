# Title     : TopographicAdministrativeLevel.R
# Objective : Topographic administrative level
# Created by: greyhypotheses
# Created on: 26/05/2023


TopographicAdministrativeLevel <- function (utm, liberia.adm0) {

  #' Liberia's elevations
  #'
  liberia.alt <- terra::rast(file.path(getwd(), 'data/shapes/Liberia/LBR_alt/LBR_alt.vrt'))
  class(x = liberia.alt)
  cat(crs(liberia.alt))
  liberia.alt <- terra::project(liberia.alt, paste0('EPSG:', utm), method = 'bilinear')
  class(x = liberia.alt)
  cat(crs(liberia.alt))

  # the elevations, and the country's border
  diagram <- tm_shape(liberia.alt) +
    tm_layout(main.title = 'Liberia', frame = FALSE) +
    tm_raster(title = 'Elevation') +
    tm_shape(liberia.adm0) +
    tm_borders(lwd = 2)
  print(diagram)

  # the elevations within the country's border ONLY
  diagram <- terra::mask(liberia.alt, terra::vect(liberia.adm0)) %>%
    tm_shape() +
    tm_layout(main.title = 'Liberia', frame = FALSE) +
    tm_raster(title = 'Elevation (m)') +
    tm_shape(liberia.adm0) +
    tm_borders(lwd = 2)
  print(diagram)

  # mask
  liberia.alt <- terra::mask(liberia.alt, terra::vect(liberia.adm0))
  diagram <- tm_shape(liberia.alt) +
    tm_layout(main.title = 'Liberia', frame = FALSE) +
    tm_raster(title = 'Elevation (m)') +
    tm_shape(liberia.adm0) +
    tm_borders(lwd = 2)
  print(diagram)

  # get the elevation values
  frame$my_elevation <- terra::extract(liberia.alt, terra::vect(liberia)) %>%
    dplyr::select(!ID) %>%
    unlist() %>%
    as.numeric()



  #' Next, an administration level & topography
  #'
  liberia.adm2 <- st_read(dsn = file.path(getwd(), 'data/shapes/liberia/LBR_adm/LBR_adm2.shp'))
  liberia.adm2 <- st_transform(liberia.adm2, crs = utm)

  names.adm2 <- liberia.adm2$NAME_2
  n.adm2 <- length(names.adm2)
  mean.elev <- rep(NA, n.adm2)

  liberia.adm2$Mean_elevation <- NA
  for (i in 1:n.adm2) {
    ind.sel <- names.adm2 == names.adm2[i]
    elev.r.i <- terra::mask(liberia.alt, terra::vect(liberia.adm2[ind.sel,]))
    # elev.r.i <- mask(liberia.alt, as(liberia.adm2[ind.sel,], Class = 'Spatial'))
    liberia.adm2$Mean_elevation[ind.sel] <- mean(values(elev.r.i), na.rm = TRUE)
  }

  map2 <- tm_shape(liberia.adm2) +
    tm_borders(lwd = 1)
  map2 +
    tm_layout(main.title = 'Liberia', frame = FALSE) +
    tm_fill(col = 'Mean_elevation', title = 'Mean elevation (m)')

}