# Title     : main.R
# Objective : main
# Created by: greyhypotheses
# Created on: 11/06/2023


rm(list = ls())



#' Shape Data/Archives
#' https://environment.data.gov.uk/catchment-planning
#'
extra <- list('anglian' = 5, 'dee' = 11, 'humber' = 4, 'north_wes' = 12, 'northumbria' = 3,
              'severn' = 9, 'solway_tweed' = 2, 'south_east' = 7, 'south_west' = 8, 'thames' = 9)
catchments <- names(extra)



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



# in parallel
source(file = file.path(getwd(), 'R', 'water', 'Segments.R'))
cores <- parallel::detectCores() - 2
doParallel::registerDoParallel(cores = cores)
clusters <- parallel::makeCluster(cores)
X <- parallel::clusterMap(clusters, fun = Segments, catchments, MoreArgs = list(frame = frame, utm = utm))
parallel::stopCluster(clusters)
rm(clusters, cores)

collection <- X %>%
  purrr::reduce(full_join, by='station_id')

computations <- dplyr::left_join(x = frame, y = collection, by = 'station_id')



#' Discharges
#'
#'
source(file = file.path(getwd(), 'R', 'water', 'Discharges.R'))
Discharges()
