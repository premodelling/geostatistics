# Title     : zealand.R
# Objective : New Zealand
# Created by: greyhypotheses
# Created on: 01/05/2022



# nz: https://geocompr.robinlovelace.net/spatial-operations.html
# I/O, Borders, File Formats, etc.:https://geocompr.robinlovelace.net/read-write.html
# tm_layout(): https://www.rdocumentation.org/packages/tmap/versions/3.3-3/topics/tm_layout



# cleaning-up
rm(list = ls())



# new zealand: spData::nz, spData::nz_height, spDataLarge::nz_elev
data(nz)
str(nz)

data(nz_height)
str(nz_height)

data(nz_elev)
str(nz_elev)



# the administrative boundaries
tm_shape(nz) +
  tm_layout(frame = FALSE) +
  tm_fill() +
  tm_borders()



# elevation
tm_shape(nz_elev) +
  tm_layout(frame = FALSE, legend.title.size = 2, legend.text.size = 1.05, legend.text.color = 'darkgrey',
            legend.position = c('left', 'top'), legend.height = 7) +
  tm_raster(title = "Elevation:")



# multiple shapes
#     tm_fill() + tm_borders() == tm_polygons()
#
map.baseline <- tm_shape(nz) +
  tm_layout(main.title = 'Baseline', frame = FALSE) +
  tm_polygons()

map.elevation <- map.baseline + tm_shape(nz_elev) +
  tm_layout(main.title = '+ Elevation',
            legend.position = c('left', 'center'),
            legend.title.fontfamily = 'gafata',
            legend.text.fontfamily = 'gafata',
            legend.text.size = 0.75,
            legend.text.color = 'black') +
  tm_raster(alpha = 0.7, title = 'Elevation (metres)')

nz_water <- st_union(nz) %>%
  st_buffer(dist = 22200) %>%
  st_cast(to = 'LINESTRING')

map.water <- map.elevation + tm_shape(nz_water) +
  tm_layout(main.title = '+ Surrounding Waters') +
  tm_lines()

map.highpoints <- map.water + tm_shape(nz_height) +
  tm_layout(main.title = '+ Highpoints') +
  tm_dots()

tmap::tmap_arrange(map.elevation, map.water, map.highpoints)




