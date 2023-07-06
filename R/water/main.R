# Title     : main.R
# Objective : main
# Created by: greyhypotheses
# Created on: 11/06/2023


rm(list = ls())


# Setting-up
root <- 'https://prod-tw-opendata-app.uk-e1.cloudhub.io'
alerts <- '/data/STE/v1/DischargeAlerts'
states <- '/data/STE/v1/DischargeCurrentStatus'
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

data




