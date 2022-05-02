# Title     : liberia.R
# Objective : Liberia
# Created by: greyhypotheses
# Created on: 02/05/2022


rm(list = ls())


frame <- read.csv(file = 'data/frames/LiberiaRemoData.csv')
frame$prev <- frame$npos / frame$ntest


liberia <- st_as_sf(frame, coords = c('utm_x', 'utm_y'))
st_crs(liberia) <- 32629


liberia.adm0 <- st_read('data/shapes/Liberia/LBR_adm/LBR_adm0.shp')
liberia.adm0 <- st_transform(liberia.adm0, crs = 32629)


map0 <- tm_shape(liberia.adm0) +
  tm_borders(lwd = 3)
map0


map0 +
  tm_shape(liberia) +
  tm_dots(size = 0.5)


Map.with.points <- map0 +
  tm_shape(liberia) +
  tm_bubbles(size = 'prev', col = 'prev',
             border.col = 'white',
             border.alpha = 0,
             style = 'fixed',
             breaks = seq(0, 0.4, 0.05),
             palette = '-RdYlBu',
             title.size = 'Prevalence',
             scale = 1,
             title.col = 'Prevalence')
Map.with.points


Map.with.points <- Map.with.points +
  tm_compass(type = '8star', position = c('right', 'top')) +
  tm_scale_bar(breaks = c(0, 100, 200), text.size = 1, position = c('center', 'bottom'))
Map.with.points


tmap_mode(mode = 'view')
Map.with.points
tmap_mode(mode = 'plot')


liberia.wl <- st_read(dsn = 'data/shapes/Liberia/LBR_wat/LBR_water_lines_dcw.shp')
st_crs(x = liberia.wl)
st_is_longlat(x = liberia.wl)


liberia.wl <- st_transform(liberia.wl, crs = 32629)
st_crs(x = liberia.wl)


Map.with.points +
  tm_shape(liberia.wl) +
  tm_lines(col = 'blue',
           palette = 'dodgerblue3',
           title.col = 'Waterways')


liberia.alt <- terra::rast('data/shapes/Liberia/LBR_alt/LBR_alt.vrt')
class(x = liberia.alt)
cat(crs(liberia.alt))

liberia.alt <- terra::project(liberia.alt, 'EPSG:32629', method = 'bilinear')
class(x = liberia.alt)
cat(crs(liberia.alt))


tm_shape(liberia.alt) +
  tm_raster(title = 'Elevation') +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)


terra::mask(liberia.alt, terra::vect(liberia.adm0)) %>%
  tm_shape() +
  tm_raster(title = 'Elevation (m)') +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)


liberia.alt <- mask(liberia.alt, terra::vect(liberia.adm0))
tm_shape(liberia.alt) +
  tm_raster(title = 'Elevation (m)') +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)


class(liberia.alt)


frame$my_elevation <- terra::extract(liberia.alt, terra::vect(liberia)) %>%
  dplyr::select(!ID) %>%
  unlist() %>%
  as.numeric()





