# Title     : Unloading.R
# Objective : Unloading
# Created by: greyhypotheses
# Created on: 07/07/2023


source(file = file.path(getwd(), 'R', 'water', 'Unload.R'))

Unloading <- function (numbers, districts) {

  cores <- parallel::detectCores() - 2
  doParallel::registerDoParallel(cores = cores)
  clusters <- parallel::makeCluster(cores)
  parallel::clusterMap(clusters, fun = Unload, numbers, districts)
  parallel::stopCluster(clusters)
  rm(clusters, cores)

}