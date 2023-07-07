# Title     : Link.R
# Objective : Link directories
# Created by: greyhypotheses
# Created on: 06/07/2023


LinkDirectories <- function (path) {

  if (!dir.exists(paths = path)) {
    dir.create(path = path, showWarnings = TRUE, recursive = TRUE)
  }

}