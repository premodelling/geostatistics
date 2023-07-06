# Title     : Discharges.R
# Objective : Discharges, Thames Water
# Created by: greyhypotheses
# Created on: 06/07/2023



# Setting-up
root <- 'https://prod-tw-opendata-app.uk-e1.cloudhub.io'
alerts <- '/data/STE/v1/DischargeAlerts'
states <- '/data/STE/v1/DischargeCurrentStatus'


#' Discharges
#'
#'
#'
Discharges <- function () {

  # Focusing on alerts
  url <- paste0(root, alerts)


  # Parameters
  params <- list('limit' = 1000, 'offset' = 0)


  # Credentials
  filestr <- file.path(getwd(), 'R', 'water', 'services.yaml')
  nodes <- yaml::yaml.load_file(input = filestr)
  excerpt <- nodes$services
  key <- excerpt[[1]]
  client <- list('id' = key$client_id,
                 'secret' = key$client_secret)


  # Query
  r <- httr::GET(url = url,
                 httr::add_headers(client_id = client$id, client_secret = client$secret),
                 query = params)


  # Unload
  if (httr::status_code(r) != 200) {
    warning(httr::status_code(r))
  } else {
    content <- httr::content(r)
    data <- dplyr::bind_rows(content$items)
  }


  # Previewing
  data


}