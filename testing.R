library(rvest)
library(jsonlite)
library(dplyr)
library(purrr)

devtools::load_all()

site_url_data <-
  get_fact_sheet_top_level_html() %>%
  get_fact_sheet_url_data() %>%
  get_site_url_data()


species_table_data <-
  park_links[2:3] %>%
  get_park_htmls(species = "squirrel") %>%
  get_species_table_data()


geocoded_data <-
  read_park_kml() %>%
  get_geocoded_data()


automated_data_set <-




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
