# Title     : maps.R
# Objective : Play ground
# Created by: greyhypotheses
# Created on: 27/04/2022


# functions
source(file = 'R/mapping/encoding/UTM.R')
source(file = 'R/mapping/encoding/Geocoding.R')


# The loaloa data set
data(loaloa)
str(loaloa)
loaloa$prevalence <- loaloa$NO_INF/loaloa$NO_EXAM


# setting the reference coordinates
frame <- st_as_sf(loaloa, coords = c('LONGITUDE', 'LATITUDE')) %>%
  st_set_crs(value = 'EPSG:4326')
frame$longitude <- loaloa$LONGITUDE
frame$latitude <- loaloa$LATITUDE


# transforming
degrees <- AddressGeocoding(address = 'Yaounde, Cameroun')
utm <- UTM(longitude = degrees$longitude, latitude = degrees$latitude)
frame <- st_transform(frame, crs = paste0('EPSG:', utm))

frame$utm_x <- as.numeric(st_coordinates(frame, UTM)[, 1])
frame$utm_y <- as.numeric(st_coordinates(frame, UTM)[, 2])




#' Border
#'
#'

cameroun.adm0 <- st_read('data/shapes/cameroun/CMR_adm/CMR_adm0.shp')
cameroun.adm0 <- st_transform(cameroun.adm0, crs = paste0('EPSG:', utm))
st_crs(cameroun.adm0)

map.baseline <- tm_shape(cameroun.adm0) +
  tm_layout(main.title = 'Cameroun',  frame = FALSE) +
  tm_borders(lwd = 1, alpha = 0.35)

map.baseline +
  tm_shape(frame) +
  tm_dots(size = 0.5)

map.baseline +
  tm_shape(frame) +
  tm_bubbles(size = 'prevalence',
             col = 'prevalence',
             border.col = 'white',
             border.alpha = 0,
             title.size = 'Prevalence',
             scale = 1,
             title.col = '')

map.with.points <- map.baseline +
  tm_shape(frame) +
  tm_bubbles(size = 'prevalence',
             col = 'prevalence',
             border.col = 'white',
             border.alpha = 0,
             title.size = 'Prevalence',
             scale = 1,
             title.col = '')



#' Compass, scale bar, and legend.
#'

grounds <- map.with.points +
  tm_layout(legend.position = c('left', 'top')) +
  tm_compass(type = '8star', position = c('right', 'top')) +
  tm_scale_bar(breaks = c(0, 100, 200), text.size = 1, position = c('left', 'bottom'))
grounds


#' Interactive
#'

tmap_mode(mode = 'view')
map.with.points
tmap_mode(mode = 'plot')











