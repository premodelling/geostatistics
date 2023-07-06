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


# in parallel
source(file = file.path(getwd(), 'R', 'water', 'Segments.R'))
cores <- parallel::detectCores() - 2
doParallel::registerDoParallel(cores = cores)
clusters <- parallel::makeCluster(cores)
X <- parallel::clusterMap(clusters, fun = Segments, catchments,
                     MoreArgs = list(frame = frame, utm = utm))
parallel::stopCluster(clusters)
rm(clusters, cores)

X %>%
  purrr::reduce(full_join, by='station_id')


#' Discharges
#'
#'
source(file = file.path(getwd(), 'R', 'water', 'Discharges.R'))
Discharges()








