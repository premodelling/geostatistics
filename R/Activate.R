# Title     : Activate.R
# Objective : Activate
# Created by: greyhypotheses
# Created on: 24/05/2023


#' Activate Libraries
#'
Activate <- function () {

  packages <- c('tidyverse', 'ggplot2', 'moments', 'rmarkdown', 'stringr', 'latex2exp', 'mapview', 'tseries',
                'roxygen2', 'healthcareai', 'equatiomatic', 'rstatix', 'matrixStats', 'patchwork', 'geoR', 'PrevMap',
                'kableExtra', 'bookdown', 'lme4', 'nlme', 'MASS', 'viridis', 'DescTools', 'sf', 'raster', 'tmap',
                'terra', 'spData', 'tidygeocoder', 'rnaturalearth', 'geodata', 'leaflet', 'splancs', 'spDataLarge')


  # Activate
  .activate <- function (x){
    library(x, character.only = TRUE)
    if (x == 'rmarkdown') {library(tinytex)}
  }
  lapply(packages[!(packages %in% c('tidyverse', 'healthcareai', 'equatiomatic',
                                    'tseries', 'terra', 'raster', 'spDataLarge'))], .activate)


  # Special Case
  if ('tidyverse' %in% packages) {
    lapply(X = c('magrittr', 'dplyr', 'tibble', 'ggplot2', 'stringr', 'lubridate'), .activate)
  }


  # Active libraries
  sessionInfo()

}