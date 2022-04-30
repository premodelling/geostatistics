# Title     : interface.R
# Objective : Interface
# Created by: greyhypotheses
# Created on: 30/04/2022

source(file = 'R/mapping/io/Geocoding.R')
source(file = 'R/mapping/io/UTM.R')

# addresses of places
address <- c('Auckland, New Zealand', 'London, United Kingdom')

# get their longitude & latitude values via a geocoding service
latest <- AddressGeocoding(address = address)

# determie their UTM values via their longitude & latitude values
latest$utm <- mapply(FUN = UTM, longitude = latest$longitude, latitude = latest$latitude)
