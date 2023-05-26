# Title     : liberia.R
# Objective : Liberia
# Created by: greyhypotheses
# Created on: 02/05/2022



rm(list = ls())

# functions
source(file = '../mapping/encoding/UTM.R')
source(file = '../mapping/encoding/Geocoding.R')

# reading-in the Liberia data set
frame <- read.csv(file = '../../data/frames/LiberiaRemoData.csv')
frame$prev <- frame$npos / frame$ntest



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



#' Liberia's waters
#'
liberia.wl <- st_read(dsn = file.path(getwd(), 'data/shapes/Liberia/LBR_wat/LBR_water_lines_dcw.shp'))
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



#' Liberia's elevations
#'
liberia.alt <- terra::rast(file.path(getwd(), 'data/shapes/Liberia/LBR_alt/LBR_alt.vrt'))
class(x = liberia.alt)
cat(crs(liberia.alt))
liberia.alt <- terra::project(liberia.alt, paste0('EPSG:', utm), method = 'bilinear')
class(x = liberia.alt)
cat(crs(liberia.alt))

# the elevations, and the country's border
tm_shape(liberia.alt) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_raster(title = 'Elevation') +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)

# the elevations within the country's border ONLY
terra::mask(liberia.alt, terra::vect(liberia.adm0)) %>%
  tm_shape() +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_raster(title = 'Elevation (m)') +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)

# mask
liberia.alt <- terra::mask(liberia.alt, terra::vect(liberia.adm0))
tm_shape(liberia.alt) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_raster(title = 'Elevation (m)') +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)

# get the elevation values
frame$my_elevation <- terra::extract(liberia.alt, terra::vect(liberia)) %>%
  dplyr::select(!ID) %>%
  unlist() %>%
  as.numeric()



#' Grids
#'

# a grid that has a resolution of 2 km by 2 km
liberia.grid <- sf::st_make_grid(liberia.adm0, cellsize = 2000, what = 'centers')
class(liberia.grid)
tm_shape(liberia.grid) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_dots() +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)

# the grid cells within Liberia ONLY
liberia.inside <- sf::st_intersects(liberia.grid, liberia.adm0, sparse = FALSE)
liberia.grid <- liberia.grid[liberia.inside]
class(liberia.grid)
tm_shape(liberia.grid) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_dots() +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)



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
tm_shape(terrains) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_raster(title = 'Distance from \nclosest waterway (km)') +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 0) +
  tm_shape(liberia.wl) +
  tm_lines(col = 'blue',
           palette = 'dodgerblue3',
           alpha = 0.35)

terra::writeRaster(x = terrains, filename = file.path(getwd(), 'images/liberia.tif'), overwrite = TRUE, filetype = 'GTiff')
terra::writeRaster(x = terrains, filename = file.path(getwd(), 'images/liberia.sgi'), overwrite = TRUE, filetype = 'SGI', datatype='INT1U')



#' Next administrative level
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
