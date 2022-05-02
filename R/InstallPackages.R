# Title     : InstallPackages.R
# Objective : Install and activate packages
# Created by: greyhypotheses
# Created on: 25/04/2022


#' Official packages
InstallPackagesOfficial <- function (){

  packages <- c('tidyverse', 'ggplot2', 'moments', 'rmarkdown', 'stringr', 'latex2exp', 'mapview', 'tseries',
                'roxygen2', 'healthcareai', 'equatiomatic', 'rstatix', 'matrixStats', 'patchwork', 'geoR', 'PrevMap',
                'kableExtra', 'bookdown', 'lme4', 'nlme', 'MASS', 'viridis', 'DescTools', 'sf', 'raster', 'tmap',
                'terra', 'spData', 'tidygeocoder', 'rnaturalearth', 'geodata', 'leaflet')

  # Install
  .install <- function(x){
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      if (x == 'rmarkdown') {tinytex::install_tinytex()}
    }
  }
  lapply(packages, .install)

  # Activate
  .activate <- function (x){
    library(x, character.only = TRUE)
    if (x == 'rmarkdown') {library(tinytex)}
  }
  lapply(packages[!(packages %in% c('tidyverse', 'healthcareai', 'equatiomatic', 'tseries'))], .activate)

  # Special Case
  if ('tidyverse' %in% packages) {
    lapply(X = c('magrittr', 'dplyr', 'tibble', 'ggplot2', 'stringr', 'lubridate'), .activate)
  }

  # Active libraries
  sessionInfo()

}


#' Packages in development
InstallPackagesExtraeous <- function () {

  packages <- 'spDataLarge'
  repositories <- 'https://nowosad.r-universe.dev'

  # Install
  .install <- function(x, y){
    if (!require(x, character.only = TRUE)) {
      install.packages(x, repos = y, dependencies = TRUE)
      if (x == 'rmarkdown') {tinytex::install_tinytex()}
    }
  }
  mapply(FUN = .install, x = packages, y = repositories)

  # Activate
  .activate <- function (x){
    library(x, character.only = TRUE)
  }
  lapply(packages, .activate)

}