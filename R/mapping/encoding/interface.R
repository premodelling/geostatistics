# Title     : interface.R
# Objective : Interface
# Created by: greyhypotheses
# Created on: 30/04/2022

source(file = 'R/mapping/encoding/Geocoding.R')
source(file = 'R/mapping/encoding/UTM.R')

# addresses of places
address <- c('Auckland, New Zealand', 'Magway, Myanmar', 'London, United Kingdom', 'Yaounde, Cameroon', 'Monrovia, Liberia')

# get their longitude & latitude values via a geocoding service
latest <- AddressGeocoding(address = address)

# determine their UTM values via their longitude & latitude values
latest$utm <- mapply(FUN = UTM, longitude = latest$longitude, latitude = latest$latitude)
