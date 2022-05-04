# Title     : liberia.R
# Objective : Liberia
# Created by: greyhypotheses
# Created on: 02/05/2022



rm(list = ls())



# functions
source(file = 'R/mapping/encoding/UTM.R')
source(file = 'R/mapping/encoding/Geocoding.R')


# reading-in the Liberia data set
frame <- read.csv(file = 'data/frames/LiberiaRemoData.csv')
frame$prev <- frame$npos / frame$ntest




#' Liberia's terrain
#'

# setting the reference coordinates
degrees <- AddressGeocoding(address = 'Monrovia, Liberia')
utm <- UTM(longitude = degrees$longitude, latitude = degrees$latitude)
liberia <- st_as_sf(frame, coords = c('utm_x', 'utm_y'))
st_crs(liberia) <- utm


# reading-in the shape file of Liberia's country border
liberia.adm0 <- st_read(dsn = 'data/shapes/Liberia/LBR_adm/LBR_adm0.shp')
liberia.adm0 <- st_transform(liberia.adm0, crs = utm)


# the border outline of Liberia
map0 <- tm_shape(liberia.adm0) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_borders(lwd = 3)
map0


# preview what happens w.r.t. overlaying event points as dots; points encoded by <liberia$geometry>
map0 +
  tm_shape(liberia) +
  tm_dots(size = 0.5)


# adding a layer of event points whereby the points are bubbles
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


# Adding a compass, and a scale bar.  Positioning the legend.
grounds <- Map.with.points +
  tm_layout(legend.position = c('right', 'top')) +
  tm_compass(type = '8star', position = c('left', 'top')) +
  tm_scale_bar(breaks = c(0, 100, 200), text.size = 1, position = c('left', 'bottom'))
grounds




#' Interactive
#'

tmap_mode(mode = 'view')
Map.with.points +
  tm_compass(type = '8star', position = c('right', 'top')) +
  tm_scale_bar(breaks = c(0, 100, 200), text.size = 1, position = c('left', 'bottom')) +
  tm_view(view.legend.position = c('right', 'top'))
tmap_mode(mode = 'plot')




#' Liberia's waters
#'

liberia.wl <- st_read(dsn = 'data/shapes/Liberia/LBR_wat/LBR_water_lines_dcw.shp')
st_crs(x = liberia.wl)
st_is_longlat(x = liberia.wl)
liberia.wl <- st_transform(liberia.wl, crs = utm)
st_crs(x = liberia.wl)


grounds +
  tm_shape(liberia.wl) +
  tm_lines(col = 'blue',
           palette = 'dodgerblue3',
           title.col = 'Waterways',
           alpha = 0.35)


liberia.alt <- terra::rast('data/shapes/Liberia/LBR_alt/LBR_alt.vrt')
class(x = liberia.alt)
cat(crs(liberia.alt))

liberia.alt <- terra::project(liberia.alt, paste0('EPSG:', utm), method = 'bilinear')
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


frame$my_elevation <- terra::extract(liberia.alt, terra::vect(liberia)) %>%
  dplyr::select(!ID) %>%
  unlist() %>%
  as.numeric()





