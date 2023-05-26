# Title     : Unlink.R
# Objective : Unlinking, deleting, objects.
# Created by: greyhypotheses
# Created on: 29/06/2022


#' Unlink Directories
#'
#' @description Deletes a directory recursively
#'
#' @param path: A directory path string
#'
UnlinkDirectories <- function (path) {

  if (dir.exists(paths = path)) {
    base::unlink(path, recursive = TRUE)
  }

}


#' Unlink Files
#'
#' @description Deletes a file
#'
#' @param path: A file's path & file name string, including the file name's extension
#'
UnlinkFiles <- function (path) {

  if (file.exists(base::dirname(path = path))) {
    base::unlink(path)
  }

}