# Title     : Link.R
# Objective : Link directories
# Created by: greyhypotheses
# Created on: 30/06/2022


LinkDirectories <- function (path) {

  if (!dir.exists(paths = path)) {
    dir.create(path = path, showWarnings = TRUE, recursive = TRUE)
  }

}