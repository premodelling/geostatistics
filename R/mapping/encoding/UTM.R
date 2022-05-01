# Title     : UTM.R
# Objective : Universal Transverse Mercator
# Created by: greyhypotheses
# Created on: 30/04/2022

UTM <- function (longitude, latitude) {

  utm <- (floor((longitude + 180) / 6) %% 60) + 1

  if (latitude > 0) {
    utm + 32600
  } else{
    utm + 32700
  }

}