# Title     : UTM.R
# Objective : Universal Transverse Mercator
# Created by: greyhypotheses
# Created on: 30/04/2022


#'
#' @description From a geographic coördinate system -> Universal Transverse Mercator
#'
#' @param longitude
#' @param latitude
#'
UTM <- function (longitude, latitude) {

  utm <- (floor((longitude + 180) / 6) %% 60) + 1

  if (latitude > 0) {
    utm + 32600
  } else{
    utm + 32700
  }

}