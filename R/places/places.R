# Title     : places.R
# Objective : Places
# Created by: greyhypotheses
# Created on: 19/07/2022


rm(list = ls())


# data
data(world)
class(world)
names(world)


# layers
frame <- world[world$continent == 'Africa', ]
africa <- sf::st_union(frame)
sf::st_crs(africa)

frame <- world[world$name_long == 'Togo', ]
togo <- sf::st_union(frame)
sf::st_crs(togo)

rm(world, frame)


# boundary
tmap::tm_shape(togo) +
  tm_layout(main.title = 'Togo', frame = FALSE) +
  tm_borders(lwd = 3)


# elevations
elevations <- geodata::elevation_30s(country = 'TGO', path = tempdir())
class(elevations)
cat(terra::crs(elevations))


# elevations within boundary
focus <- terra::mask(elevations, terra::vect(togo))
tm_shape(focus) +
  tm_layout(main.title = 'Togo', frame = FALSE) +
  tm_raster(title = 'Elevation')


# directory
external <- file.path(getwd(), file.path(getwd(), 'warehouse', 'maps'))
if (dir.exists(external)) {
  base::unlink(x = external, recursive = TRUE)
}
dir.create(path = external, recursive = TRUE)


# write: raster
terra::writeRaster(focus, filename = file.path(external, 'TG.tif'), filetype = "COG", overwrite = TRUE)


# write: alternatives
# elevation <- tm_shape(focus) +
#   tm_layout(main.title = 'Togo', frame = FALSE) +
#   tm_raster(title = 'Elevation')
# tmap::tmap_save(elevation, filename = file.path(external, 'TG.png'))
# tmap::tmap_save(elevation, filename = file.path(external, 'TG.html'))
