# Title     : liberia.R
# Objective : Liberia
# Created by: greyhypotheses
# Created on: 02/05/2022



rm(list = ls())

# functions
source(file = file.path(getwd(), 'R', 'algorithms', 'encoding', 'UTM.R'))
source(file = file.path(getwd(), 'R', 'algorithms', 'encoding', 'Geocoding.R'))
source(file = file.path(getwd(), 'R', 'blindness', 'TopographicAdministrativeLevel.R'))
source(file = file.path(getwd(), 'R', 'blindness', 'Waters.R'))
source(file = file.path(getwd(), 'R', 'blindness', 'Grids.R'))



#' Data
#'

# reading-in the Liberia river blindness data set
frame <- read.csv(file = file.path(getwd(), 'data', 'frames', 'LiberiaRemoData.csv'))

# prevalence
frame$prev <- frame$npos / frame$ntest

# empirical logit
frame$nneg <- frame$ntest - frame$npos
frame$EL <- log( (frame$npos + 0.5)/(frame$nneg + 0.5) )




#' Liberia's terrain
#'

# setting the reference coordinates
degrees <- AddressGeocoding(address = 'Monrovia, Liberia')
utm <- UTM(longitude = degrees$longitude, latitude = degrees$latitude)

# as a simple feature
liberia <- st_as_sf(frame, coords = c('utm_x', 'utm_y'))
st_crs(liberia) <- utm

# reading-in the shape file of Liberia's country border
liberia.adm0 <- st_read(dsn = 'data/shapes/Liberia/LBR_adm/LBR_adm0.shp')
liberia.adm0 <- st_transform(liberia.adm0, crs = utm)

# the border outline of Liberia
map0 <- tm_shape(liberia.adm0) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_borders(lwd = 0.5)
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
             breaks = seq(0, 0.4, 0.1),
             palette = '-RdYlBu',
             title.size = 'Onchocerciasis Prevalence',
             scale = 1,
             title.col = '')

# Positioning the legend,and adding a compass.
Map.with.points +
  tm_layout(legend.position = c('left', 'bottom')) +
  tm_compass(type = '8star', position = c('right', 'top'))

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



#' Finally
#'

TopographicAdministrativeLevel(utm = utm, liberia.adm0 = liberia.adm0)
liberia.wl <- Waters(utm = utm, grounds = grounds)
Grids(utm = utm, liberia.adm0 = liberia.adm0, liberia.wl = liberia.wl)
