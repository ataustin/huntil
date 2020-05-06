library(rvest)
library(jsonlite)
library(dplyr)
library(purrr)
library(leaflet)
library(htmltools)
library(colorout)

devtools::load_all()

# to refresh everything:
# site_data <- build_huting_site_data()

load("site_data.rda")
site_data$site_html <- lapply(site_data$site_html_char, xml2::read_html)

site_data_patched <- impute_missing_coords(site_data)
glimpse(site_data_patched)

site_data_patched <- mutate(site_data_patched,
                            popup = purrr::pmap_chr(list(site_name, url, species_row, lat, lon),
                                                     build_popup))

# make HTML map
site_data_patched %>%
  filter(is_species) %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(~lon, ~lat,
             popup = ~popup,
             label = ~site_name) %>%
  htmlwidgets::saveWidget(file = "test.html",
                          selfcontained = FALSE)
 

# TODO
# get seasons data to display
# get windshield card sites data
  # use crosstalk to link DT and leaflet for selecting sites -- windshield card

seasons_data <-
  get_fact_sheet_html() %>%
  get_fact_sheet_link("statewide seasons") %>%
  get_statewide_seasons_data()


clean_site_name <- function(site_name) {
  site_name <- gsub(" - .*", "", site_name)
  site_name <- gsub("(.*)", "", site_name)
  site_name <- gsub(" /.*", "", site_name)
  site_name <- gsub("sfwa", "", ignore.case = TRUE)
}
