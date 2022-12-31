# Title     : Unlink.R
# Objective : Unlinking, deleting, objects.
# Created by: greyhypotheses
# Created on: 29/06/2022


UnlinkDirectories <- function (path) {

  if (dir.exists(paths = path)) {
    base::unlink(path, recursive = TRUE)
  }

}


UnlinkFiles <- function (path) {

  if (file.exists(base::dirname(path = path))) {
    base::unlink(path)
  }

}