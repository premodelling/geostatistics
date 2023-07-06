# Title     : Unload.R
# Objective : Unload
# Created by: greyhypotheses
# Created on: 06/07/2023


#' Unload
#'
#' @note https://environment.data.gov.uk/catchment-planning
#'
#' @param number: A `river basin district` catchment number
#' @param text: The catchment's name
#'
#'
Unload <- function (number, text) {

  url <- glue::glue('https://environment.data.gov.uk/catchment-planning/RiverBasinDistrict/{as.character(number)}/shapefile.zip')

  temp <- base::tempfile()
  utils::download.file(url = url, temp)
  utils::unzip(temp, files = NULL, list = FALSE, overwrite = TRUE,
               junkpaths = FALSE, exdir = file.path(getwd(), 'data', 'shapes', 'catchments', text),
               unzip = "internal", setTimes = FALSE)
  unlink(temp)

}