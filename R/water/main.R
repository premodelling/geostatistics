# Title     : main.R
# Objective : main
# Created by: greyhypotheses
# Created on: 11/06/2023


rm(list = ls())


#' Segments
#'
#'

# functions
source(file = file.path(getwd(), 'R', 'algorithms', 'encoding', 'UTM.R'))
source(file = file.path(getwd(), 'R', 'algorithms', 'encoding', 'Geocoding.R'))

# setting the reference coordinates
degrees <- AddressGeocoding(address = 'England')
utm <- UTM(longitude = degrees$longitude, latitude = degrees$latitude)

# data
source(file = file.path(getwd(), 'R', 'water', 'SegmentsData.R'))
frame <- SegmentsData(utm = utm)

# catchments
catchments <- c('anglian', 'humber', 'thames')



#' Discharges
#'
#'
source(file = file.path(getwd(), 'R', 'water', 'Discharges.R'))
Discharges()








