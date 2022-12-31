# Title     : sewer.R
# Objective : IHME LMIC WASH Estimates 2000 - 2017
# Created by: greyhypotheses
# Created on: 22/06/2022


source(file = 'R/functions/Unlink.R')


# A source example
url <- 'https://cloud.ihme.washington.edu/s/bkH2X2tFQMejMxy/download?path=%2FS_PIPED%20-%20Access%20to%20sewer%20and%20septic%20sanitation%20facilities%20%5BGeoTIFF%5D%2FPercent&files='
item <- 'IHME_LMIC_WASH_2000_2017_S_PIPED_PERCENT_UPPER_'
year <- 2017
date <- '_Y2020M06D02.TIF'


# Prepare
path <- file.path(getwd(), 'data', 'shapes', 'WASH', 'sewer', paste0(item, year, date))
UnlinkFiles(path = path)


# Unload map data
httr::GET(url = paste0(url, item, year, date),
          httr::write_disk(path = path),
          overwrite = TRUE)


# Read the map data
map <- terra::rast(file.path(getwd(), 'data', 'shapes', 'WASH', 'sewer', paste0(item, year, date)))
class(map)
cat(terra::crs(map))


# Illustrate
tm_shape(map, raster.downsample = TRUE) +
  tm_layout(title = 'LMIC', frame = FALSE, legend.position = c('right', 'bottom'), inner.margins = 0.1) +
  tm_raster(title = 'Sewers')


# A country; the CRS of GADM maps is EPSG:4326 [https://gadm.org/download_country.html]
boundaries <- geodata::gadm(country = 'Tanzania', level = 0, resolution = 1, path = tempdir(), version = '4.0')
class(boundaries)
cat(terra::crs(boundaries))

terra::crs(boundaries) <- 'EPSG:4326'
class(boundaries)
cat(terra::crs(boundaries))


# Intersection of geometries
terra::mask(map, boundaries) %>%
  tm_shape(raster.downsample = FALSE) +
  tm_layout(main.title = 'Tanzania', frame = FALSE) +
  tm_raster(title = 'Piped Sewer')
