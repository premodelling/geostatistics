# Title     : zealand.R
# Objective : New Zealand
# Created by: greyhypotheses
# Created on: 01/05/2022



# nz: https://geocompr.robinlovelace.net/spatial-operations.html
# I/O, Borders, File Formats, etc.:https://geocompr.robinlovelace.net/read-write.html
# tm_layout(): https://www.rdocumentation.org/packages/tmap/versions/3.3-3/topics/tm_layout


# cleaning-up
rm(list = ls())



# new zealand
data(spData::nz)
str(nz)

data(spData::nz_height)
str(nz_height)

data(spDataLarge::nz_elev)
str(nz_elev)


# the administrative boundaries
tm_shape(nz) +
  tm_layout(frame = FALSE) +
  tm_fill() +
  tm_borders()

tm_shape(nz) +
  tm_layout(frame = FALSE) +
  tm_polygons()








