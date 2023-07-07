# Title     : main.R
# Objective : main
# Created by: greyhypotheses
# Created on: 11/06/2023


rm(list = ls())
source(file = file.path(getwd(), 'R', 'functions', 'Unlink.R'))
source(file = file.path(getwd(), 'R', 'functions', 'Link.R'))



#' Shape Data/Archives
#' https://environment.data.gov.uk/catchment-planning
#'
extra <- list('anglian' = 5, 'dee' = 11, 'humber' = 4, 'north_west' = 12, 'northumbria' = 3,
              'severn' = 9, 'solway_tweed' = 2, 'south_east' = 7, 'south_west' = 8, 'thames' = 9)
districts <- names(extra)
numbers <- unlist(unname(extra))



#' Geography
#' Setting the reference coordinates
#'
source(file = file.path(getwd(), 'R', 'algorithms', 'encoding', 'UTM.R'))
source(file = file.path(getwd(), 'R', 'algorithms', 'encoding', 'Geocoding.R'))

degrees <- AddressGeocoding(address = 'England')
utm <- UTM(longitude = degrees$longitude, latitude = degrees$latitude)



#' Unload Shapes
#'
#'
source(file = file.path(getwd(), 'R', 'water', 'Unloading.R'))
UnlinkDirectories(path = file.path(getwd(), 'data', 'shapes', 'basin', 'districts'))
Unloading(numbers = numbers, districts = districts)



#' Gazetteer
#'
#'
source(file = file.path(getwd(), 'R', 'water', 'GetGazetteer.R'))
frame <- GetGazetteer(utm = utm)



#' Intersections
#'
#'
source(file = file.path(getwd(), 'R', 'water', 'Intersections.R'))
cores <- parallel::detectCores() - 2
doParallel::registerDoParallel(cores = cores)
clusters <- parallel::makeCluster(cores)
X <- parallel::clusterMap(clusters, fun = Intersections, districts, MoreArgs = list(frame = frame, utm = utm))
parallel::stopCluster(clusters)
rm(clusters, cores)

collection <- X %>%
  purrr::reduce(full_join, by='station_id')

computations <- dplyr::left_join(x = frame, y = collection, by = 'station_id')



#' Storage
#'
#'
storage <- file.path(getwd(), 'warehouse', 'hydrometry', 'references')
UnlinkDirectories(path = storage)
LinkDirectories(path = storage)

utils::write.table(x = computations,
                   file = file.path(storage, 'gazetteer.csv'),
                   append = FALSE,
                   sep = ',',
                   row.names = FALSE,
                   col.names = TRUE,
                   fileEncoding = 'UTF-8')



#' Discharges
#'
#'
source(file = file.path(getwd(), 'R', 'water', 'discharges/Discharges.R'))
Discharges()
