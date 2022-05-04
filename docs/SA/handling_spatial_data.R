
rm(list=ls())



rb <- read.csv(file = 'data/frames/LiberiaRemoData.csv')
rb$prev <- rb$npos/rb$ntest



rb.sf <- st_as_sf(rb,coords = c('utm_x', 'utm_y'))
st_crs(rb.sf) <- 32629



liberia.adm0 <- st_read('data/shapes/Liberia/LBR_adm/LBR_adm0.shp')
liberia.adm0 <- st_transform(liberia.adm0,crs=32629)



map0 <- tm_shape(liberia.adm0) +
  tm_borders(lwd=3) 
map0



map0 +
  tm_shape(rb.sf) +
  tm_dots(size=0.5)



Map.with.points <- map0 +
  tm_shape(rb.sf) +
  tm_bubbles(size = 'prev', col = 'prev',
             border.col = 'black',
             style = 'fixed',
             breaks = seq(0,0.4,0.05),
             palette = '-RdYlBu',
             title.size = 'Prevalence',
             scale = 1,
             title.col = '')
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


liberia.alt <- raster::raster('data/shapes/Liberia/LBR_alt/LBR_alt.gri')
class(x = liberia.alt)
crs(liberia.alt)



liberia.alt <- raster::projectRaster(liberia.alt, crs = 'EPSG:32629')
class(x = liberia.alt)
crs(liberia.alt)



tm_shape(liberia.alt) +
  tm_raster(title = 'Elevation') +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)



raster::mask(liberia.alt, as(liberia.adm0, Class = 'Spatial')) %>%
  tm_shape() +
  tm_raster(title = 'Elevation (m)') +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)



liberia.alt <- raster::mask(liberia.alt, as(liberia.adm0, Class = 'Spatial'))
class(liberia.alt)
tm_shape(liberia.alt) +
  tm_raster(title = 'Elevation (m)') +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)



# extract
rb$my_elevation <- raster::extract(liberia.alt, rb.sf)



# a grid that has a resolution of 2 by 2 km
liberia.grid <- st_make_grid(liberia.adm0, cellsize = 2000, what = 'centers')
tm_shape(liberia.grid) +
  tm_dots() +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)



# subsetting the grid locations that fall inside Liberia
liberia.inout <- st_intersects(liberia.grid, liberia.adm0, sparse = FALSE)
liberia.grid <- liberia.grid[liberia.inout]
tm_shape(liberia.grid) +
  tm_dots() +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 2)



# per grid cell ... the distance between the grid cell's centre point and each water line, subsequently
# the minimum distance
dist <- apply(st_distance(liberia.grid, liberia.wl), MARGIN = 1, FUN = min)/1000
class(dist)
length(dist)



# a new object
dist.raster <- raster::rasterFromXYZ(cbind(st_coordinates(liberia.grid), dist), crs='+init=epsg:32629')
class(dist.raster)

tm_shape(dist.raster) +
  tm_layout(main.title = 'Liberia', frame = FALSE) +
  tm_raster(title = 'Distance from \nclosest waterway (km)') +
  tm_shape(liberia.adm0) +
  tm_borders(lwd = 0) +
  tm_shape(liberia.wl) +
  tm_lines(col = 'steelblue', lwd = 1)

writeRaster(dist.raster, filename = 'images/liberia.tif', format = 'GTiff', overwrite = TRUE)



#' Next administrative level
#'

liberia.adm2 <- st_read(dsn = 'data/shapes/liberia/LBR_adm/LBR_adm2.shp')
liberia.adm2 <- st_transform(liberia.adm2, crs = 32629)

names.adm2 <- liberia.adm2$NAME_2
n.adm2 <- length(names.adm2)
mean.elev <- rep(NA, n.adm2)

liberia.adm2$Mean_elevation <- NA
for (i in 1:n.adm2) {
  ind.sel <- names.adm2 == names.adm2[i]
  elev.r.i <- mask(liberia.alt, as(liberia.adm2[ind.sel,], Class = 'Spatial'))
  liberia.adm2$Mean_elevation[ind.sel] <- mean(values(elev.r.i), na.rm = TRUE)
}

map2 <- tm_shape(liberia.adm2) + tm_borders(lwd = 1)
map2 + tm_fill(col = 'Mean_elevation', title = 'Mean elevation (m)')

