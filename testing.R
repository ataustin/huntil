library(rvest)
library(jsonlite)
library(dplyr)
library(purrr)
library(leaflet)
library(htmltools)
library(colorout)

devtools::load_all()

# to refresh everything:
site_data <- build_hunting_site_data()

load("site_data.rda")
site_data$site_html <- lapply(site_data$site_html_char, xml2::read_html)

# make HTML map
site_data %>%
  filter(is_species) %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(~lon, ~lat,
             popup = ~popup,
             label = ~site_name) %>%
  htmlwidgets::saveWidget(file = "test.html",
                          selfcontained = FALSE)
 

# TODO
# get windshield card sites data
  # use crosstalk to link DT and leaflet for selecting sites -- windshield card

seasons_data <-
  get_fact_sheet_top_level_html() %>%
  get_fact_sheet_url("statewide seasons") %>%
  get_statewide_seasons_data()
