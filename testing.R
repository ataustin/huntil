library(rvest)
library(jsonlite)
library(dplyr)
library(purrr)
library(leaflet)
library(htmltools)

devtools::load_all()

# to refresh everything:
# site_data <- build_huting_site_data()

load("site_data.rda")
site_data$site_html <- lapply(site_data$site_html_char, xml2::read_html)


# Google maps directions FROM btfld & 53 TO site lat/lon
# https://www.google.com/maps/dir/41.83119,-88.054425/41.20016,-87.9859/

x <- site_data %>% mutate(popup          = purrr::pmap_chr(list(site_name, site_url, species_row, lat, lon),
                                                              build_popup)
)

x %>%
  filter(is_species) %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(~lon, ~lat,
             popup = ~popup,
             label = ~site_name) %>%
  htmlwidgets::saveWidget(file = "test.html",
                          selfcontained = FALSE)

# TODO
# fix GPS for no-show locations like Iroquois -- requires manual table match!
# use crosstalk to link DT and leaflet for selecting sites -- windshield card
# get seasons data to display
# get windshield card sites data

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
